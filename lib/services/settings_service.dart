import "package:shared_preferences/shared_preferences.dart";

class SettingsService {
  static const _kProtectBank = "protectBank";
  static const _kLastCredit = "lastCredit";

  Future<bool> getProtectBank() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kProtectBank) ?? false;
  }

  Future<void> setProtectBank(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kProtectBank, value);
  }

  Future<int?> getLastCredit() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_kLastCredit);
  }

  Future<void> setLastCredit(int value) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kLastCredit, value);
  }
}
