import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile.dart';
import '../services/supabase_service.dart';
import '../providers/accounts_provider.dart';
import '../providers/grade_provider.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile?>((ref) {
  return ProfileNotifier(ref.watch(supabaseServiceProvider), ref);
});

class ProfileNotifier extends StateNotifier<Profile?> {
  final SupabaseService _service;
  final Ref _ref;

  ProfileNotifier(this._service, this._ref) : super(null) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await _service.getProfile();
      state = profile;

      // Sync loaded name back to local account list
      final email = _service.currentUser?.email;
      if (email != null && profile.displayName != null) {
        _ref.read(accountsProvider.notifier).updateAccountName(email, profile.displayName!);
      }
    } catch (e) {
      // Profile might not exist yet
    }
  }

  Future<void> updateName(String name) async {
    if (state == null) return;
    final updated = Profile(id: state!.id, displayName: name, avatarUrl: state!.avatarUrl);
    await _service.updateProfile(updated);
    state = updated;

    // Sync with multi-account list
    final email = _service.currentUser?.email;
    if (email != null) {
      _ref.read(accountsProvider.notifier).updateAccountName(email, name);
    }
  }

  Future<void> updateAvatar(File file) async {
    if (state == null) return;
    final url = await _service.uploadAvatar(file);
    final updated = Profile(id: state!.id, displayName: state!.displayName, avatarUrl: url);
    await _service.updateProfile(updated);
    state = updated;
  }
}
