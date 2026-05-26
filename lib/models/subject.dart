class Subject {
  static const String gradingModeGrades = 'grades';
  static const String gradingModePoints = 'points';
  static const String gradingModeMixed = 'mixed';

  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final double? maxNormalPoints;
  final double? maxBonusPoints;
  final String gradingMode;
  final Map<String, double>? customGradingScale;

  Subject({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.maxNormalPoints,
    this.maxBonusPoints,
    this.gradingMode = gradingModeMixed,
    this.customGradingScale,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    Map<String, double>? scale;
    if (json['custom_grading_scale'] != null) {
      scale = (json['custom_grading_scale'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value is String ? (double.tryParse(value) ?? 0.0) : (value as num?)?.toDouble() ?? 0.0),
      );
    }

    return Subject(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      maxNormalPoints: json['max_normal_points'] != null ? (json['max_normal_points'] is String ? double.tryParse(json['max_normal_points']) : (json['max_normal_points'] as num?)?.toDouble()) : null,
      maxBonusPoints: json['max_bonus_points'] != null ? (json['max_bonus_points'] is String ? double.tryParse(json['max_bonus_points']) : (json['max_bonus_points'] as num?)?.toDouble()) : null,
      gradingMode: json['grading_mode'] ?? gradingModeMixed,
      customGradingScale: scale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'max_normal_points': maxNormalPoints,
      'max_bonus_points': maxBonusPoints,
      'grading_mode': gradingMode,
      'custom_grading_scale': customGradingScale,
    };
  }
}
