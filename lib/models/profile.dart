class Profile {
  final String id;
  final String? displayName;
  final String? avatarUrl;

  Profile({
    required this.id,
    this.displayName,
    this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'display_name': displayName,
      'avatar_url': avatarUrl,
    };
  }
}
