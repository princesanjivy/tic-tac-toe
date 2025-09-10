class Preferences {
  final bool notifications;
  final bool isPrivate;

  Preferences({this.notifications = true, this.isPrivate = false});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notifications: json["notifications"] ?? true,
      isPrivate: json["is_private"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "notifications": notifications,
    "is_private": isPrivate,
  };
}

class Player {
  final String id;
  String name;
  String avatarUrl;
  final String? email;
  Preferences preferences;
  int streaks;
  int coins;
  int level;
  DateTime createdAt;

  Player({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.email,
    Preferences? preferences,
    this.streaks = 0,
    this.coins = 0,
    this.level = 1,
    DateTime? createdAt,
  }) : preferences = preferences ?? Preferences(),
       createdAt = createdAt ?? DateTime.now();

  /// Factory constructor to create from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["id"],
      name: json["name"] ?? "",
      avatarUrl: json["avatar_url"] ?? "",
      email: json["email"],
      preferences: json["preferences"] != null
          ? Preferences.fromJson(json["preferences"])
          : Preferences(),
      streaks: json["streaks"] ?? 0,
      coins: json["coins"] ?? 0,
      level: json["level"] ?? 1,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar_url": avatarUrl,
    "email": email,
    "preferences": preferences.toJson(),
    "streaks": streaks,
    "coins": coins,
    "level": level,
    "created_at": createdAt.toIso8601String(),
  };
}
