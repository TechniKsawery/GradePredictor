import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../widgets/translated_text.dart';
import '../providers/grade_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/prediction_dialog.dart';

class SubjectDetailScreen extends ConsumerWidget {
  final Subject subject;
  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(filteredGradesProvider(subject.id));
    final average = ref.watch(filteredAverageProvider(subject.id));
    final l10n = AppLocalizations.of(context)!;
    final currentSemester = ref.watch(semesterFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(subject.name, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => ref.read(gradeSortProvider.notifier).state = value,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'date_desc', child: Text('Najnowsze')),
              PopupMenuItem(value: 'date_asc', child: Text('Najstarsze')),
              PopupMenuItem(value: 'grade_desc', child: Text('Najwyższe oceny')),
              PopupMenuItem(value: 'grade_asc', child: Text('Najniższe oceny')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(gradesProvider(subject.id).notifier).loadGrades();
              ref.read(subjectsProvider.notifier).loadSubjects();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAverageHeader(context, subject, grades, average, l10n),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Półrocze 1')),
                ButtonSegment(value: 0, label: Text('Cały rok')),
                ButtonSegment(value: 2, label: Text('Półrocze 2')),
              ],
              selected: {currentSemester},
              onSelectionChanged: (newSelection) {
                ref.read(semesterFilterProvider.notifier).state = newSelection.first;
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(gradesProvider(subject.id).notifier).loadGrades(),
              child: grades.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [Center(child: Text(l10n.noSubjects))],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: grades.length,
                      itemBuilder: (context, index) {
                        final grade = grades[index];
                        return _buildGradeCard(context, ref, grade, l10n);
                      },
                    ),
            ),
          ),
          _buildActionButtons(context, ref, l10n),
        ],
      ),
    );
  }

  Widget _buildAverageHeader(BuildContext context, Subject subject, List<Grade> grades, double average, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            l10n.currentAverage,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            average.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (subject.gradingMode != Subject.gradingModeGrades)
            Builder(builder: (context) {
              final normalEarned = grades.where((g) => g.points != null && g.type != 'bonus').fold<double>(0.0, (s, g) => s + (g.points ?? 0));
              final bonusEarned = grades.where((g) => g.points != null && g.type == 'bonus').fold<double>(0.0, (s, g) => s + (g.points ?? 0));
              final maxNormal = subject.maxNormalPoints ?? 0.0;
              final maxBonus = subject.maxBonusPoints ?? 0.0;
              final normalPct = (maxNormal > 0) ? (normalEarned / maxNormal * 100) : 0.0;
              final bonusPct = (maxBonus > 0) ? (bonusEarned / maxBonus * 100) : 0.0;

              return Column(
                children: [
                  Text('${l10n.points}: ${normalEarned.toStringAsFixed(1)}/${maxNormal.toStringAsFixed(1)} (${normalPct.toStringAsFixed(0)}%)', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text('${l10n.bonus}: ${bonusEarned.toStringAsFixed(1)}/${maxBonus.toStringAsFixed(1)} (${bonusPct.toStringAsFixed(0)}%)', style: const TextStyle(color: Colors.white70)),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, WidgetRef ref, Grade grade, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showEditGradeDialog(context, ref, grade),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
            child: Text(
              grade.points != null
                  ? (grade.grade > 0 ? grade.grade.toStringAsFixed(0) : '•')
                  : grade.grade.toStringAsFixed(0),
              style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          title: Builder(
            builder: (ctx) {
              if (grade.points != null) {
                final pts = grade.points!;
                final maxPts = grade.maxPoints;
                final pctStr = (maxPts != null && maxPts > 0)
                    ? ' (${((pts / maxPts) * 100).toStringAsFixed(0)}%)'
                    : '';
                final maxStr = maxPts != null ? '/$maxPts' : '';
                final bonusTag = grade.type == 'bonus' ? ' • ${l10n.gradeTypeBonus.toUpperCase()}' : '';
                return Text(
                  '$pts$maxStr$pctStr$bonusTag',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }
              final bonusTag = grade.type == 'bonus' ? ' • ${l10n.gradeTypeBonus.toUpperCase()}' : '';
              return Text(
                '${l10n.weight}: ${grade.weight}$bonusTag',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          subtitle: Text(
            '${_getLocalizedType(grade.type, l10n)}${grade.points != null ? ' • ${l10n.weight}: ${grade.weight}' : ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white24),
            onPressed: () => _showDeleteGradeConfirm(context, ref, grade),
          ),
        ),
      ),
    );
  }

  double _pointsToGrade(double points, double max, GradingScale globalScale) {
    final percent = (points / max) * 100;
    final custom = subject.customGradingScale;
    
    if (custom != null) {
      if (percent >= (custom['grade6'] ?? globalScale.grade6)) return 6.0;
      if (percent >= (custom['grade5'] ?? globalScale.grade5)) return 5.0;
      if (percent >= (custom['grade4'] ?? globalScale.grade4)) return 4.0;
      if (percent >= (custom['grade3'] ?? globalScale.grade3)) return 3.0;
      if (percent >= (custom['grade2'] ?? globalScale.grade2)) return 2.0;
    } else {
      if (percent >= globalScale.grade6) return 6.0;
      if (percent >= globalScale.grade5) return 5.0;
      if (percent >= globalScale.grade4) return 4.0;
      if (percent >= globalScale.grade3) return 3.0;
      if (percent >= globalScale.grade2) return 2.0;
    }
    return 1.0;
  }

  String _getLocalizedType(String type, AppLocalizations l10n) {
    final locale = l10n.localeName; // 'pl', 'en', 'de'
    
    switch (type.toLowerCase().trim()) {
      // Standard built-in types
      case 'test': return l10n.gradeTypeTest;
      case 'quiz': return l10n.gradeTypeQuiz;
      case 'homework': return l10n.gradeTypeHomework;
      case 'activity': return l10n.gradeTypeActivity;
      case 'bonus': return l10n.gradeTypeBonus;
    }
    
    if (locale == 'pl') return type; // Polish: show raw
    
    // Comprehensive Polish → EN/DE translation dictionary for grade types
    const Map<String, Map<String, String>> gradeTypeMap = {
      // Semester types
      'śródroczna':                 {'en': 'Midterm',              'de': 'Halbjahres'},
      'sródroczna':                 {'en': 'Midterm',              'de': 'Halbjahres'},
      'roczna':                     {'en': 'Annual',               'de': 'Jahres'},
      'przewidywana śródroczna':    {'en': 'Predicted Midterm',    'de': 'Vorh. Halbjahres'},
      'przewidywana sródroczna':    {'en': 'Predicted Midterm',    'de': 'Vorh. Halbjahres'},
      'przewidywana roczna':        {'en': 'Predicted Annual',     'de': 'Vorh. Jahres'},
      'proponowana śródroczna':     {'en': 'Proposed Midterm',     'de': 'Vorgesch. Halbjahres'},
      'proponowana roczna':         {'en': 'Proposed Annual',      'de': 'Vorgesch. Jahres'},
      // Activity / behavior
      'aktywność':                  {'en': 'Activity',             'de': 'Aktivität'},
      'zachowanie':                 {'en': 'Behavior',             'de': 'Verhalten'},
      'praca klasowa':              {'en': 'Class Test',           'de': 'Klassenarbeit'},
      'kartkówka':                  {'en': 'Short Test',           'de': 'Kurztest'},
      'odpowiedź ustna':            {'en': 'Oral Answer',          'de': 'Mündliche Antwort'},
      'zadanie domowe':             {'en': 'Homework',             'de': 'Hausaufgabe'},
      'projekt':                    {'en': 'Project',              'de': 'Projekt'},
      'prezentacja':                {'en': 'Presentation',         'de': 'Präsentation'},
      'referat':                    {'en': 'Paper',                'de': 'Referat'},
      'praca dodatkowa':            {'en': 'Extra Work',           'de': 'Zusatzarbeit'},
      'konkurs':                    {'en': 'Competition',          'de': 'Wettbewerb'},
      'dyktando':                   {'en': 'Dictation',            'de': 'Diktat'},
      'wypracowanie':               {'en': 'Essay',                'de': 'Aufsatz'},
      'lektura':                    {'en': 'Reading',              'de': 'Lektüre'},
      'ćwiczenia':                  {'en': 'Exercises',            'de': 'Übungen'},
      'laboratorium':               {'en': 'Lab',                  'de': 'Labor'},
      'egzamin':                    {'en': 'Exam',                 'de': 'Prüfung'},
      'sprawdzian':                 {'en': 'Test',                 'de': 'Test'},
      'ocena semestralna':          {'en': 'Semester Grade',       'de': 'Semesternote'},
      'ocena końcowa':              {'en': 'Final Grade',          'de': 'Endnote'},
    };
    
    final normalized = type.toLowerCase().trim();
    // Exact match
    if (gradeTypeMap.containsKey(normalized)) {
      return gradeTypeMap[normalized]![locale] ?? type;
    }
    // Partial match
    for (final entry in gradeTypeMap.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value[locale] ?? type;
      }
    }
    
    return type; // Unknown type: show as-is
  }

  void _showAddGradeDialog(BuildContext context, WidgetRef ref) {
    final gradeController = TextEditingController();
    final weightController = TextEditingController();
    final pointsController = TextEditingController();
    final maxPointsController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    String selectedType = 'test';
    final allowToggle = subject.gradingMode == Subject.gradingModeMixed;
    bool isPoints = subject.gradingMode == Subject.gradingModePoints || subject.gradingMode == Subject.gradingModeMixed;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addGrade),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (allowToggle)
                  SwitchListTile(
                    title: Text(l10n.pointsMode, style: const TextStyle(fontSize: 14)),
                    value: isPoints,
                    onChanged: (v) => setState(() => isPoints = v),
                    activeColor: const Color(0xFF6366F1),
                  ),
                if (!isPoints)
                  TextField(
                    controller: gradeController,
                    decoration: InputDecoration(
                      labelText: l10n.gradeHint,
                      hintText: '1.0 - 6.0',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  )
                else ...[
                  TextField(
                    controller: pointsController,
                    decoration: InputDecoration(labelText: l10n.pointsEarned),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxPointsController,
                    decoration: InputDecoration(labelText: l10n.maxPoints),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 12),
                if (!isPoints) ...[
                  TextField(
                    controller: weightController,
                    decoration: InputDecoration(labelText: l10n.weight),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),
                ],
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: [
                    DropdownMenuItem(value: 'test', child: Text(l10n.gradeTypeTest.toUpperCase())),
                    DropdownMenuItem(value: 'quiz', child: Text(l10n.gradeTypeQuiz.toUpperCase())),
                    DropdownMenuItem(value: 'homework', child: Text(l10n.gradeTypeHomework.toUpperCase())),
                    DropdownMenuItem(value: 'activity', child: Text(l10n.gradeTypeActivity.toUpperCase())),
                    DropdownMenuItem(value: 'bonus', child: Text(l10n.gradeTypeBonus.toUpperCase())),
                  ],
                  onChanged: (v) => selectedType = v!,
                  decoration: InputDecoration(labelText: l10n.type),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () {
                double g = 0;
                double? p;
                double? mp;
                
                if (isPoints) {
                  p = double.tryParse(pointsController.text);
                  mp = double.tryParse(maxPointsController.text);
                  if (p != null && mp != null && mp > 0) {
                    final scale = ref.read(settingsProvider);
                    g = _pointsToGrade(p, mp, scale);
                  }
                } else {
                  g = double.tryParse(gradeController.text) ?? 0;
                }

                final w = double.tryParse(weightController.text) ?? 1.0;
                if (!isPoints && g <= 0) {
                  _showSnack(context, l10n.validationGrade);
                  return;
                }
                if (isPoints && (p == null || mp == null || mp <= 0)) {
                  _showSnack(context, l10n.validationPoints);
                  return;
                }
                if (w <= 0) {
                  _showSnack(context, l10n.validationWeight);
                  return;
                }
                if (g > 0) {
                  ref.read(gradesProvider(subject.id).notifier).addGrade(g, w, selectedType, points: p, maxPoints: mp);
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGradeDialog(BuildContext context, WidgetRef ref, Grade grade) {
    final gradeController = TextEditingController(text: grade.grade.toString());
    final weightController = TextEditingController(text: grade.weight.toString());
    final pointsController = TextEditingController(text: grade.points?.toString() ?? '');
    final maxPointsController = TextEditingController(text: grade.maxPoints?.toString() ?? '');
    final l10n = AppLocalizations.of(context)!;
    String selectedType = grade.type;
    final allowToggle = subject.gradingMode == Subject.gradingModeMixed;
    bool isPoints = allowToggle ? grade.points != null : subject.gradingMode == Subject.gradingModePoints;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editGrade),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (allowToggle)
                  SwitchListTile(
                    title: Text(l10n.pointsMode, style: const TextStyle(fontSize: 14)),
                    value: isPoints,
                    onChanged: (v) => setState(() => isPoints = v),
                    activeColor: const Color(0xFF6366F1),
                  ),
                if (!isPoints)
                  TextField(
                    controller: gradeController,
                    decoration: InputDecoration(
                      labelText: l10n.gradeHint,
                      hintText: '1.0 - 6.0',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  )
                else ...[
                  TextField(
                    controller: pointsController,
                    decoration: InputDecoration(labelText: l10n.pointsEarned),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxPointsController,
                    decoration: InputDecoration(labelText: l10n.maxPoints),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 12),
                if (!isPoints) ...[
                  TextField(
                    controller: weightController,
                    decoration: InputDecoration(labelText: l10n.weight),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),
                ],
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: [
                    DropdownMenuItem(value: 'test', child: Text(l10n.gradeTypeTest.toUpperCase())),
                    DropdownMenuItem(value: 'quiz', child: Text(l10n.gradeTypeQuiz.toUpperCase())),
                    DropdownMenuItem(value: 'homework', child: Text(l10n.gradeTypeHomework.toUpperCase())),
                    DropdownMenuItem(value: 'activity', child: Text(l10n.gradeTypeActivity.toUpperCase())),
                    DropdownMenuItem(value: 'bonus', child: Text(l10n.gradeTypeBonus.toUpperCase())),
                  ],
                  onChanged: (v) => selectedType = v!,
                  decoration: InputDecoration(labelText: l10n.type),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () {
                double g = 0;
                double? p;
                double? mp;
                
                if (isPoints) {
                  p = double.tryParse(pointsController.text);
                  mp = double.tryParse(maxPointsController.text);
                  if (p != null && mp != null && mp > 0) {
                    final scale = ref.read(settingsProvider);
                    g = _pointsToGrade(p, mp, scale);
                  }
                } else {
                  g = double.tryParse(gradeController.text) ?? 0;
                }

                final w = double.tryParse(weightController.text) ?? 1.0;
                if (!isPoints && g <= 0) {
                  _showSnack(context, l10n.validationGrade);
                  return;
                }
                if (isPoints && (p == null || mp == null || mp <= 0)) {
                  _showSnack(context, l10n.validationPoints);
                  return;
                }
                if (w <= 0) {
                  _showSnack(context, l10n.validationWeight);
                  return;
                }
                if (g > 0) {
                  final updatedGrade = Grade(
                    id: grade.id,
                    subjectId: grade.subjectId,
                    grade: g,
                    weight: w,
                    type: selectedType,
                    date: grade.date,
                    points: p,
                    maxPoints: mp,
                  );
                  ref.read(gradesProvider(subject.id).notifier).updateGrade(updatedGrade);
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  void _showDeleteGradeConfirm(BuildContext context, WidgetRef ref, Grade grade) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              ref.read(gradesProvider(subject.id).notifier).deleteGrade(grade.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showAddGradeDialog(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.addGrade),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => PredictionDialog(subjectId: subject.id),
              ),
              icon: const Icon(Icons.psychology),
              label: Text(l10n.predict),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
