import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/exam.dart';
import '../services/supabase_service.dart';


final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>>((ref) {
  return SubjectsNotifier(ref.watch(supabaseServiceProvider));
});

final subjectAveragesProvider = Provider<Map<String, double>>((ref) {
  final subjects = ref.watch(subjectsProvider);
  final Map<String, double> averages = {};
  
  for (final subject in subjects) {
    // Watch grades for each subject. 
    // It's a bit heavy to watch all, but this correctly uses cached data
    // instead of repeatedly hitting the DB via getSubjectAverages.
    final grades = ref.watch(gradesProvider(subject.id));
    
    double sum = 0.0;
    double weights = 0.0;
    for (final g in grades) {
      if (g.grade > 0) {
        sum += g.grade * g.weight;
        weights += g.weight;
      }
    }
    averages[subject.id] = weights > 0 ? sum / weights : 0.0;
  }
  return averages;
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
    final parts = type.split('|');
    final actualType = parts[0];
    final semester = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
    final rawText = parts.length > 2 ? parts[2] : null;

    final newGrade = await _service.addGrade(Grade(
      id: '',
      subjectId: subjectId,
      grade: grade,
      weight: weight,
      type: actualType,
      semester: semester,
      date: DateTime.now(),
      points: points,
      maxPoints: maxPoints,
      rawText: rawText,
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

final semesterFilterProvider = StateProvider<int>((ref) => 0);

final gradeCategoryFilterProvider = StateProvider<String?>((ref) => null);

final gradeSortProvider = StateProvider<String>((ref) => 'date_desc');

final filteredGradesProvider = Provider.family<List<Grade>, String>((ref, subjectId) {
  final grades = ref.watch(gradesProvider(subjectId));
  final semester = ref.watch(semesterFilterProvider);
  final sort = ref.watch(gradeSortProvider);
  final category = ref.watch(gradeCategoryFilterProvider);
  final filtered = grades.where((grade) {
    if (semester != 0 && grade.semester != semester) return false;
    if (category != null && grade.type != category) return false;
    return true;
  }).toList();

  filtered.sort((a, b) {
    switch (sort) {
      case 'date_asc':
        return a.date.compareTo(b.date);
      case 'grade_desc':
        return b.grade.compareTo(a.grade);
      case 'grade_asc':
        return a.grade.compareTo(b.grade);
      case 'date_desc':
      default:
        return b.date.compareTo(a.date);
    }
  });

  return filtered;
});

final filteredAverageProvider = Provider.family<double, String>((ref, subjectId) {
  final grades = ref.watch(filteredGradesProvider(subjectId));
  if (grades.isEmpty) return 0.0;

  var totalWeightedSum = 0.0;
  var totalWeights = 0.0;

  for (final grade in grades) {
    totalWeightedSum += grade.grade * grade.weight;
    totalWeights += grade.weight;
  }

  return totalWeights == 0 ? 0.0 : totalWeightedSum / totalWeights;
});

final showPointGradesProvider = StateProvider.family<bool, String>((ref, subjectId) => false);

