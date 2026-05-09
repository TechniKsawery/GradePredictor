import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/accounts_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  String? _lastSeenUserEmail; // tracks which user's data is in the controllers

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      await ref.read(profileProvider.notifier).updateAvatar(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final profile = ref.watch(profileProvider);
    final scale = ref.watch(settingsProvider);
    final savedAccounts = ref.watch(accountsProvider);
    final currentUser = ref.watch(supabaseServiceProvider).currentUser;

    // Reset controllers whenever the logged-in user changes
    final currentEmail = currentUser?.email ?? '';
    if (currentEmail != _lastSeenUserEmail) {
      _lastSeenUserEmail = currentEmail;
      // Use addPostFrameCallback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nameController.text = profile?.displayName ?? currentEmail.split('@').first;
        _emailController.text = currentEmail;
      });
    } else if (profile != null && _nameController.text.isEmpty) {
      // Initial fill when profile loads for the first time
      _nameController.text = profile.displayName ?? currentEmail.split('@').first;
      _emailController.text = currentEmail;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildAvatarSection(profile),
            const SizedBox(height: 32),
            _buildSectionCard(
              title: 'Wygląd',
              subtitle: 'Motyw i styl aplikacji',
              child: Consumer(builder: (context, ref, _) {
                final tm = ref.watch(themeProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: const Text('Jasny ☀️'),
                      selected: tm == ThemeMode.light,
                      onSelected: (_) => ref.read(themeProvider.notifier).setTheme(ThemeMode.light),
                    ),
                    ChoiceChip(
                      label: const Text('System'),
                      selected: tm == ThemeMode.system,
                      onSelected: (_) => ref.read(themeProvider.notifier).setTheme(ThemeMode.system),
                    ),
                    ChoiceChip(
                      label: const Text('Ciemny 🌙'),
                      selected: tm == ThemeMode.dark,
                      onSelected: (_) => ref.read(themeProvider.notifier).setTheme(ThemeMode.dark),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: l10n.displayName,
              subtitle: l10n.profileDescription,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.displayName,
                  hintText: l10n.enterName,
                  prefixIcon: const Icon(Icons.badge_outlined),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        await ref.read(profileProvider.notifier).updateName(_nameController.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.profileUpdated)),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save, color: Color(0xFF10B981)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: l10n.changeLanguage,
              subtitle: l10n.languageDescription,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _langOption(ref, 'Polski', const Locale('pl'), currentLocale),
                    _langOption(ref, 'English', const Locale('en'), currentLocale),
                    _langOption(ref, 'Deutsch', const Locale('de'), currentLocale),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: l10n.changePassword,
              subtitle: l10n.passwordDescription,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.newPassword,
                  hintText: l10n.passwordHint,
                  prefixIcon: const Icon(Icons.password_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.update_rounded, color: Color(0xFF6366F1)),
                    onPressed: () async {
                      try {
                        if (_passwordController.text.length < 6) throw 'Password too short';
                        await ref.read(supabaseServiceProvider).updatePassword(_passwordController.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.passwordUpdated)),
                          );
                          _passwordController.clear();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.error(e.toString())), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: l10n.changeEmail,
              subtitle: l10n.changeEmailDescription,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.changeEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.update_rounded, color: Color(0xFF6366F1)),
                    onPressed: () async {
                      final newEmail = _emailController.text.trim();
                      final oldEmail = currentUser?.email ?? '';
                      if (newEmail.isEmpty || !newEmail.contains('@') || newEmail == oldEmail) return;
                      try {
                        await ref.read(supabaseServiceProvider).updateEmail(newEmail);
                        ref.read(accountsProvider.notifier).updateAccountEmail(oldEmail, newEmail);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.emailUpdated)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.error(e.toString())), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: l10n.multiAccount,
              subtitle: l10n.multiAccountSubtitle,
              child: Column(
                children: [
                   ...savedAccounts.map((account) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(account.displayName ?? account.email),
                    subtitle: Text(account.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (currentUser?.email != account.email)
                          IconButton(
                            icon: const Icon(Icons.swap_horiz, color: Color(0xFF6366F1)),
                            onPressed: () async {
                              await ref.read(accountsProvider.notifier).switchAccount(account, ref);
                              ref.invalidate(profileProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.switchedTo(account.displayName ?? account.email))),
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.white24),
                          onPressed: () => _showEditAccountNameDialog(context, ref, account),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white24),
                          onPressed: () => ref.read(accountsProvider.notifier).removeAccount(account.email),
                        ),
                      ],
                    ),
                  )),
                  const Divider(),
                  TextButton.icon(
                    onPressed: () => _showAddAccountDialog(context, ref),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: Text(l10n.addRegisterAccount),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: l10n.gradingScale,
              subtitle: l10n.gradingScaleSubtitle,
              child: Column(
                children: [
                  _scaleInput(l10n.grade6Label, scale.grade6, (v) => ref.read(settingsProvider.notifier).updateScale(GradingScale(grade2: scale.grade2, grade3: scale.grade3, grade4: scale.grade4, grade5: scale.grade5, grade6: v))),
                  _scaleInput(l10n.grade5Label, scale.grade5, (v) => ref.read(settingsProvider.notifier).updateScale(GradingScale(grade2: scale.grade2, grade3: scale.grade3, grade4: scale.grade4, grade5: v, grade6: scale.grade6))),
                  _scaleInput(l10n.grade4Label, scale.grade4, (v) => ref.read(settingsProvider.notifier).updateScale(GradingScale(grade2: scale.grade2, grade3: scale.grade3, grade4: v, grade5: scale.grade5, grade6: scale.grade6))),
                  _scaleInput(l10n.grade3Label, scale.grade3, (v) => ref.read(settingsProvider.notifier).updateScale(GradingScale(grade2: scale.grade2, grade3: v, grade4: scale.grade4, grade5: scale.grade5, grade6: scale.grade6))),
                  _scaleInput(l10n.grade2Label, scale.grade2, (v) => ref.read(settingsProvider.notifier).updateScale(GradingScale(grade2: v, grade3: scale.grade3, grade4: scale.grade4, grade5: scale.grade5, grade6: scale.grade6))),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(profile) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6366F1), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF1E293B),
                  backgroundImage: profile?.avatarUrl != null 
                      ? NetworkImage(profile!.avatarUrl!) 
                      : null,
                  child: profile?.avatarUrl == null 
                      ? const Icon(Icons.person, size: 60, color: Colors.white24) 
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required String subtitle, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _scaleInput(String label, double value, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          SizedBox(
            width: 60,
            child: TextField(
              decoration: const InputDecoration(
                suffixText: '%',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: value.toStringAsFixed(0)),
              onSubmitted: (v) => onChanged(double.tryParse(v) ?? value),
            ),
          ),
        ],
      ),
    );
  }

   void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    bool isRegister = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isRegister ? l10n.registerNewChild : l10n.addExistingAccount),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text(l10n.newRegistration, style: const TextStyle(fontSize: 14)),
                  value: isRegister,
                  onChanged: (v) => setState(() => isRegister = v),
                  activeColor: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 12),
                TextField(controller: nameController, decoration: InputDecoration(labelText: l10n.childUserName, hintText: l10n.nameHint)),
                TextField(controller: emailController, decoration: InputDecoration(labelText: l10n.email)),
                TextField(controller: passwordController, decoration: InputDecoration(labelText: l10n.password), obscureText: true),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (isRegister) {
                    await ref.read(accountsProvider.notifier).signUpAndAddAccount(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                    );
                  } else {
                    await ref.read(accountsProvider.notifier).addAccount(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                    );
                  }
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${l10n.error(e.toString())}'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: Text(isRegister ? l10n.signUp : l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAccountNameDialog(BuildContext context, WidgetRef ref, account) {
    final controller = TextEditingController(text: account.displayName);
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.childUserName),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              ref.read(accountsProvider.notifier).updateAccountName(account.email, controller.text);
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _langOption(WidgetRef ref, String label, Locale locale, Locale current) {
    final isSelected = current.languageCode == locale.languageCode;
    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF6366F1) : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF6366F1) : Colors.white60,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
