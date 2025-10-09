import "package:flutter/foundation.dart";

class ProfileState extends ChangeNotifier {
  String name = "Your Name";
  String rank = "FO";       // e.g., FO / Capt
  String crewCode = "XXXX"; // e.g., staff code

  void update({String? name, String? rank, String? crewCode}) {
    if (name != null) this.name = name;
    if (rank != null) this.rank = rank;
    if (crewCode != null) this.crewCode = crewCode;
    notifyListeners();
  }
}

final profileState = ProfileState();
