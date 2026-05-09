import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/grade_provider.dart';

class PredictionDialog extends ConsumerStatefulWidget {
  final String subjectId;
  const PredictionDialog({super.key, required this.subjectId});

  @override
  ConsumerState<PredictionDialog> createState() => _PredictionDialogState();
}

class _PredictionDialogState extends ConsumerState<PredictionDialog> {
  final _targetController = TextEditingController();
  final _weightController = TextEditingController(text: '1.0');
  String? _result;

  void _calculate() {
    final target = double.tryParse(_targetController.text);
    final weight = double.tryParse(_weightController.text);
    final l10n = AppLocalizations.of(context)!;
    
    if (target == null || weight == null) return;

    final grades = ref.read(gradesProvider(widget.subjectId));
    
    double currentWeightedSum = 0;
    double currentTotalWeights = 0;
    
    for (var g in grades) {
      currentWeightedSum += g.grade * g.weight;
      currentTotalWeights += g.weight;
    }
    
    final needed = (target * (currentTotalWeights + weight) - currentWeightedSum) / weight;
    
    setState(() {
      final neededStr = needed.toStringAsFixed(2);
      if (needed > 6) {
        _result = l10n.impossible(neededStr);
      } else if (needed < 1) {
        _result = l10n.easy(neededStr);
      } else {
        _result = l10n.neededAtLeast(neededStr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.gradePredictor),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _targetController,
            decoration: InputDecoration(
              labelText: l10n.targetAverage,
              hintText: 'e.g. 4.75',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(
              labelText: l10n.nextAssignmentWeight,
              hintText: 'e.g. 1.0',
            ),
            keyboardType: TextInputType.number,
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
              ),
              child: Text(
                _result!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        ElevatedButton(onPressed: _calculate, child: Text(l10n.calculate)),
      ],
    );
  }
}
