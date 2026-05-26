import '../models/grade.dart';
import '../models/subject.dart';
import '../providers/settings_provider.dart';

class GradeConverter {
  static bool isPercentageGrade(Grade grade) {
    if (grade.points != null) return false; // has points -> is points grade, not percent
    final t = grade.type.toLowerCase();
    return t.contains('procent') || t.contains('percent') || t.contains('%');
  }

  static double percentToGrade(double percent, Subject subject, GradingScale globalScale) {
    final custom = subject.customGradingScale;
    if (custom != null) {
      if (percent >= (custom['grade6'] ?? globalScale.grade6)) return 6.0;
      if (percent >= (custom['grade5'] ?? globalScale.grade5)) return 5.0;
      if (percent >= (custom['grade4'] ?? globalScale.grade4)) return 4.0;
      if (percent >= (custom['grade3'] ?? globalScale.grade3)) return 3.0;
      if (percent >= (custom['grade2'] ?? globalScale.grade2)) return 2.0;
    } else {
      if (percent >= globalScale.grade6) return 6.0;
      if (percent >= globalScale.grade5) return 5.0;
      if (percent >= globalScale.grade4) return 4.0;
      if (percent >= globalScale.grade3) return 3.0;
      if (percent >= globalScale.grade2) return 2.0;
    }
    return 1.0;
  }

  static double pointsToGrade(double points, double max, Subject subject, GradingScale globalScale) {
    if (max <= 0) return 1.0;
    final percent = (points / max) * 100;
    return percentToGrade(percent, subject, globalScale);
  }
}
