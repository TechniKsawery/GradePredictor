class Grade {
  final String id;
  final String subjectId;
  final double grade;
  final double weight;
  final String type;
  final DateTime date;

  Grade({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.weight,
    required this.type,
    required this.date,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      subjectId: json['subject_id'],
      grade: (json['grade'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      type: json['type'] ?? 'test',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'grade': grade,
      'weight': weight,
      'type': type,
      'date': date.toIso8601String(),
    };
  }
}
