import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';
import '../providers/grade_provider.dart';
import '../models/subject.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/subject_translator.dart';
import '../widgets/translated_text.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsProvider);
    final averages = ref.watch(subjectAveragesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPdf(context, ref, subjects, l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.performance,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildBarChart(context, subjects, averages, l10n),
            const SizedBox(height: 48),
            Text(
              l10n.insights,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsights(context, subjects, averages, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<Subject> subjects, Map<String, double> averages, AppLocalizations l10n) {
    if (subjects.isEmpty) return Center(child: Text(l10n.noSubjects));

    final chartWidth = subjects.length * 60.0; // 60px per bar

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 300,
        width: chartWidth < MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width : chartWidth,
        child: Padding(
          padding: const EdgeInsets.only(right: 24, left: 12),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 6,
              barGroups: subjects.asMap().entries.map((entry) {
                final avg = averages[entry.value.id] ?? 0.0;
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
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 || value.toInt() >= subjects.length) return const Text('');
                      final originalName = subjects[value.toInt()].name;
                      return FutureBuilder<String>(
                        future: SubjectTranslator.translateAsync(context, originalName),
                        initialData: SubjectTranslator.translate(context, originalName),
                        builder: (context, snapshot) {
                          final name = snapshot.data ?? originalName;
                          final label = name.length > 6 ? '${name.substring(0, 5)}.' : name;
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              label.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, 
                    reservedSize: 35,
                    interval: 1,
                  )
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsights(BuildContext context, List<Subject> subjects, Map<String, double> averages, AppLocalizations l10n) {
    if (subjects.isEmpty) return const SizedBox();
    final colorScheme = Theme.of(context).colorScheme;

    final lowPerformers = subjects.where((s) => (averages[s.id] ?? 0.0) < 3.0).toList();

    return Column(
      children: [
        _insightCard(
          context,
          l10n.subjectsToRescue,
          Text(
            '${lowPerformers.length} ${l10n.subjects}',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          lowPerformers.isNotEmpty ? Colors.redAccent : Colors.greenAccent,
          Icons.warning_amber_rounded,
          onTap: lowPerformers.isEmpty ? null : () => _showLowPerformersDialog(context, lowPerformers, averages, l10n),
        ),
        const SizedBox(height: 12),
        _insightCard(
          context,
          l10n.bestSubject,
          FutureBuilder<String>(
            future: SubjectTranslator.translateAsync(context, _getBestSubjectRaw(subjects, averages)),
            initialData: SubjectTranslator.translate(context, _getBestSubjectRaw(subjects, averages)),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? '',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              );
            },
          ),
          const Color(0xFF06B6D4),
          Icons.star_outline,
        ),
      ],
    );
  }

  void _showLowPerformersDialog(BuildContext context, List<Subject> subjects, Map<String, double> averages, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.subjectsToRescue),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              final avg = averages[subject.id] ?? 0.0;
              return ListTile(
                title: TranslatedText(subject.name),
                trailing: Text(
                  avg.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.ok)),
        ],
      ),
    );
  }

  Widget _insightCard(BuildContext context, String title, Widget subtitleWidget, Color color, IconData icon, {VoidCallback? onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitleWidget,
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  String _getBestSubjectRaw(List<Subject> subjects, Map<String, double> averages) {
    if (subjects.isEmpty) return '';
    var best = subjects[0];
    var bestAvg = averages[best.id] ?? 0.0;
    
    for (var s in subjects) {
      final avg = averages[s.id] ?? 0.0;
      if (avg > bestAvg) {
        best = s;
        bestAvg = avg;
      }
    }
    return best.name;
  }

  Future<void> _exportToPdf(BuildContext context, WidgetRef ref, List<Subject> subjects, AppLocalizations l10n) async {
    if (subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noSubjects)),
      );
      return;
    }

    // 1. Collect data before async operations using BuildContext
    final List<List<String>> tableData = [];
    final averages = ref.read(subjectAveragesProvider);
    for (final s in subjects) {
      final translatedName = await SubjectTranslator.translateAsync(context, s.name);
      final avg = averages[s.id] ?? 0.0;
      tableData.add([translatedName, avg.toStringAsFixed(2)]);
    }

    // 2. Load fonts that support Polish characters (ą, ę, ó, ś, ź, ż, etc.)
    final font = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();

    // 3. Capture all l10n strings before entering PDF context
    final reportTitle = l10n.pdfReportTitle;
    final summaryHeader = l10n.pdfSummaryHeader;
    final subjectHeader = l10n.subjects;
    final avgHeader = l10n.currentAverage;
    final footerText = l10n.pdfFooter;

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: fontBold,
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context pdfContext) => [
          pw.Header(level: 0, text: reportTitle),
          pw.SizedBox(height: 16),
          pw.Text(summaryHeader, style: pw.TextStyle(font: fontBold, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.indigo100),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(subjectHeader, style: pw.TextStyle(font: fontBold, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(avgHeader, style: pw.TextStyle(font: fontBold, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              // Data rows
              ...tableData.asMap().entries.map((entry) {
                final isEven = entry.key % 2 == 0;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: isEven ? PdfColors.white : PdfColors.grey50,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(entry.value[0], style: pw.TextStyle(font: font)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(entry.value[1], style: pw.TextStyle(font: font)),
                    ),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 40),
          pw.Text(footerText, style: pw.TextStyle(font: font, color: PdfColors.grey, fontSize: 10)),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
