import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../providers/grade_provider.dart';
import '../widgets/prediction_dialog.dart';

class SubjectDetailScreen extends ConsumerWidget {
  final Subject subject;
  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(gradesProvider(subject.id));
    final average = ref.watch(averageProvider(subject.id));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildAverageHeader(context, average, l10n),
          Expanded(
            child: grades.isEmpty
                ? Center(child: Text(l10n.noSubjects))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      return _buildGradeCard(context, ref, grade, l10n);
                    },
                  ),
          ),
          _buildActionButtons(context, ref, l10n),
        ],
      ),
    );
  }

  Widget _buildAverageHeader(BuildContext context, double average, AppLocalizations l10n) {
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
              grade.grade.toString(),
              style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
            ),
          ),
          title: Text('${l10n.weight}: ${grade.weight}'),
          subtitle: Text(grade.type),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white24),
            onPressed: () => _showDeleteGradeConfirm(context, ref, grade),
          ),
        ),
      ),
    );
  }

  void _showEditGradeDialog(BuildContext context, WidgetRef ref, Grade grade) {
    final gradeController = TextEditingController(text: grade.grade.toString());
    final weightController = TextEditingController(text: grade.weight.toString());
    final l10n = AppLocalizations.of(context)!;
    String selectedType = grade.type;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editGrade),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: l10n.gradeHint),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: l10n.weightHint),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['test', 'quiz', 'homework', 'activity'].map((t) => 
                DropdownMenuItem(value: t, child: Text(t.toUpperCase()))
              ).toList(),
              onChanged: (v) => selectedType = v!,
              decoration: InputDecoration(labelText: l10n.type),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final gValue = double.tryParse(gradeController.text) ?? 0;
              final wValue = double.tryParse(weightController.text) ?? 1.0;
              if (gValue > 0) {
                final updatedGrade = Grade(
                  id: grade.id,
                  subjectId: grade.subjectId,
                  grade: gValue,
                  weight: wValue,
                  type: selectedType,
                  date: grade.date,
                );
                ref.read(gradesProvider(subject.id).notifier).updateGrade(updatedGrade);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
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

  void _showAddGradeDialog(BuildContext context, WidgetRef ref) {
    final gradeController = TextEditingController();
    final weightController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    String selectedType = 'test';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addGrade),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: l10n.gradeHint),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: l10n.weightHint),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              items: ['test', 'quiz', 'homework', 'activity'].map((t) => 
                DropdownMenuItem(value: t, child: Text(t.toUpperCase()))
              ).toList(),
              onChanged: (v) => selectedType = v!,
              decoration: InputDecoration(labelText: l10n.type),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final g = double.tryParse(gradeController.text) ?? 0;
              final w = double.tryParse(weightController.text) ?? 1.0;
              if (g > 0) {
                ref.read(gradesProvider(subject.id).notifier).addGrade(g, w, selectedType);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }
}
