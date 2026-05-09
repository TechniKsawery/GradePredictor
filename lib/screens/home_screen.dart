import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/grade_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/locale_provider.dart';
import '../services/supabase_service.dart';
import 'subject_detail_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsProvider);
    final profile = ref.watch(profileProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StatsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(subjectsProvider.notifier).loadSubjects(),
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
      body: Column(
        children: [
          _buildUserHeader(context, profile, locale, l10n),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(subjectsProvider.notifier).loadSubjects(),
              child: subjects.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [Center(child: Text(l10n.noSubjects))],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSubjectDialog(context, ref),
        label: Text(l10n.addSubject),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, profile, Locale locale, AppLocalizations l10n) {
    String flag = '🇵🇱';
    if (locale.languageCode == 'en') flag = '🇺🇸';
    if (locale.languageCode == 'de') flag = '🇩🇪';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6366F1).withValues(alpha: 0.8), const Color(0xFF06B6D4).withValues(alpha: 0.8)],
        ),
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
                      child: profile?.avatarUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.displayName ?? l10n.user,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            l10n.settings,
                            style: const TextStyle(color: Colors.white70, fontSize: 12, decoration: TextDecoration.underline),
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
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
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.book, color: Color(0xFF6366F1)),
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
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white24, size: 20),
                    onPressed: () => _showEditSubjectDialog(context, ref, subject),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 20),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              TextField(
                controller: maxNormalController,
                decoration: const InputDecoration(labelText: 'Maks. punktów (normalnych)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: maxBonusController,
                decoration: const InputDecoration(labelText: 'Maks. punktów (bonusowych)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final maxN = double.tryParse(maxNormalController.text);
                final maxB = double.tryParse(maxBonusController.text);
                ref.read(subjectsProvider.notifier).updateSubject(subject.id, controller.text, maxNormalPoints: maxN, maxBonusPoints: maxB);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final maxNormalController = TextEditingController();
    final maxBonusController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              TextField(
                controller: maxNormalController,
                decoration: const InputDecoration(labelText: 'Maks. punktów (normalnych)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: maxBonusController,
                decoration: const InputDecoration(labelText: 'Maks. punktów (bonusowych)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final maxN = double.tryParse(maxNormalController.text);
                final maxB = double.tryParse(maxBonusController.text);
                ref.read(subjectsProvider.notifier).addSubjectWithPoints(controller.text, maxNormalPoints: maxN, maxBonusPoints: maxB);
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
