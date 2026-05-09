import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/profile.dart';

final supabaseServiceProvider = Provider((ref) => SupabaseService());

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Auth
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> updatePassword(String newPassword) async {
    await client.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> updateEmail(String newEmail) async {
    await client.auth.updateUser(UserAttributes(email: newEmail));
  }

  User? get currentUser => client.auth.currentUser;

  // Profiles
  Future<Profile> getProfile() async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', currentUser!.id)
        .single();
    
    final profile = Profile.fromJson(response);
    String? displayName = profile.displayName;
    final email = currentUser?.email;

    // If name is missing OR is identical to full email, shorten it
    if (displayName == null || displayName.isEmpty || displayName == email) {
      if (email != null && email.contains('@')) {
        displayName = email.split('@')[0];
      }
    }

    return Profile(
      id: profile.id,
      displayName: displayName,
      avatarUrl: profile.avatarUrl,
    );
  }

  Future<void> updateProfile(Profile profile) async {
    await client
        .from('profiles')
        .update(profile.toJson())
        .eq('id', currentUser!.id);
  }

  Future<String> uploadAvatar(File file) async {
    final fileExt = file.path.split('.').last;
    final fileName = '${currentUser!.id}.$fileExt';
    final filePath = fileName;
    
    await client.storage.from('avatars').upload(
          filePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    
    return client.storage.from('avatars').getPublicUrl(filePath);
  }

  // Subjects
  Future<List<Subject>> getSubjects() async {
    final response = await client
        .from('subjects')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Subject.fromJson(json)).toList();
  }

  Future<Subject> addSubject(String name, {double? maxNormalPoints, double? maxBonusPoints}) async {
    final insertMap = {
      'name': name,
      'user_id': currentUser!.id,
      'max_normal_points': maxNormalPoints,
      'max_bonus_points': maxBonusPoints,
    };
    final response = await client
        .from('subjects')
        .insert(insertMap)
        .select()
        .single();
    return Subject.fromJson(response);
  }

  Future<void> updateSubject(String id, String name, {double? maxNormalPoints, double? maxBonusPoints}) async {
    final updateMap = {
      'name': name,
      'max_normal_points': maxNormalPoints,
      'max_bonus_points': maxBonusPoints,
    };
    // remove nulls so we don't overwrite existing values with null unintentionally
    updateMap.removeWhere((key, value) => value == null);
    await client.from('subjects').update(updateMap).eq('id', id);
  }

  Future<void> deleteSubject(String id) async {
    await client.from('subjects').delete().eq('id', id);
  }

  // Grades
  Future<List<Grade>> getGrades(String subjectId) async {
    final response = await client
        .from('grades')
        .select()
        .eq('subject_id', subjectId)
        .order('date', ascending: false);
    return (response as List).map((json) => Grade.fromJson(json)).toList();
  }

  Future<Grade> addGrade(Grade grade) async {
    final response = await client
        .from('grades')
        .insert(grade.toJson())
        .select()
        .single();
    return Grade.fromJson(response);
  }

  Future<void> updateGrade(Grade grade) async {
    await client.from('grades').update(grade.toJson()).eq('id', grade.id);
  }

  Future<void> deleteGrade(String id) async {
    await client.from('grades').delete().eq('id', id);
  }
}
