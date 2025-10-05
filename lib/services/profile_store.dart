import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileStore {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  static const _key = 'user_profile_v1';
  final ValueNotifier<UserProfile> notifier =
      ValueNotifier(UserProfile.defaults());

  UserProfile get current => notifier.value;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s != null && s.isNotEmpty) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        notifier.value = UserProfile.fromJson(m);
      } catch (_) {
        // keep defaults on parse error
      }
    }
  }

  Future<void> save(UserProfile p) async {
    notifier.value = p;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(p.toJson()));
  }
}
