import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/exam.dart';
import '../services/supabase_service.dart';


final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>>((ref) {
  return SubjectsNotifier(ref.watch(supabaseServiceProvider));
});

final subjectAveragesProvider = FutureProvider<Map<String, double>>((ref) async {
  final service = ref.watch(supabaseServiceProvider);
  return service.getSubjectAverages();
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

  Future<void> addSubjectWithPoints(
    String name, {
    double? maxNormalPoints,
    double? maxBonusPoints,
    String? gradingMode,
    Map<String, double>? customGradingScale,
  }) async {
    final newSubject = await _service.addSubject(
      name,
      maxNormalPoints: maxNormalPoints,
      maxBonusPoints: maxBonusPoints,
      gradingMode: gradingMode,
      customGradingScale: customGradingScale,
    );
    state = [...state, newSubject];
  }

  Future<void> updateSubject(
    String id,
    String name, {
    double? maxNormalPoints,
    double? maxBonusPoints,
    String? gradingMode,
    Map<String, double>? customGradingScale,
  }) async {
    await _service.updateSubject(
      id,
      name,
      maxNormalPoints: maxNormalPoints,
      maxBonusPoints: maxBonusPoints,
      gradingMode: gradingMode,
      customGradingScale: customGradingScale,
    );
    state = state.map<Subject>((s) => s.id == id ? Subject(
      id: s.id,
      userId: s.userId,
      name: name,
      createdAt: s.createdAt,
      maxNormalPoints: maxNormalPoints ?? s.maxNormalPoints,
      maxBonusPoints: maxBonusPoints ?? s.maxBonusPoints,
      gradingMode: gradingMode ?? s.gradingMode,
      customGradingScale: customGradingScale ?? s.customGradingScale,
    ) : s).toList();
  }

  Future<void> deleteSubject(String id) async {
    await _service.deleteSubject(id);
    state = state.where((s) => s.id != id).toList();
  }
}

final gradesProvider = StateNotifierProvider.family<GradesNotifier, List<Grade>, String>((ref, subjectId) {
  return GradesNotifier(ref.watch(supabaseServiceProvider), subjectId, ref);
});

class GradesNotifier extends StateNotifier<List<Grade>> {
  final SupabaseService _service;
  final String subjectId;
  final Ref _ref;
  GradesNotifier(this._service, this.subjectId, this._ref) : super([]) {
    loadGrades();
  }

  Future<void> loadGrades() async {
    try {
      state = await _service.getGrades(subjectId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addGrade(
    double grade,
    double weight,
    String type, {
    double? points,
    double? maxPoints,
    bool refreshAverages = true,
  }) async {
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
    if (refreshAverages) {
      _ref.invalidate(subjectAveragesProvider);
    }
  }

  Future<void> updateGrade(Grade grade) async {
    await _service.updateGrade(grade);
    state = state.map<Grade>((g) => g.id == grade.id ? grade : g).toList();
    _ref.invalidate(subjectAveragesProvider);
  }

  Future<void> deleteGrade(String id) async {
    await _service.deleteGrade(id);
    state = state.where((g) => g.id != id).toList();
    _ref.invalidate(subjectAveragesProvider);
  }
}

final examsProvider = StateNotifierProvider<ExamsNotifier, List<Exam>>((ref) {
  return ExamsNotifier(ref.watch(supabaseServiceProvider));
});

class ExamsNotifier extends StateNotifier<List<Exam>> {
  final SupabaseService _service;
  ExamsNotifier(this._service) : super([]) {
    loadExams();
  }

  Future<void> loadExams() async {
    try {
      state = await _service.getExams();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addExam(Exam exam) async {
    final newExam = await _service.addExam(exam);
    state = [...state, newExam]..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> updateExam(Exam exam) async {
    await _service.updateExam(exam);
    state = state.map<Exam>((e) => e.id == exam.id ? exam : e).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> deleteExam(String id) async {
    await _service.deleteExam(id);
    state = state.where((e) => e.id != id).toList();
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
