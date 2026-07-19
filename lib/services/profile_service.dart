import 'package:hive/hive.dart';
import '../models/profile.dart';

class ProfileService {
  static Box<Profile> get _box => Hive.box<Profile>('profile');

  static bool hasProfile() => _box.isNotEmpty;

  static Profile? getProfile() => _box.isNotEmpty ? _box.getAt(0) : null;

  static Future<void> saveProfile(Profile profile) async {
    if (_box.isNotEmpty) {
      await _box.putAt(0, profile);
    } else {
      await _box.add(profile);
    }
  }

  static Future<void> updateXp(int xp) async {
    final profile = getProfile();
    if (profile != null) {
      profile.totalXp += xp;
      profile.level = _calculateLevel(profile.totalXp);
      await profile.save();
    }
  }

  static int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }

  static Future<void> saveMood({required String emoji, required String label}) async {
    final profile = getProfile();
    if (profile != null) {
      profile.moodEmoji = emoji;
      profile.moodLabel = label;
      await profile.save();
    }
  }
}