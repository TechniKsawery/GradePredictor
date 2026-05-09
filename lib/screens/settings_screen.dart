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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      body: Stack(
        children: [
          _buildSettingsBackground(context, isDark),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _buildSettingsHero(context, isDark, l10n),
                const SizedBox(height: 24),
                _buildAvatarSection(profile),
                const SizedBox(height: 32),
                _buildSectionCard(
                  context: context,
                  title: l10n.appearanceTitle,
                  subtitle: l10n.appearanceSubtitle,
                  child: Consumer(builder: (context, ref, _) {
                    final tm = ref.watch(themeProvider);
                    final chipColor = isDark ? const Color(0xFF0B1221) : const Color(0xFFF1F5F9);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.themeLight),
                          selected: tm == ThemeMode.light,
                          selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                          backgroundColor: chipColor,
                          labelStyle: TextStyle(color: tm == ThemeMode.light ? colorScheme.primary : colorScheme.onSurface),
                          onSelected: (_) => ref.read(themeProvider.notifier).setTheme(ThemeMode.light),
                        ),
                        ChoiceChip(
                          label: Text(l10n.themeSystem),
                          selected: tm == ThemeMode.system,
                          selectedColor: colorScheme.secondary.withValues(alpha: 0.15),
                          backgroundColor: chipColor,
                          labelStyle: TextStyle(color: tm == ThemeMode.system ? colorScheme.secondary : colorScheme.onSurface),
                          onSelected: (_) => ref.read(themeProvider.notifier).setTheme(ThemeMode.system),
                        ),
                        ChoiceChip(
                          label: Text(l10n.themeDark),
                          selected: tm == ThemeMode.dark,
                          selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                          backgroundColor: chipColor,
                          labelStyle: TextStyle(color: tm == ThemeMode.dark ? colorScheme.primary : colorScheme.onSurface),
                          onSelected: (_) => ref.read(themeProvider.notifier).setTheme(ThemeMode.dark),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
            _buildSectionCard(
              context: context,
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
              context: context,
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
              context: context,
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
              context: context,
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
              context: context,
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
                          icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                          onPressed: () => _showEditAccountNameDialog(context, ref, account),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
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
              context: context,
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
        ],
      ),
    );
  }

  Widget _buildSettingsBackground(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseTop = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final glowA = isDark ? const Color(0xFF6366F1).withValues(alpha: 0.2) : const Color(0xFF06B6D4).withValues(alpha: 0.18);
    final glowB = isDark ? const Color(0xFF06B6D4).withValues(alpha: 0.2) : const Color(0xFF6366F1).withValues(alpha: 0.16);

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [baseTop, colorScheme.surface.withValues(alpha: 0.98)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -40, right: -30, child: _blurCircle(140, glowA)),
            Positioned(top: 140, left: -60, child: _blurCircle(180, glowB)),
            Positioned(bottom: -60, right: -20, child: _blurCircle(180, glowA.withValues(alpha: 0.2))),
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

  Widget _buildSettingsHero(BuildContext context, bool isDark, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final heroGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
          : [const Color(0xFFFFFFFF), const Color(0xFFEFF6FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: heroGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsHeroTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.settingsHeroSubtitle,
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            height: 80,
            child: CustomPaint(
              painter: _LandscapePainter(isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(profile) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  backgroundImage: profile?.avatarUrl != null 
                      ? NetworkImage(profile!.avatarUrl!) 
                      : null,
                  child: profile?.avatarUrl == null 
                      ? Icon(Icons.person, size: 60, color: colorScheme.onSurface.withValues(alpha: 0.3)) 
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

  Widget _buildSectionCard({required BuildContext context, required String title, required String subtitle, required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
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
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
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
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final pass = passwordController.text.trim();

                if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.validationAllFields), backgroundColor: Colors.orange),
                  );
                  return;
                }

                try {
                  if (isRegister) {
                    await ref.read(accountsProvider.notifier).signUpAndAddAccount(email, pass, name);
                  } else {
                    await ref.read(accountsProvider.notifier).addAccount(email, pass, name);
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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? colorScheme.primary : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _LandscapePainter extends CustomPainter {
  final bool isDark;
  _LandscapePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..color = isDark ? const Color(0xFF0B1221) : const Color(0xFFE0F2FE)
      ..style = PaintingStyle.fill;
    final hillBack = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFF93C5FD)
      ..style = PaintingStyle.fill;
    final hillFront = Paint()
      ..color = isDark ? const Color(0xFF273449) : const Color(0xFF60A5FA)
      ..style = PaintingStyle.fill;
    final sunPaint = Paint()
      ..color = isDark ? const Color(0xFF94A3B8) : const Color(0xFFFBBF24)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      skyPaint,
    );

    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.3), size.height * 0.18, sunPaint);

    final back = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.55, size.width * 0.55, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.82, size.width, size.height * 0.65)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(back, hillBack);

    final front = Path()
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.75, size.width * 0.55, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.95, size.width, size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(front, hillFront);
  }

  @override
  bool shouldRepaint(covariant _LandscapePainter oldDelegate) => oldDelegate.isDark != isDark;
}
