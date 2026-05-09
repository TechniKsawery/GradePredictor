import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../services/supabase_service.dart';


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

  Future<void> addSubjectWithPoints(String name, {double? maxNormalPoints, double? maxBonusPoints}) async {
    final newSubject = await _service.addSubject(name, maxNormalPoints: maxNormalPoints, maxBonusPoints: maxBonusPoints);
    state = [...state, newSubject];
  }

  Future<void> updateSubject(String id, String name, {double? maxNormalPoints, double? maxBonusPoints}) async {
    await _service.updateSubject(id, name, maxNormalPoints: maxNormalPoints, maxBonusPoints: maxBonusPoints);
    state = state.map<Subject>((s) => s.id == id ? Subject(
      id: s.id,
      userId: s.userId,
      name: name,
      createdAt: s.createdAt,
      maxNormalPoints: maxNormalPoints ?? s.maxNormalPoints,
      maxBonusPoints: maxBonusPoints ?? s.maxBonusPoints,
    ) : s).toList();
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

  Future<void> addGrade(double grade, double weight, String type, {double? points, double? maxPoints}) async {
    final newGrade = await _service.addGrade(Grade(
      id: '',
      subjectId: subjectId,
      grade: grade,
      weight: weight,
      type: type,
      date: DateTime.now(),
      points: points,
      maxPoints: maxPoints,
    ));
    state = [newGrade, ...state];
  }

  Future<void> updateGrade(Grade grade) async {
    await _service.updateGrade(grade);
    state = state.map<Grade>((g) => g.id == grade.id ? grade : g).toList();
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
