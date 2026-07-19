import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 1)
class Profile extends HiveObject {
  @HiveField(0)
  String name;

  // Renamed to avatarUrl to match the generated code
  @HiveField(1)
  String? avatarUrl;

  @HiveField(2)
  int totalXp;

  @HiveField(3)
  int level;

  @HiveField(4)
  String moodEmoji;

  @HiveField(5)
  String moodLabel;

  @HiveField(6)
  String? bio;

  @HiveField(7)
  DateTime joinedAt;

  Profile({
    required this.name,
    this.avatarUrl,
    this.totalXp = 0,
    this.level = 1,
    this.moodEmoji = '😊',
    this.moodLabel = 'Happy',
    this.bio,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  // Add your cute avatar paths here
  static const List<String> cuteAvatars = [
    'assets/avatars/cute1.png',
    'assets/avatars/cute2.png',
    'assets/avatars/cute3.png',
    'assets/avatars/cute4.png',
    'assets/avatars/cute5.png',
    'assets/avatars/cute6.png',
    'assets/avatars/cute7.png',
    'assets/avatars/cute8.png',
    'assets/avatars/cute9.png',
    'assets/avatars/cute10.png',
  ];

  Profile copyWith({
    String? name,
    String? avatarUrl,
    int? totalXp,
    int? level,
    String? moodEmoji,
    String? moodLabel,
    String? bio,
    DateTime? joinedAt,
  }) {
    return Profile(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      moodLabel: moodLabel ?? this.moodLabel,
      bio: bio ?? this.bio,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}