class Grade {
  final String id;
  final String subjectId;
  final double grade;
  final double weight;
  final String type;
  final DateTime date;
  final double? points;
  final double? maxPoints;

  Grade({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.weight,
    required this.type,
    required this.date,
    this.points,
    this.maxPoints,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      subjectId: json['subject_id'],
      grade: (json['grade'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      type: json['type'] ?? 'test',
      date: DateTime.parse(json['date']),
      points: json['points'] != null ? (json['points'] as num).toDouble() : null,
      maxPoints: json['max_points'] != null ? (json['max_points'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'grade': grade,
      'weight': weight,
      'type': type,
      'date': date.toIso8601String(),
      'points': points,
      'max_points': maxPoints,
    };
  }
}
