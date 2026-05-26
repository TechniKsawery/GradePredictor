import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exam.dart';
import '../services/school_integration_service.dart';
import '../services/auto_sync_service.dart';
import '../providers/grade_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/translated_text.dart';

class SchoolSyncScreen extends ConsumerStatefulWidget {
  const SchoolSyncScreen({super.key});

  @override
  ConsumerState<SchoolSyncScreen> createState() => _SchoolSyncScreenState();
}

class _SchoolSyncScreenState extends ConsumerState<SchoolSyncScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SchoolProvider _selectedProvider = SchoolProvider.librus;
  bool _isLoading = false;
  bool _enableAutoSync = false;
  SchoolSyncResult? _result;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final autoSync = ref.read(autoSyncProvider.notifier);
    final (email, password, provider) = await autoSync.loadCredentials();
    if (email != null) _emailController.text = email;
    if (password != null) _passwordController.text = password;
    final enabled = ref.read(autoSyncProvider).isEnabled;
    if (mounted) {
      setState(() {
        _selectedProvider = provider;
        _enableAutoSync = enabled;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _startSync() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    final service = SchoolIntegrationService(
      email: _emailController.text,
      password: _passwordController.text,
      provider: _selectedProvider,
    );

    try {
      final result = await service.sync();
      if (mounted) setState(() { _result = result; _isLoading = false; });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final errorMsg = e.toString().toLowerCase().contains('vulcan')
            ? l10n.vulcanNotSupportedError
            : l10n.syncError(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _importData() async {
    if (_result == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      final addedSubjects = <String>{};
      for (final rawSubject in _result!.subjects) {
        final subName = rawSubject['name']?.toString() ?? l10n.syncDefaultSubject;
        final existing = ref.read(subjectsProvider).where((s) => s.name == subName);
        if (existing.isEmpty && !addedSubjects.contains(subName)) {
          addedSubjects.add(subName);
          await ref.read(subjectsProvider.notifier).addSubjectWithPoints(
            subName,
            gradingMode: (rawSubject['grading_mode'] ?? 'mixed').toString(),
            maxNormalPoints: (rawSubject['max_normal_points'] as num?)?.toDouble(),
            maxBonusPoints: (rawSubject['max_bonus_points'] as num?)?.toDouble(),
          );
        }
      }

      final subjects = ref.read(subjectsProvider);
      final subjectsByName = <String, String>{
        for (final s in subjects) s.name: s.id,
      };

      // 1. Pre-load all grades and exams to ensure we have local cache for duplicate checking
      for (final subjectId in subjectsByName.values) {
        await ref.read(gradesProvider(subjectId).notifier).loadGrades();
      }
      await ref.read(examsProvider.notifier).loadExams();
      final existingExams = ref.read(examsProvider);

      int importedGradesCount = 0;
      int importedExamsCount = 0;

      // 2. Batch grade imports, skipping duplicates
      const int batchSize = 10;
      List<Future> futures = [];
      for (final rawGrade in _result!.grades) {
        final subName = rawGrade['subject_name']?.toString() ?? '';
        final subjectId = subjectsByName[subName];
        if (subjectId == null) continue;

        final double gradeVal = (rawGrade['grade'] as num?)?.toDouble() ?? 0;
        final double weightVal = (rawGrade['weight'] as num?)?.toDouble() ?? 1;
        final String typeVal = rawGrade['type']?.toString() ?? 'test';
        final double? ptsVal = (rawGrade['points'] as num?)?.toDouble();
        final double? maxPtsVal = (rawGrade['max_points'] as num?)?.toDouble();
        final String? dateRaw = rawGrade['date'];
        final DateTime gradeDate = dateRaw != null ? DateTime.tryParse(dateRaw) ?? DateTime.now() : DateTime.now();

        // Check if grade already exists in memory cache
        final existingGrades = ref.read(gradesProvider(subjectId));
        final parts = typeVal.split('|');
        final actualType = parts[0];
        final semester = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
        final rawText = parts.length > 2 ? parts[2] : null;

        final isDuplicate = existingGrades.any((g) =>
          g.grade == gradeVal &&
          g.weight == weightVal &&
          g.type == actualType &&
          g.semester == semester &&
          g.points == ptsVal &&
          g.maxPoints == maxPtsVal &&
          g.rawText == rawText &&
          _isSameDay(g.date, gradeDate)
        );

        if (isDuplicate) continue;

        importedGradesCount++;
        futures.add(ref.read(gradesProvider(subjectId).notifier).addGrade(
          gradeVal,
          weightVal,
          typeVal,
          points: ptsVal,
          maxPoints: maxPtsVal,
          refreshAverages: false,
        ));

        if (futures.length >= batchSize) {
          await Future.wait(futures);
          futures.clear();
        }
      }
      if (futures.isNotEmpty) await Future.wait(futures);

      // 3. Batch exam imports, skipping duplicates
      futures = [];
      for (final rawExam in _result!.exams) {
        final subName = rawExam['subject_name']?.toString() ?? '';
        final subjectId = subjectsByName[subName];
        if (subjectId == null) continue;

        final examDateRaw = rawExam['date'];
        final examDate = examDateRaw != null
            ? DateTime.tryParse(examDateRaw.toString()) ?? DateTime.now()
            : DateTime.now();
        final String titleVal = rawExam['title']?.toString() ?? l10n.gradeTypeTest;
        final double weightVal = (rawExam['weight'] as num?)?.toDouble() ?? 1.0;
        final double? maxPointsVal = rawExam['max_points'] != null
            ? (rawExam['max_points'] as num).toDouble()
            : null;

        // Check if exam already exists in memory cache
        final isDuplicate = existingExams.any((e) =>
          e.subjectId == subjectId &&
          e.title.toLowerCase().trim() == titleVal.toLowerCase().trim() &&
          e.weight == weightVal &&
          e.maxPoints == maxPointsVal &&
          _isSameDay(e.date, examDate)
        );

        if (isDuplicate) continue;

        importedExamsCount++;
        futures.add(ref.read(examsProvider.notifier).addExam(
          Exam(
            id: '',
            subjectId: subjectId,
            title: titleVal,
            date: examDate,
            weight: weightVal,
            maxPoints: maxPointsVal,
          ),
        ));

        if (futures.length >= batchSize) {
          await Future.wait(futures);
          futures.clear();
        }
      }
      if (futures.isNotEmpty) await Future.wait(futures);
      ref.invalidate(subjectAveragesProvider);

      await ref.read(autoSyncProvider.notifier).saveCredentials(
        email: _emailController.text,
        password: _passwordController.text,
        provider: _selectedProvider,
        enableAutoSync: _enableAutoSync,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.syncImportedCount(
            importedGradesCount.toString(),
            importedExamsCount.toString(),
          ))),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('[Import] Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final autoSyncStatus = ref.watch(autoSyncProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.syncTitle),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (autoSyncStatus.isEnabled)
            IconButton(
              icon: autoSyncStatus.isSyncing
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.sync, color: Colors.white),
              tooltip: l10n.syncSyncNowTooltip,
              onPressed: autoSyncStatus.isSyncing
                  ? null
                  : () async {
                      final result = await ref.read(autoSyncProvider.notifier).syncNow();
                      if (result != null && mounted) setState(() => _result = result);
                    },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (autoSyncStatus.isEnabled) _buildStatusBanner(autoSyncStatus),
                  _result == null ? _buildLoginForm(l10n) : _buildSummaryView(l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBanner(AutoSyncStatus status) {
    final l10n = AppLocalizations.of(context)!;
    final hasError = status.lastError != null;
    final bannerColor = hasError ? Colors.red : Colors.green;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            status.isSyncing
                ? Icons.sync
                : (hasError ? Icons.error_outline : Icons.check_circle_outline),
            color: bannerColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.isSyncing
                      ? l10n.syncSyncing
                      : hasError
                          ? l10n.syncErrorTitle
                          : l10n.syncActiveInterval,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                if (status.lastSync != null && !status.isSyncing)
                  Text(
                    l10n.syncLastSync(_formatTime(status.lastSync!, l10n)),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                if (hasError)
                  Text(
                    status.lastError!,
                    style: const TextStyle(fontSize: 10, color: Colors.red),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => ref.read(autoSyncProvider.notifier).disableAutoSync(),
            child: Text(
              AppLocalizations.of(context)!.disable,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt, AppLocalizations l10n) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes.toString());
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildLoginForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.sync_alt, size: 80, color: Color(0xFF6366F1)),
        const SizedBox(height: 24),
        Text(
          l10n.syncSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        const SizedBox(height: 32),
        SegmentedButton<SchoolProvider>(
          segments: [
            ButtonSegment(value: SchoolProvider.librus, label: Text(AppLocalizations.of(context)!.librus), icon: const Icon(Icons.school)),
            ButtonSegment(value: SchoolProvider.vulcan, label: Text(AppLocalizations.of(context)!.vulcan), icon: const Icon(Icons.business)),
          ],
          selected: {_selectedProvider},
          onSelectionChanged: (set) => setState(() => _selectedProvider = set.first),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: _selectedProvider == SchoolProvider.librus
                ? l10n.syncLoginLibrus
                : l10n.syncVulcanTokenHint,
            prefixIcon: const Icon(Icons.person_outline),
            hintText: _selectedProvider == SchoolProvider.vulcan ? l10n.vulcanTokenHint : null,
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedProvider == SchoolProvider.vulcan) ...[
          TextField(
            decoration: InputDecoration(
              labelText: l10n.syncVulcanSymbolLabel,
              prefixIcon: const Icon(Icons.domain),
              hintText: l10n.vulcanSymbolHint,
            ),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: _selectedProvider == SchoolProvider.librus
                ? l10n.syncPassword
                : l10n.syncVulcanPinLabel,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SwitchListTile(
            title: Text(
              AppLocalizations.of(context)!.autoSync,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(l10n.autoSyncSubtitle),
            value: _enableAutoSync,
            onChanged: (v) => setState(() => _enableAutoSync = v),
            activeColor: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _startSync,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l10n.syncStart),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.syncSecurityNote,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSummaryView(AppLocalizations l10n) {
    final sortedGrades = List<Map<String, dynamic>>.from(_result!.grades)
      ..sort((a, b) {
        final ad = DateTime.tryParse(a['date']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = DateTime.tryParse(b['date']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad); // Newest first
      });

    final sortedExams = List<Map<String, dynamic>>.from(_result!.exams)
      ..sort((a, b) {
        final ad = DateTime.tryParse(a['date']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = DateTime.tryParse(b['date']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad); // Newest first
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.syncDataFound,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _summaryRow(Icons.subject, l10n.subjects, _result!.subjects.length.toString()),
                const Divider(),
                _summaryRow(Icons.grade, l10n.performance, _result!.grades.length.toString()),
                const Divider(),
                _summaryRow(Icons.event, l10n.calendarTitle, _result!.exams.length.toString()),
              ],
            ),
          ),
        ),
        if (sortedGrades.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(l10n.syncGradesDetail, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedGrades.length,
            itemBuilder: (context, index) {
              final grade = sortedGrades[index];
              final subName = grade['subject_name']?.toString() ?? l10n.unknown;
              final rawText = grade['raw_grade_text']?.toString() ?? '';
              final gradeVal = rawText.isNotEmpty ? rawText : (grade['grade']?.toString() ?? '0');
              final rawType = grade['type']?.toString() ?? l10n.gradeLabel;
              final gradeType = rawType.split('|')[0];
              final gradeWeight = grade['weight']?.toString() ?? '1';
              return ListTile(
                title: Wrap(
                  children: [
                    TranslatedText(subName),
                    Text(': $gradeVal'),
                  ],
                ),
                subtitle: Text(
                  '${l10n.syncTypeLabel(gradeType)} | ${l10n.syncWeightLabel(gradeWeight)} | ${l10n.syncPointsLabel(grade['max_points']?.toString() ?? '-', grade['points']?.toString() ?? '-')}',
                ),
                leading: CircleAvatar(
                  backgroundColor: _getTypeColor(gradeType),
                  child: Text(
                    gradeVal.isNotEmpty ? gradeVal.substring(0, gradeVal.length > 2 ? 2 : gradeVal.length) : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ],
        if (sortedExams.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(l10n.syncLibrusEvents, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedExams.length,
            itemBuilder: (context, index) {
              final exam = sortedExams[index];
              final subName = exam['subject_name']?.toString() ?? l10n.unknown;
              final title = exam['title']?.toString() ?? l10n.syncEventDefault;
              final examDateRaw = exam['date'];
              final examDate = examDateRaw != null
                  ? DateTime.tryParse(examDateRaw.toString()) ?? DateTime.now()
                  : DateTime.now();
              final formattedDate = '${examDate.day.toString().padLeft(2, '0')}.${examDate.month.toString().padLeft(2, '0')}.${examDate.year}';
              return ListTile(
                title: Wrap(
                  children: [
                    TranslatedText(subName),
                    Text(': $title'),
                  ],
                ),
                subtitle: Text(l10n.syncTerminLabel(formattedDate)),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF06B6D4),
                  child: Icon(Icons.calendar_month, color: Colors.white, size: 18),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SwitchListTile(
            title: Text(l10n.syncSaveAndAuto,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Text(l10n.syncSaveAndAutoSubtitle,
                style: const TextStyle(fontSize: 12)),
            value: _enableAutoSync,
            onChanged: (v) => setState(() => _enableAutoSync = v),
            activeColor: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _importData,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l10n.syncConfirmImport),
        ),
        TextButton(
          onPressed: () => setState(() => _result = null),
          child: Text(l10n.syncCancelReturn),
        ),
      ],
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6366F1)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'test': return Colors.red;
      case 'quiz': return Colors.orange;
      case 'homework': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
