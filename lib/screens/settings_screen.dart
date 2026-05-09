import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/grade_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final profile = ref.read(profileProvider);
      if (profile != null) {
        _nameController.text = profile.displayName ?? '';
      }
    });
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
    final profile = ref.watch(profileProvider);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF1E293B),
                    backgroundImage: profile?.avatarUrl != null 
                        ? NetworkImage(profile!.avatarUrl!) 
                        : null,
                    child: profile?.avatarUrl == null 
                        ? const Icon(Icons.person, size: 60, color: Colors.white24) 
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxType.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              l10n.displayName,
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: Color(0xFF10B981)),
                    onPressed: () async {
                      await ref.read(profileProvider.notifier).updateName(_nameController.text);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.profileUpdated)),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              l10n.changeLanguage,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _langOption(ref, 'Polski', const Locale('pl'), currentLocale),
                  _langOption(ref, 'English', const Locale('en'), currentLocale),
                  _langOption(ref, 'Deutsch', const Locale('de'), currentLocale),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              l10n.changePassword,
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: l10n.newPassword,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.lock_reset, color: Color(0xFF6366F1)),
                    onPressed: () async {
                      try {
                        await ref.read(supabaseServiceProvider).updatePassword(_passwordController.text);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.passwordUpdated)),
                          );
                          _passwordController.clear();
                        }
                      } catch (e) {
                        if (mounted) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: child,
        ),
      ],
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
