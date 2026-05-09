class Exam {
  final String id;
  final String subjectId;
  final String title;
  final DateTime date;
  final double weight;
  final double? maxPoints;

  Exam({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.date,
    required this.weight,
    this.maxPoints,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      subjectId: json['subject_id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      weight: (json['weight'] as num).toDouble(),
      maxPoints: json['max_points'] != null ? (json['max_points'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'title': title,
      'date': date.toIso8601String(),
      'weight': weight,
      'max_points': maxPoints,
    };
  }
}
