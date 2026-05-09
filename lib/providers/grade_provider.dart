import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../services/supabase_service.dart';

final supabaseServiceProvider = Provider((ref) => SupabaseService());

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>>((ref) {
  return SubjectsNotifier(ref.watch(supabaseServiceProvider));
});

class SubjectsNotifier extends StateNotifier<List<Subject>> {
  final SupabaseService _service;
  SubjectsNotifier(this._service) : super([]) {
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    try {
      state = await _service.getSubjects();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addSubject(String name) async {
    final newSubject = await _service.addSubject(name);
    state = [...state, newSubject];
  }

  Future<void> deleteSubject(String id) async {
    await _service.deleteSubject(id);
    state = state.where((s) => s.id != id).toList();
  }
}

final gradesProvider = StateNotifierProvider.family<GradesNotifier, List<Grade>, String>((ref, subjectId) {
  return GradesNotifier(ref.watch(supabaseServiceProvider), subjectId);
});

class GradesNotifier extends StateNotifier<List<Grade>> {
  final SupabaseService _service;
  final String subjectId;
  GradesNotifier(this._service, this.subjectId) : super([]) {
    loadGrades();
  }

  Future<void> loadGrades() async {
    try {
      state = await _service.getGrades(subjectId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addGrade(double grade, double weight, String type) async {
    final newGrade = await _service.addGrade(Grade(
      id: '',
      subjectId: subjectId,
      grade: grade,
      weight: weight,
      type: type,
      date: DateTime.now(),
    ));
    state = [newGrade, ...state];
  }

  Future<void> deleteGrade(String id) async {
    await _service.deleteGrade(id);
    state = state.where((g) => g.id != id).toList();
  }
}

// Average calculation provider
final averageProvider = Provider.family<double, String>((ref, subjectId) {
  final grades = ref.watch(gradesProvider(subjectId));
  if (grades.isEmpty) return 0.0;
  
  double totalWeightedSum = 0;
  double totalWeights = 0;
  
  for (var g in grades) {
    totalWeightedSum += g.grade * g.weight;
    totalWeights += g.weight;
  }
  
  return totalWeights == 0 ? 0.0 : totalWeightedSum / totalWeights;
});
