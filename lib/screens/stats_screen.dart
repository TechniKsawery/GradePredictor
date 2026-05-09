import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/grade_provider.dart';
import '../models/subject.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPdf(context, ref, subjects),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject Performance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildBarChart(context, ref, subjects),
            const SizedBox(height: 48),
            const Text(
              'Quick Insights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsights(ref, subjects),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, WidgetRef ref, List<Subject> subjects) {
    if (subjects.isEmpty) return const Center(child: Text('Add subjects to see charts.'));

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 6,
          barGroups: subjects.asMap().entries.map((entry) {
            final avg = ref.watch(averageProvider(entry.value.id));
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: avg,
                  color: const Color(0xFF6366F1),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= subjects.length) return const Text('');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      subjects[value.toInt()].name.substring(0, 3).toUpperCase(),
                      style: const TextStyle(fontSize: 10, color: Colors.white54),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildInsights(WidgetRef ref, List<Subject> subjects) {
    if (subjects.isEmpty) return const SizedBox();

    final lowPerformers = subjects.where((s) => ref.watch(averageProvider(s.id)) < 3.0).toList();

    return Column(
      children: [
        _insightCard(
          'Subjects to "Rescue"',
          '${lowPerformers.length} subjects need attention',
          lowPerformers.isNotEmpty ? Colors.redAccent : Colors.greenAccent,
          Icons.warning_amber_rounded,
        ),
        const SizedBox(height: 12),
        _insightCard(
          'Best Subject',
          _getBestSubject(ref, subjects),
          const Color(0xFF06B6D4),
          Icons.star_outline,
        ),
      ],
    );
  }

  Widget _insightCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  String _getBestSubject(WidgetRef ref, List<Subject> subjects) {
    if (subjects.isEmpty) return 'None';
    var best = subjects[0];
    var bestAvg = ref.watch(averageProvider(best.id));
    
    for (var s in subjects) {
      final avg = ref.watch(averageProvider(s.id));
      if (avg > bestAvg) {
        best = s;
        bestAvg = avg;
      }
    }
    return best.name;
  }

  Future<void> _exportToPdf(BuildContext context, WidgetRef ref, List<Subject> subjects) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, text: 'GradePredictor Report'),
              pw.SizedBox(height: 20),
              pw.Text('Summary of current academic standing:'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Subject', 'Current Average'],
                data: subjects.map((s) {
                  final avg = ref.read(averageProvider(s.id));
                  return [s.name, avg.toStringAsFixed(2)];
                }).toList(),
              ),
              pw.SizedBox(height: 40),
              pw.Text('Generated by GradePredictor App', style: const pw.TextStyle(color: PdfColors.grey)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
