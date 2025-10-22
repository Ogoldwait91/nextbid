import "package:flutter/foundation.dart";

class ProfileState extends ChangeNotifier {
  String name = "Your Name";
  String rank = "FO";
  String crewCode = "XXXX";
  String staffNo = "";

  int? seniority; // e.g., 1234
  int? cohortSize; // e.g., 5000

  void update({String? name, String? rank, String? crewCode, String? staffNo}) {
    if (name != null) this.name = name;
    if (rank != null) this.rank = rank;
    if (crewCode != null) this.crewCode = crewCode;
    if (staffNo != null) this.staffNo = staffNo;
    notifyListeners();
  }

  void setStatus({int? seniority, int? cohortSize}) {
    this.seniority = seniority;
    this.cohortSize = cohortSize;
    notifyListeners();
  }
}

final profileState = ProfileState();
