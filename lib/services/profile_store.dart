import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String email;
  final String fleet;
  final String base;
  final String rank;
  final String avatarUrl;

  const UserProfile({
    this.name = '',
    this.email = '',
    this.fleet = '',
    this.base = '',
    this.rank = '',
    this.avatarUrl = '',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? fleet,
    String? base,
    String? rank,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      fleet: fleet ?? this.fleet,
      base: base ?? this.base,
      rank: rank ?? this.rank,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'fleet': fleet,
        'base': base,
        'rank': rank,
        'avatarUrl': avatarUrl,
      };

  static UserProfile fromJson(Map<String, dynamic> j) => UserProfile(
        name: (j['name'] ?? '') as String,
        email: (j['email'] ?? '') as String,
        fleet: (j['fleet'] ?? '') as String,
        base: (j['base'] ?? '') as String,
        rank: (j['rank'] ?? '') as String,
        avatarUrl: (j['avatarUrl'] ?? '') as String,
      );
}

class ProfileStore {
  static const _kKey = 'user_profile_v1';

  static Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return const UserProfile();
    try {
      return UserProfile.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserProfile();
    }
  }

  static Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, json.encode(profile.toJson()));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kKey);
  }
}
