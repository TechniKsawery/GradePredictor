class Grade {
  final String id;
  final String subjectId;
  final double grade;
  final double weight;
  final String type;
  final int semester;
  final DateTime date;
  final double? points;
  final double? maxPoints;
  final String? rawText;

  Grade({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.weight,
    required this.type,
    this.semester = 1,
    required this.date,
    this.points,
    this.maxPoints,
    this.rawText,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    final rawType = (json['type'] ?? 'test').toString();
    final parts = rawType.split('|');
    final actualType = parts[0];
    final semester = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
    final rawText = parts.length > 2 ? parts[2] : null;

    return Grade(
      id: json['id'],
      subjectId: json['subject_id'],
      grade: json['grade'] is String ? double.tryParse(json['grade']) ?? 0.0 : (json['grade'] as num?)?.toDouble() ?? 0.0,
      weight: json['weight'] is String ? double.tryParse(json['weight']) ?? 1.0 : (json['weight'] as num?)?.toDouble() ?? 1.0,
      type: actualType,
      semester: semester,
      date: DateTime.parse(json['date']),
      points: json['points'] != null ? (json['points'] is String ? double.tryParse(json['points']) : (json['points'] as num?)?.toDouble()) : null,
      maxPoints: json['max_points'] != null ? (json['max_points'] is String ? double.tryParse(json['max_points']) : (json['max_points'] as num?)?.toDouble()) : null,
      rawText: rawText,
    );
  }

  Map<String, dynamic> toJson() {
    final suffix = rawText != null ? '|$rawText' : '';
    return {
      'subject_id': subjectId,
      'grade': grade,
      'weight': weight,
      'type': '$type|$semester$suffix',
      'date': date.toIso8601String(),
      'points': points,
      'max_points': maxPoints,
    };
  }
}
