import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exam.dart';
import '../services/school_integration_service.dart';
import '../services/auto_sync_service.dart';
import '../providers/grade_provider.dart';
import '../l10n/app_localizations.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.syncError(e.toString()))),
        );
      }
    }
  }

  Future<void> _importData() async {
    if (_result == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      for (final rawSubject in _result!.subjects) {
        final subName = rawSubject['name']?.toString() ?? 'Przedmiot';
        final existing = ref.read(subjectsProvider).where((s) => s.name == subName);
        if (existing.isEmpty) {
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
      // Batch grade imports to avoid blocking UI with many awaits
      const int batchSize = 10;
      List<Future> futures = [];
      for (final rawGrade in _result!.grades) {
        final subName = rawGrade['subject_name']?.toString() ?? '';
        final subjectId = subjectsByName[subName];
        if (subjectId == null) continue;
        futures.add(ref.read(gradesProvider(subjectId).notifier).addGrade(
          (rawGrade['grade'] as num?)?.toDouble() ?? 0,
          (rawGrade['weight'] as num?)?.toDouble() ?? 1,
          rawGrade['type']?.toString() ?? 'test',
          points: (rawGrade['points'] as num?)?.toDouble(),
          maxPoints: (rawGrade['max_points'] as num?)?.toDouble(),
          refreshAverages: false,
        ));

        if (futures.length >= batchSize) {
          await Future.wait(futures);
          futures.clear();
        }
      }
      if (futures.isNotEmpty) await Future.wait(futures);

      // Batch exam imports as well
      futures = [];
      for (final rawExam in _result!.exams) {
        final subName = rawExam['subject_name']?.toString() ?? '';
        final subjectId = subjectsByName[subName];
        if (subjectId == null) continue;
        final examDateRaw = rawExam['date'];
        final examDate = examDateRaw != null
            ? DateTime.tryParse(examDateRaw.toString()) ?? DateTime.now()
            : DateTime.now();
        futures.add(ref.read(examsProvider.notifier).addExam(
          Exam(
            id: '',
            subjectId: subjectId,
            title: rawExam['title']?.toString() ?? l10n.gradeTypeTest,
            date: examDate,
            weight: (rawExam['weight'] as num?)?.toDouble() ?? 1.0,
            maxPoints: rawExam['max_points'] != null
                ? (rawExam['max_points'] as num).toDouble()
                : null,
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
    } catch (e) {
      debugPrint('[Import] Error: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.syncImportedCount(
          _result!.grades.length.toString(),
          _result!.exams.length.toString(),
        ))),
      );
      Navigator.pop(context);
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
              tooltip: 'Synchronizuj teraz',
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
                      ? 'Synchronizacja w toku...'
                      : hasError
                          ? 'Błąd synchronizacji'
                          : 'Auto-sync aktywny (co 15 min)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                if (status.lastSync != null && !status.isSyncing)
                  Text(
                    'Ostatnia: ${_formatTime(status.lastSync!)}',
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

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'przed chwilą';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min temu';
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
            hintText: _selectedProvider == SchoolProvider.vulcan ? 'np. 3H6K9...' : null,
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedProvider == SchoolProvider.vulcan) ...[
          TextField(
            decoration: InputDecoration(
              labelText: l10n.syncVulcanSymbolLabel,
              prefixIcon: const Icon(Icons.domain),
              hintText: 'np. powiat-warszawski',
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
            subtitle: const Text('Automatycznie pobieraj nowe oceny w tle',
                style: TextStyle(fontSize: 12)),
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
        const SizedBox(height: 24),
        Text(l10n.syncGradesDetail, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _result!.grades.length,
          itemBuilder: (context, index) {
            final grade = _result!.grades[index];
            final subName = grade['subject_name']?.toString() ?? l10n.unknown;
            final gradeVal = grade['grade']?.toString() ?? '0';
            final gradeType = grade['type']?.toString() ?? l10n.gradeLabel;
            final gradeWeight = grade['weight']?.toString() ?? '1';
            return ListTile(
              title: Text('$subName: $gradeVal'),
              subtitle: Text(
                '${l10n.syncTypeLabel(gradeType)} | ${l10n.syncWeightLabel(gradeWeight)} | ${l10n.syncPointsLabel(grade['points']?.toString() ?? '-', grade['max_points']?.toString() ?? '-')}',
              ),
              leading: CircleAvatar(
                backgroundColor: _getTypeColor(gradeType),
                child: Text(
                  gradeVal.isNotEmpty ? gradeVal.substring(0, 1) : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SwitchListTile(
            title: const Text('Zapisz i auto-sync',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: const Text('Odświeżaj oceny automatycznie co 15 min',
                style: TextStyle(fontSize: 12)),
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
