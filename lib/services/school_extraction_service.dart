import '../models/grade.dart';
import '../models/subject.dart';

class ExtractedData {
  final double? points;
  final double? maxPoints;
  final String type;
  final double weight;

  ExtractedData({
    this.points,
    this.maxPoints,
    required this.type,
    this.weight = 1.0,
  });
}

class SchoolExtractionService {
  /// Parses description and category to extract structured grade data.
  static ExtractedData extract(String description, String category) {
    final text = (description + " " + category).toLowerCase();
    
    double? points;
    double? maxPoints;
    double weight = 1.0;
    String type = 'test';

    // 1. Extract points like "15/20" or "15 / 20"
    final pointsRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*\/\s*(\d+(?:[.,]\d+)?)');
    final pointsMatch = pointsRegex.firstMatch(text);
    if (pointsMatch != null) {
      points = double.tryParse(pointsMatch.group(1)!.replaceAll(',', '.'));
      maxPoints = double.tryParse(pointsMatch.group(2)!.replaceAll(',', '.'));
    }

    // 2. Extract max points like "max 30 pkt" or "na 30 pkt"
    if (maxPoints == null) {
      final maxRegex = RegExp(r'(?:max|na|z)\s*(\d+(?:[.,]\d+)?)\s*pkt');
      final maxMatch = maxRegex.firstMatch(text);
      if (maxMatch != null) {
        maxPoints = double.tryParse(maxMatch.group(1)!.replaceAll(',', '.'));
      }
    }

    // 3. Extract points if only one number with "pkt" exists
    if (points == null) {
      final soloPointsRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*pkt');
      final soloMatch = soloPointsRegex.firstMatch(text);
      if (soloMatch != null) {
        points = double.tryParse(soloMatch.group(1)!.replaceAll(',', '.'));
      }
    }

    // 4. Determine type based on keywords
    if (text.contains('test') || text.contains('sprawdzian') || text.contains('spr') || text.contains('klasówka')) {
      type = 'test';
      weight = 3.0; // Typical default for exams
    } else if (text.contains('kartkówka') || text.contains('kart') || text.contains('odpowiedź') || text.contains('odp')) {
      type = 'quiz';
      weight = 2.0;
    } else if (text.contains('domowa') || text.contains('zadanie') || text.contains('projekt')) {
      type = 'homework';
      weight = 1.0;
    } else if (text.contains('aktywność') || text.contains('plus') || text.contains('minus')) {
      type = 'activity';
      weight = 0.5;
    } else if (text.contains('dodatkowe') || text.contains('bonus')) {
      type = 'bonus';
      weight = 1.0;
    }

    // 5. Try to find explicit weight like "waga: 5" or "w=3"
    final weightRegex = RegExp(r'(?:waga|w)\s*[:=]?\s*(\d+(?:[.,]\d+)?)');
    final weightMatch = weightRegex.firstMatch(text);
    if (weightMatch != null) {
      weight = double.tryParse(weightMatch.group(1)!.replaceAll(',', '.')) ?? weight;
    }

    return ExtractedData(
      points: points,
      maxPoints: maxPoints,
      type: type,
      weight: weight,
    );
  }
}
