import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../providers/grade_provider.dart';
import '../providers/locale_provider.dart';
import '../services/supabase_service.dart';
import '../providers/accounts_provider.dart';
import '../providers/profile_provider.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    final supabase = ref.read(supabaseServiceProvider);
    final l10n = AppLocalizations.of(context)!;
    
    try {
      if (_isSignUp) {
        final response = await supabase.signUp(_emailController.text, _passwordController.text);
        if (mounted) {
          if (response.session != null) {
            // Auto-save to multi-account list
            await ref.read(accountsProvider.notifier).addAccount(
              _emailController.text, 
              _passwordController.text, 
              l10n.myAccount
            );
            // Invalidate providers to ensure fresh data for the new user
            ref.invalidate(subjectsProvider);
            ref.invalidate(examsProvider);
            ref.invalidate(profileProvider);
            ref.invalidate(gradesProvider);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.accountCreated)),
            );
            setState(() => _isSignUp = false);
          }
        }
      } else {
        await supabase.signIn(_emailController.text, _passwordController.text);
        if (mounted) {
          // Auto-save to multi-account list
          await ref.read(accountsProvider.notifier).addAccount(
            _emailController.text, 
            _passwordController.text, 
            l10n.myAccount
          );
          // Invalidate providers to ensure fresh data for the new user
          ref.invalidate(subjectsProvider);
          ref.invalidate(examsProvider);
          ref.invalidate(profileProvider);
          ref.invalidate(gradesProvider);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLanguagePicker(ref),
              const SizedBox(height: 24),
              const Icon(Icons.auto_graph, size: 80, color: Color(0xFF6366F1)),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp ? l10n.welcomeBack : l10n.welcomeBack, // Adjust if needed
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: l10n.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: l10n.password,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleAuth,
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isSignUp ? l10n.signUp : l10n.login),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp ? l10n.alreadyHaveAccount : l10n.newHere,
                  style: const TextStyle(color: Color(0xFF06B6D4)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguagePicker(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _langButton(ref, 'PL', const Locale('pl')),
        _langButton(ref, 'EN', const Locale('en')),
        _langButton(ref, 'DE', const Locale('de')),
      ],
    );
  }

  Widget _langButton(WidgetRef ref, String label, Locale locale) {
    final currentLocale = ref.watch(localeProvider);
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return TextButton(
      onPressed: () => ref.read(localeProvider.notifier).setLocale(locale),
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? const Color(0xFF6366F1) : Colors.white38,
      ),
      child: Text(label),
    );
  }
}
