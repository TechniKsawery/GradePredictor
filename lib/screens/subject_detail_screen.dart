import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildAverageHeader(context, average),
          Expanded(
            child: grades.isEmpty
                ? const Center(child: Text('No grades added yet.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      return _buildGradeCard(context, ref, grade);
                    },
                  ),
          ),
          _buildActionButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildAverageHeader(BuildContext context, double average) {
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
          const Text(
            'Current Average',
            style: TextStyle(color: Colors.white70, fontSize: 16),
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

  Widget _buildGradeCard(BuildContext context, WidgetRef ref, Grade grade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
          child: Text(
            grade.grade.toString(),
            style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('Weight: ${grade.weight}'),
        subtitle: Text(grade.type),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white24),
          onPressed: () => ref.read(gradesProvider(subject.id).notifier).deleteGrade(grade.id),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showAddGradeDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Grade'),
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
              label: const Text('Predict'),
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
    String selectedType = 'test';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Grade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade (e.g. 5)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (e.g. 1.0)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              items: ['test', 'quiz', 'homework', 'activity'].map((t) => 
                DropdownMenuItem(value: t, child: Text(t.toUpperCase()))
              ).toList(),
              onChanged: (v) => selectedType = v!,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final g = double.tryParse(gradeController.text) ?? 0;
              final w = double.tryParse(weightController.text) ?? 1.0;
              if (g > 0) {
                ref.read(gradesProvider(subject.id).notifier).addGrade(g, w, selectedType);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
