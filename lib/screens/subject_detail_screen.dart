import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../providers/grade_provider.dart';
import '../providers/settings_provider.dart';
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
        actions: [
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
          Builder(builder: (context) {
            final normalEarned = grades.where((g) => g.points != null && g.type != 'bonus').fold<double>(0.0, (s, g) => s + (g.points ?? 0));
            final bonusEarned = grades.where((g) => g.points != null && g.type == 'bonus').fold<double>(0.0, (s, g) => s + (g.points ?? 0));
            final maxNormal = subject.maxNormalPoints ?? 0.0;
            final maxBonus = subject.maxBonusPoints ?? 0.0;
            final normalPct = (maxNormal > 0) ? (normalEarned / maxNormal * 100) : 0.0;
            final bonusPct = (maxBonus > 0) ? (bonusEarned / maxBonus * 100) : 0.0;

            return Column(
              children: [
                Text('Punkty: ${normalEarned.toStringAsFixed(1)}/${maxNormal.toStringAsFixed(1)} (${normalPct.toStringAsFixed(0)}%)', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text('Bonus: ${bonusEarned.toStringAsFixed(1)}/${maxBonus.toStringAsFixed(1)} (${bonusPct.toStringAsFixed(0)}%)', style: const TextStyle(color: Colors.white70)),
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
              grade.grade.toString(),
              style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
            ),
          ),
            title: Text(grade.points != null
              ? '${grade.points}/${grade.maxPoints} (${((grade.points!/grade.maxPoints!)*100).toStringAsFixed(0)}%)${grade.type == 'bonus' ? ' • BONUS' : ''}'
              : '${l10n.weight}: ${grade.weight}${grade.type == 'bonus' ? ' • BONUS' : ''}'),
          subtitle: Text('${grade.type}${grade.points != null ? ' • ${l10n.weight}: ${grade.weight}' : ''}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white24),
            onPressed: () => _showDeleteGradeConfirm(context, ref, grade),
          ),
        ),
      ),
    );
  }

  double _pointsToGrade(double points, double max, GradingScale scale) {
    final percent = (points / max) * 100;
    if (percent >= scale.grade6) return 6.0;
    if (percent >= scale.grade5) return 5.0;
    if (percent >= scale.grade4) return 4.0;
    if (percent >= scale.grade3) return 3.0;
    if (percent >= scale.grade2) return 2.0;
    return 1.0;
  }

  void _showAddGradeDialog(BuildContext context, WidgetRef ref) {
    final gradeController = TextEditingController();
    final weightController = TextEditingController();
    final pointsController = TextEditingController();
    final maxPointsController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    String selectedType = 'test';
    bool isPoints = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addGrade),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Punkty', style: TextStyle(fontSize: 14)),
                  value: isPoints,
                  onChanged: (v) => setState(() => isPoints = v),
                  activeColor: const Color(0xFF6366F1),
                ),
                if (!isPoints)
                  TextField(
                    controller: gradeController,
                    decoration: InputDecoration(labelText: l10n.gradeHint),
                    keyboardType: TextInputType.number,
                  )
                else ...[
                  TextField(
                    controller: pointsController,
                    decoration: const InputDecoration(labelText: 'Zdobyte punkty'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxPointsController,
                    decoration: const InputDecoration(labelText: 'Maks. punktów'),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: l10n.weightHint),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: ['test', 'quiz', 'homework', 'activity', 'bonus'].map((t) => 
                    DropdownMenuItem(value: t, child: Text(t.toUpperCase()))
                  ).toList(),
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
    bool isPoints = grade.points != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editGrade),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Punkty', style: TextStyle(fontSize: 14)),
                  value: isPoints,
                  onChanged: (v) => setState(() => isPoints = v),
                  activeColor: const Color(0xFF6366F1),
                ),
                if (!isPoints)
                  TextField(
                    controller: gradeController,
                    decoration: InputDecoration(labelText: l10n.gradeHint),
                    keyboardType: TextInputType.number,
                  )
                else ...[
                  TextField(
                    controller: pointsController,
                    decoration: const InputDecoration(labelText: 'Zdobyte punkty'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxPointsController,
                    decoration: const InputDecoration(labelText: 'Maks. punktów'),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: l10n.weightHint),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: ['test', 'quiz', 'homework', 'activity', 'bonus'].map((t) => 
                    DropdownMenuItem(value: t, child: Text(t.toUpperCase()))
                  ).toList(),
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
