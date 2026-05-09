import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/grade_provider.dart';
import '../providers/settings_provider.dart';
import '../models/subject.dart';
import '../models/exam.dart';

class PredictionDialog extends ConsumerStatefulWidget {
  final String subjectId;
  const PredictionDialog({super.key, required this.subjectId});

  @override
  ConsumerState<PredictionDialog> createState() => _PredictionDialogState();
}

class _PredictionDialogState extends ConsumerState<PredictionDialog> {
  final _targetController = TextEditingController();
  String? _result;
  List<Map<String, dynamic>> _predictions = [];

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  String? _explanation;
  String? _recommendation;

  void _calculate() {
    final rawTarget = double.tryParse(_targetController.text);
    if (rawTarget == null) return;

    final l10n = AppLocalizations.of(context)!;
    final grades = ref.read(gradesProvider(widget.subjectId));
    final subjects = ref.read(subjectsProvider);
    final subject = subjects.firstWhere((s) => s.id == widget.subjectId);
    final exams = ref.read(examsProvider).where((e) => e.subjectId == widget.subjectId && e.date.isAfter(DateTime.now().subtract(const Duration(days: 1)))).toList();
    final scale = ref.read(settingsProvider);

    _predictions.clear();
    _result = null;
    _explanation = null;
    _recommendation = null;

    double targetPercent = rawTarget;
    if (rawTarget <= 6) {
      final custom = subject.customGradingScale;
      if (rawTarget <= 2) targetPercent = custom?['grade2'] ?? scale.grade2;
      else if (rawTarget <= 3) targetPercent = custom?['grade3'] ?? scale.grade3;
      else if (rawTarget <= 4) targetPercent = custom?['grade4'] ?? scale.grade4;
      else if (rawTarget <= 5) targetPercent = custom?['grade5'] ?? scale.grade5;
      else targetPercent = custom?['grade6'] ?? scale.grade6;
    }

    if (subject.gradingMode == Subject.gradingModePoints) {
      _calculatePoints(targetPercent, grades, exams, subject, scale, l10n);
    } else {
      _calculateGrades(rawTarget, grades, exams, l10n);
    }

    setState(() {});
  }

  void _calculatePoints(double targetP, grades, List<Exam> exams, Subject subject, scale, AppLocalizations l10n) {
    double currentPoints = 0;
    double currentMaxPoints = 0;
    for (var g in grades) {
      currentPoints += g.points ?? 0;
      currentMaxPoints += g.maxPoints ?? 0;
    }

    if (exams.isEmpty) {
      if (currentMaxPoints == 0) {
        _result = "Najpierw dodaj jakąś ocenę!";
        return;
      }
      final totalNeeded = (targetP / 100.0) * currentMaxPoints;
      final remaining = totalNeeded - currentPoints;
      
      if (remaining <= 0) {
        _result = l10n.predictionPointsSurplus;
        _explanation = l10n.predictionPointsCurrentStatus(((currentPoints / currentMaxPoints) * 100).toStringAsFixed(1), targetP.toStringAsFixed(0));
        _recommendation = l10n.predictionAdviceKeepItUp;
      } else {
        _result = l10n.predictionPointsMissing(remaining.toStringAsFixed(1), targetP.toStringAsFixed(0));
        _explanation = "Masz ${currentPoints.toStringAsFixed(1)} / ${currentMaxPoints.toStringAsFixed(1)} pkt (${((currentPoints / currentMaxPoints) * 100).toStringAsFixed(1)}%).";
        _recommendation = l10n.predictionPointsNoExamsRecommendation;
      }
    } else {
      double totalUpcomingMax = exams.fold(0.0, (sum, e) => sum + (e.maxPoints ?? 0));
      final totalPossibleMax = currentMaxPoints + totalUpcomingMax;
      final totalNeeded = (targetP / 100.0) * totalPossibleMax;
      final remaining = totalNeeded - currentPoints;

      if (remaining <= 0) {
        _result = l10n.predictionGoalEasy;
        _explanation = l10n.predictionGoalEasyExplanation(targetP.toStringAsFixed(0));
        _recommendation = l10n.predictionAdviceSleepWell;
      } else if (remaining > totalUpcomingMax) {
        final extraNeeded = remaining - totalUpcomingMax;
        _result = l10n.predictionGradesRescuePlanTitle;
        _explanation = l10n.predictionPointsImpossibleExplanation(extraNeeded.toStringAsFixed(1));
        _recommendation = l10n.predictionPointsRescueRecommendation(extraNeeded.toStringAsFixed(1));
      } else {
        _result = l10n.predictionPointsNeededList;
        _explanation = l10n.predictionPointsNeededExplanation(remaining.toStringAsFixed(1), totalUpcomingMax.toStringAsFixed(1));
        _recommendation = l10n.predictionAdviceFocusOnBig;
        for (var exam in exams) {
          final share = (exam.maxPoints ?? 0) / totalUpcomingMax;
          final neededForThis = remaining * share;
          _predictions.add({
            'title': exam.title,
            'needed': '${neededForThis.toStringAsFixed(1)} / ${exam.maxPoints?.toStringAsFixed(0)} pkt',
            'date': DateFormat('dd MMM').format(exam.date),
          });
        }
      }
    }
  }

