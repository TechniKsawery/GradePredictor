class Subject {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final double? maxNormalPoints;
  final double? maxBonusPoints;

  Subject({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.maxNormalPoints,
    this.maxBonusPoints,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      maxNormalPoints: json['max_normal_points'] != null ? (json['max_normal_points'] as num).toDouble() : null,
      maxBonusPoints: json['max_bonus_points'] != null ? (json['max_bonus_points'] as num).toDouble() : null,
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
    };
  }
}
