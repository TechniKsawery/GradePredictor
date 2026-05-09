import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/subject.dart';
import '../providers/grade_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/locale_provider.dart';
import '../services/supabase_service.dart';
import 'subject_detail_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'calendar_screen.dart';
import 'school_sync_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider);
    final profile = ref.watch(profileProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context, l10n),
          ),
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(subjectsProvider.notifier).loadSubjects(),
            ),
          if (_currentIndex == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(examsProvider.notifier).loadExams(),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(supabaseServiceProvider).signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(context, subjects, profile, locale, l10n, colorScheme, isDark),
          const CalendarScreen(),
          const StatsScreen(),
          const SettingsScreen(),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSubjectDialog(context, ref),
              label: Text(l10n.addSubject),
              icon: const Icon(Icons.add),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: l10n.subjects,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: l10n.calendarTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: l10n.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(
    BuildContext context,
    List subjects,
    profile,
    Locale locale,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Stack(
      children: [
        _buildHomeBackground(context, isDark),
        Column(
          children: [
            _buildUserHeader(context, profile, locale, l10n),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SchoolSyncScreen())),
                icon: const Icon(Icons.sync, size: 18),
                label: const Text('Importuj dane z e-dziennika'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.5)),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(subjectsProvider.notifier).loadSubjects(),
                child: subjects.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 32),
                          Center(
                            child: Text(
                              l10n.noSubjects,
                              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          final average = ref.watch(averageProvider(subject.id));
                          return _buildSubjectCard(context, ref, subject, average, l10n);
                        },
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHomeBackground(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    final topColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final glowA = isDark ? const Color(0xFF6366F1).withValues(alpha: 0.25) : const Color(0xFF06B6D4).withValues(alpha: 0.18);
    final glowB = isDark ? const Color(0xFF06B6D4).withValues(alpha: 0.18) : const Color(0xFF6366F1).withValues(alpha: 0.16);

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [topColor, colorScheme.surface.withValues(alpha: 0.95)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60,
              right: -40,
              child: _blurCircle(160, glowA),
            ),
            Positioned(
              top: 120,
              left: -60,
              child: _blurCircle(200, glowB),
            ),
            Positioned(
              bottom: -80,
              right: -40,
              child: _blurCircle(220, glowA.withValues(alpha: 0.2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 20)],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, profile, Locale locale, AppLocalizations l10n) {
    String flag = '🇵🇱';
    if (locale.languageCode == 'en') flag = '🇺🇸';
    if (locale.languageCode == 'de') flag = '🇩🇪';

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF6366F1).withValues(alpha: 0.9), const Color(0xFF06B6D4).withValues(alpha: 0.9)]
          : [const Color(0xFF7C8CF8), const Color(0xFF63D5E6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: headerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      backgroundImage: profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null,
                      child: profile?.avatarUrl == null ? Icon(Icons.person, color: colorScheme.onPrimary) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.displayName ?? l10n.user,
                            style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            l10n.settings,
                            style: TextStyle(color: colorScheme.onPrimary.withValues(alpha: 0.8), fontSize: 12, decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _showLanguageQuickMenu(context, l10n),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      locale.languageCode.toUpperCase(),
                      style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageQuickMenu(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final current = ref.watch(localeProvider);
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.chooseLanguage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 20),
                _langTile(ref, context, '🇵🇱 Polski', const Locale('pl'), current),
                _langTile(ref, context, '🇺🇸 English', const Locale('en'), current),
                _langTile(ref, context, '🇩🇪 Deutsch', const Locale('de'), current),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.infoTitle),
        content: Text(l10n.infoBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.ok)),
        ],
      ),
    );
  }

  Widget _langTile(WidgetRef ref, BuildContext context, String label, Locale locale, Locale current) {
    final isSelected = current.languageCode == locale.languageCode;
    return ListTile(
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF6366F1)) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSubjectCard(BuildContext context, WidgetRef ref, subject, double average, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SubjectDetailScreen(subject: subject)),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.book, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${l10n.currentAverage}: ${average.toStringAsFixed(2)}',
                      style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface.withValues(alpha: 0.5), size: 20),
                    onPressed: () => _showEditSubjectDialog(context, ref, subject),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.onSurface.withValues(alpha: 0.5), size: 20),
                    onPressed: () => _showDeleteSubjectConfirm(context, ref, subject),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteSubjectConfirm(BuildContext context, WidgetRef ref, subject) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteSubjectConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              ref.read(subjectsProvider.notifier).deleteSubject(subject.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showEditSubjectDialog(BuildContext context, WidgetRef ref, subject) {
    final controller = TextEditingController(text: subject.name);
    final maxNormalController = TextEditingController(text: subject.maxNormalPoints?.toString() ?? '');
    final maxBonusController = TextEditingController(text: subject.maxBonusPoints?.toString() ?? '');
    String gradingMode = subject.gradingMode;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editSubject),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: l10n.subjectNameHint),
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: gradingMode,
                  items: [
                    DropdownMenuItem(value: Subject.gradingModeGrades, child: Text(l10n.gradingModeGrades)),
                    DropdownMenuItem(value: Subject.gradingModePoints, child: Text(l10n.gradingModePoints)),
                    DropdownMenuItem(value: Subject.gradingModeMixed, child: Text(l10n.gradingModeMixed)),
                  ],
                  onChanged: (v) => setState(() => gradingMode = v!),
                  decoration: InputDecoration(labelText: l10n.gradingModeLabel),
                ),
                const SizedBox(height: 8),
                if (gradingMode != Subject.gradingModeGrades) ...[
                  TextField(
                    controller: maxNormalController,
                    decoration: InputDecoration(labelText: l10n.maxNormalPoints),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxBonusController,
                    decoration: InputDecoration(labelText: l10n.maxBonusPoints),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _showCustomScaleDialog(context, ref, subject),
                  icon: const Icon(Icons.rule, size: 18),
                  label: Text(l10n.customGradingScaleTitle),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isEmpty) {
                  _showSnack(context, l10n.validationSubjectName);
                  return;
                }
                final maxN = gradingMode != Subject.gradingModeGrades
                    ? double.tryParse(maxNormalController.text)
                    : null;
                final maxB = gradingMode != Subject.gradingModeGrades
                    ? double.tryParse(maxBonusController.text)
                    : null;
                if (gradingMode != Subject.gradingModeGrades && (maxN == null || maxN <= 0)) {
                  _showSnack(context, l10n.validationMaxPoints);
                  return;
                }
                ref.read(subjectsProvider.notifier).updateSubject(
                  subject.id,
                  controller.text,
                  maxNormalPoints: maxN,
                  maxBonusPoints: maxB,
                  gradingMode: gradingMode,
                );
                Navigator.pop(context);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final maxNormalController = TextEditingController();
    final maxBonusController = TextEditingController();
    String gradingMode = Subject.gradingModeMixed;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.newSubject),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: l10n.subjectNameHint),
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: gradingMode,
                  items: [
                    DropdownMenuItem(value: Subject.gradingModeGrades, child: Text(l10n.gradingModeGrades)),
                    DropdownMenuItem(value: Subject.gradingModePoints, child: Text(l10n.gradingModePoints)),
                    DropdownMenuItem(value: Subject.gradingModeMixed, child: Text(l10n.gradingModeMixed)),
                  ],
                  onChanged: (v) => setState(() => gradingMode = v!),
                  decoration: InputDecoration(labelText: l10n.gradingModeLabel),
                ),
                const SizedBox(height: 8),
                if (gradingMode != Subject.gradingModeGrades) ...[
                  TextField(
                    controller: maxNormalController,
                    decoration: InputDecoration(labelText: l10n.maxNormalPoints),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxBonusController,
                    decoration: InputDecoration(labelText: l10n.maxBonusPoints),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isEmpty) {
                  _showSnack(context, l10n.validationSubjectName);
                  return;
                }
                final maxN = gradingMode != Subject.gradingModeGrades
                    ? double.tryParse(maxNormalController.text)
                    : null;
                final maxB = gradingMode != Subject.gradingModeGrades
                    ? double.tryParse(maxBonusController.text)
                    : null;
                if (gradingMode != Subject.gradingModeGrades && (maxN == null || maxN <= 0)) {
                  _showSnack(context, l10n.validationMaxPoints);
                  return;
                }
                ref.read(subjectsProvider.notifier).addSubjectWithPoints(
                  controller.text,
                  maxNormalPoints: maxN,
                  maxBonusPoints: maxB,
                  gradingMode: gradingMode,
                );
                Navigator.pop(context);
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCustomScaleDialog(BuildContext context, WidgetRef ref, Subject subject) {
    final l10n = AppLocalizations.of(context)!;
    final globalScale = ref.read(settingsProvider);
    final currentScale = subject.customGradingScale ?? {};

    final controllers = {
      'grade6': TextEditingController(text: (currentScale['grade6'] ?? globalScale.grade6).toStringAsFixed(0)),
      'grade5': TextEditingController(text: (currentScale['grade5'] ?? globalScale.grade5).toStringAsFixed(0)),
      'grade4': TextEditingController(text: (currentScale['grade4'] ?? globalScale.grade4).toStringAsFixed(0)),
      'grade3': TextEditingController(text: (currentScale['grade3'] ?? globalScale.grade3).toStringAsFixed(0)),
      'grade2': TextEditingController(text: (currentScale['grade2'] ?? globalScale.grade2).toStringAsFixed(0)),
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customGradingScaleTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _scaleField(l10n.grade6Label, controllers['grade6']!),
              _scaleField(l10n.grade5Label, controllers['grade5']!),
              _scaleField(l10n.grade4Label, controllers['grade4']!),
              _scaleField(l10n.grade3Label, controllers['grade3']!),
              _scaleField(l10n.grade2Label, controllers['grade2']!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(subjectsProvider.notifier).updateSubject(
                subject.id,
                subject.name,
                customGradingScale: null, // Reset to global
              );
              Navigator.pop(context);
            },
            child: Text(l10n.resetToGlobal),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final newScale = controllers.map((key, controller) => 
                MapEntry(key, double.tryParse(controller.text) ?? 0.0)
              );
              ref.read(subjectsProvider.notifier).updateSubject(
                subject.id,
                subject.name,
                customGradingScale: newScale,
              );
              Navigator.pop(context);
              _showSnack(context, l10n.customScaleSaved);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _scaleField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixText: '%',
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
