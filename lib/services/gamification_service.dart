import 'package:hive/hive.dart';
import 'profile_service.dart';

class GamificationService {
  static Box get _box => Hive.box('gamification');

  static Future<Map<String, dynamic>> completeTask(int xpReward) async {
    final currentXp = _box.get('totalXp', defaultValue: 0) as int;
    final newXp = currentXp + xpReward;
    await _box.put('totalXp', newXp);

    final oldLevel = _calculateLevel(currentXp);
    final newLevel = _calculateLevel(newXp);

    await ProfileService.updateXp(xpReward);

    return {
      'leveledUp': newLevel > oldLevel,
      'newLevel': newLevel,
      'totalXp': newXp,
    };
  }

  static int getCurrentXp() => _box.get('totalXp', defaultValue: 0) as int;

  static int getCurrentLevel() => _calculateLevel(getCurrentXp());

  static int getXpForNextLevel() {
    final level = getCurrentLevel();
    return level * 100;
  }

  static int getXpProgress() {
    final totalXp = getCurrentXp();
    final level = _calculateLevel(totalXp);
    return totalXp - ((level - 1) * 100);
  }

  static int _calculateLevel(int xp) => (xp / 100).floor() + 1;
}
