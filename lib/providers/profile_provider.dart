import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile.dart';
import '../providers/grade_provider.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile?>((ref) {
  return ProfileNotifier(ref.watch(supabaseServiceProvider));
});

class ProfileNotifier extends StateNotifier<Profile?> {
  final _service = SupabaseService();
  ProfileNotifier(SupabaseService service) : super(null) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = await _service.getProfile();
    } catch (e) {
      // Profile might not exist yet
    }
  }

  Future<void> updateName(String name) async {
    if (state == null) return;
    final updated = Profile(id: state!.id, displayName: name, avatarUrl: state!.avatarUrl);
    await _service.updateProfile(updated);
    state = updated;
  }

  Future<void> updateAvatar(File file) async {
    if (state == null) return;
    final url = await _service.uploadAvatar(file);
    final updated = Profile(id: state!.id, displayName: state!.displayName, avatarUrl: url);
    await _service.updateProfile(updated);
    state = updated;
  }
}
