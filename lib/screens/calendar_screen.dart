import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/exam.dart';
import '../models/subject.dart';
import '../providers/grade_provider.dart';
import '../services/google_calendar_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/translated_text.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  Future<void> _exportExamToCalendar(
    BuildContext context,
    Exam exam,
    String subjectName,
  ) async {
    final service = GoogleCalendarService();
    final messenger = ScaffoldMessenger.of(context);
    final success = await service.addExamToCalendar(exam, subjectName);

    messenger.showSnackBar(
      SnackBar(
        content: Text(success ? 'Dodano do Google Calendar' : 'Nie udało się dodać do Google Calendar'),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subjects = ref.watch(subjectsProvider);
    final exams = ref.watch(examsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendarTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: subjects.isEmpty
                ? null
                : () => _showExamDialog(context, ref, l10n, subjects),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(examsProvider.notifier).loadExams(),
        child: subjects.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.info_outline, size: 48, color: colorScheme.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.noSubjectsForExams,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.calendarNoSubjectsInfo,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
            : exams.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      l10n.noExams,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  final subjectMatch = subjects.where(
                    (s) => s.id == exam.subjectId,
                  );
                  final subjectName = subjectMatch.isNotEmpty
                      ? subjectMatch.first.name
                      : l10n.unknownSubject;
                  return _buildExamCard(context, exam, subjectName, l10n, ref);
                },
              ),
      ),
      floatingActionButton: subjects.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'calendar_fab',
              onPressed: () => _showExamDialog(context, ref, l10n, subjects),
              icon: const Icon(Icons.event_note),
              label: Text(l10n.addExam),
            ),
    );
  }

  Widget _buildExamCard(
    BuildContext context,
    Exam exam,
    String subjectName,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    final dateStr = LocalizedDateFormatter.formatDateShort(exam.date, l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        exam.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: TranslatedText(
                              subjectName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            ' • $dateStr',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  onPressed: () => _showExamDialog(
                    context,
                    ref,
                    l10n,
                    ref.watch(subjectsProvider),
                    exam: exam,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  onPressed: () => _confirmDelete(context, ref, l10n, exam),
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  onPressed: () => _exportExamToCalendar(context, exam, subjectName),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (exam.maxPoints == null)
                  _chip(
                    '${l10n.weight}: ${exam.weight.toStringAsFixed(1)}',
                    colorScheme.primary,
                  ),
                if (exam.maxPoints != null)
                  _chip(
                    '${l10n.maxPoints}: ${exam.maxPoints!.toStringAsFixed(0)}',
                    colorScheme.secondary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: color)),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Exam exam,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteExamConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(examsProvider.notifier).deleteExam(exam.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showExamDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<Subject> subjects, {
    Exam? exam,
  }) {
    final titleController = TextEditingController(text: exam?.title ?? '');
    final weightController = TextEditingController(
      text: exam?.weight.toStringAsFixed(1) ?? '1.0',
    );
    final maxPointsController = TextEditingController(
      text: exam?.maxPoints?.toStringAsFixed(0) ?? '',
    );
    DateTime selectedDate = exam?.date ?? DateTime.now();
    String selectedSubjectId = exam?.subjectId ?? subjects.first.id;
    bool usePoints = exam?.maxPoints != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(exam == null ? l10n.addExam : l10n.editExam),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedSubjectId,
                  items: subjects
                      .map(
                        (s) =>
                            DropdownMenuItem(value: s.id, child: TranslatedText(s.name)),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedSubjectId = v!;
                      final subjectMatch = subjects.where((s) => s.id == selectedSubjectId);
                      if (subjectMatch.isNotEmpty) {
                        final mode = subjectMatch.first.gradingMode;
                        if (mode == Subject.gradingModeGrades) usePoints = false;
                        if (mode == Subject.gradingModePoints) usePoints = true;
                      }
                    });
                  },
                  decoration: InputDecoration(labelText: l10n.examSubject),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: l10n.examTitle),
                ),
                const SizedBox(height: 12),
                if (subjects
                        .firstWhere((s) => s.id == selectedSubjectId)
                        .gradingMode ==
                    Subject.gradingModeMixed)
                  SwitchListTile(
                    title: Text(
                      l10n.pointsMode,
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: usePoints,
                    onChanged: (v) => setState(() => usePoints = v),
                    activeColor: const Color(0xFF6366F1),
                  ),
                if (!usePoints) ...[
                  TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: l10n.weight),
                  ),
                  const SizedBox(height: 12),
                ],
                if (usePoints)
                  TextField(
                    controller: maxPointsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.maxPoints),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l10n.examDate}: ${LocalizedDateFormatter.formatDateShort(selectedDate, l10n)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 2),
                        );
                        if (picked != null)
                          setState(() => selectedDate = picked);
                      },
                      child: Text(l10n.chooseDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  _showSnack(context, l10n.validationExamTitle);
                  return;
                }
                final weight = double.tryParse(weightController.text) ?? 1.0;
                if (weight <= 0) {
                  _showSnack(context, l10n.validationWeight);
                  return;
                }
                final maxPoints = usePoints
                    ? double.tryParse(maxPointsController.text)
                    : null;
                if (usePoints && (maxPoints == null || maxPoints <= 0)) {
                  _showSnack(context, l10n.validationMaxPoints);
                  return;
                }
                if (exam == null) {
                  ref
                      .read(examsProvider.notifier)
                      .addExam(
                        Exam(
                          id: '',
                          subjectId: selectedSubjectId,
                          title: titleController.text,
                          date: selectedDate,
                          weight: weight,
                          maxPoints: maxPoints,
                        ),
                      );
                } else {
                  ref
                      .read(examsProvider.notifier)
                      .updateExam(
                        Exam(
                          id: exam.id,
                          subjectId: selectedSubjectId,
                          title: titleController.text,
                          date: selectedDate,
                          weight: weight,
                          maxPoints: maxPoints,
                        ),
                      );
                }
                Navigator.pop(context);
              },
              child: Text(exam == null ? l10n.add : l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