  void _calculateGrades(double target, grades, List<Exam> exams, AppLocalizations l10n) {
    double currentWeightedSum = 0;
    double currentTotalWeights = 0;
    for (var g in grades) {
      currentWeightedSum += g.grade * g.weight;
      currentTotalWeights += g.weight;
    }

    if (exams.isEmpty) {
      _result = l10n.predictionGradesForecastTitle;
      _explanation = l10n.predictionGradesNoExamsExplanation(target.toStringAsFixed(1));
      _recommendation = l10n.predictionGradesNoExamsRecommendation;
      for (double w in [1.0, 2.0, 3.0]) {
        final needed = (target * (currentTotalWeights + w) - currentWeightedSum) / w;
        final bestCase = (currentWeightedSum + 6 * w) / (currentTotalWeights + w);
        _predictions.add({
          'title': l10n.predictionGradesWeightScenario(w.toStringAsFixed(1)),
          'needed': needed > 6 ? l10n.predictionImpossibleShort : l10n.predictionMinGrade(needed.toStringAsFixed(1)),
          'isBad': needed > 6,
          'why': needed > 6 ? l10n.predictionGradesImpossibleWhy(bestCase.toStringAsFixed(2)) : null,
        });
      }
    } else {
      _result = l10n.predictionGradesExamsNeededList;
      final totalWeights = exams.fold(0.0, (sum, e) => sum + e.weight);
      final neededAvg = (target * (currentTotalWeights + totalWeights) - currentWeightedSum) / totalWeights;
      final bestCase = (currentWeightedSum + 6 * totalWeights) / (currentTotalWeights + totalWeights);
      
      if (neededAvg > 6) {
        final n = (target * (totalWeights + currentTotalWeights) - (currentWeightedSum + 6 * totalWeights)) / (6 - target);
        final extraNeeded = n.ceil();

        _result = l10n.predictionGradesRescuePlanTitle;
        _explanation = l10n.predictionGradesImpossibleExplanation(bestCase.toStringAsFixed(2));
        _recommendation = l10n.predictionGradesRescueRecommendation(extraNeeded.toString(), target.toStringAsFixed(1));
      } else {
        _explanation = l10n.predictionGradesExamsNeededExplanation;
        _recommendation = l10n.predictionAdviceExtraCredit;
      }

      for (var exam in exams) {
        _predictions.add({
          'title': exam.title,
          'needed': neededAvg > 6 ? l10n.predictionImpossibleShort : l10n.predictionMinGrade(neededAvg.toStringAsFixed(1)),
          'date': DateFormat('dd MMM').format(exam.date),
          'isBad': neededAvg > 6,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.auto_awesome, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(l10n.gradePredictor),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: l10n.predictionTargetLabel,
                hintText: l10n.predictionTargetHint,
                prefixIcon: const Icon(Icons.track_changes),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              child: Text(l10n.calculate),
            ),
            if (_result != null || _predictions.isNotEmpty) ...[
              const SizedBox(height: 24),
              if (_result != null) ...[
                Text(
                  _result!,
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                if (_explanation != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _explanation!,
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_recommendation != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _recommendation!,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              if (_predictions.isNotEmpty) ...[
                const SizedBox(height: 16),
                ..._predictions.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  return Column(
                    children: [
                      _buildPredictionTile(p, colorScheme),
                      if (p['why'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                          child: Text(
                            p['why'],
                            style: TextStyle(fontSize: 10, color: Colors.red.withValues(alpha: 0.7)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (_result != null && _result!.contains(l10n.predictionGradesForecastTitle) && idx < _predictions.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(l10n.predictionOrSeparator, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.outline)),
                        ),
                    ],
                  );
                }),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
      ],
    );
  }

  Widget _buildResultCard(String text, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPredictionTile(Map<String, dynamic> p, ColorScheme colorScheme) {
    final isBad = p['isBad'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isBad ? Colors.red.withValues(alpha: 0.05) : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                if (p['date'] != null)
                  Text(p['date'], style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
          Text(
            p['needed'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBad ? Colors.red : colorScheme.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
