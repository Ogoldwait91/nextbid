import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String email;
  final String fleet;
  final String base;
  final String rank;

  final String? avatarUrl;
  final String? staffNo;
  final int? seniority;
  final double? credit;
  final int? leaveDays;

  const UserProfile({
    this.name = '',
    this.email = '',
    this.fleet = '',
    this.base = '',
    this.rank = '',
    this.avatarUrl,
    this.staffNo,
    this.seniority,
    this.credit,
    this.leaveDays,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'fleet': fleet,
        'base': base,
        'rank': rank,
        'avatarUrl': avatarUrl,
        'staffNo': staffNo,
        'seniority': seniority,
        'credit': credit,
        'leaveDays': leaveDays,
      };

  static UserProfile fromJson(Map<String, dynamic> m) => UserProfile(
        name: (m['name'] ?? '') as String,
        email: (m['email'] ?? '') as String,
        fleet: (m['fleet'] ?? '') as String,
        base: (m['base'] ?? '') as String,
        rank: (m['rank'] ?? '') as String,
        avatarUrl: m['avatarUrl'] as String?,
        staffNo: m['staffNo'] as String?,
        seniority: (m['seniority'] as num?)?.toInt(),
        credit: (m['credit'] as num?)?.toDouble(),
        leaveDays: (m['leaveDays'] as num?)?.toInt(),
      );
}

class ProfileStore {
  static const _k = 'user_profile_v1';

  static Future<void> save(UserProfile p) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_k, jsonEncode(p.toJson()));
  }

  static Future<UserProfile?> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_k);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserProfile.fromJson(map);
  }
}
