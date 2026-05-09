import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/profile.dart';

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

  User? get currentUser => client.auth.currentUser;

  // Profiles
  Future<Profile> getProfile() async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', currentUser!.id)
        .single();
    return Profile.fromJson(response);
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

  Future<Subject> addSubject(String name) async {
    final response = await client
        .from('subjects')
        .insert({'name': name, 'user_id': currentUser!.id})
        .select()
        .single();
    return Subject.fromJson(response);
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

  Future<void> deleteGrade(String id) async {
    await client.from('grades').delete().eq('id', id);
  }
}
