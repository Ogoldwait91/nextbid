class UserProfile {
  final String name;
  final String rank;
  final String fleet;
  final String base;
  final int seniority;
  final String? staffNo;
  final String? avatarUrl;
  final double? credit;
  final int? leaveDays;

  const UserProfile({
    required this.name,
    required this.rank,
    required this.fleet,
    required this.base,
    required this.seniority,
    this.staffNo,
    this.avatarUrl,
    this.credit,
    this.leaveDays,
  });

  factory UserProfile.defaults() => const UserProfile(
        name: 'Oliver "Oli" Goldwait',
        rank: 'Senior First Officer',
        fleet: 'B777',
        base: 'LHR',
        seniority: 231,
        staffNo: 'BA123456',
        credit: 54.7,
        leaveDays: 18,
        avatarUrl: null,
      );

  UserProfile copyWith({
    String? name,
    String? rank,
    String? fleet,
    String? base,
    int? seniority,
    String? staffNo,
    String? avatarUrl,
    double? credit,
    int? leaveDays,
  }) {
    return UserProfile(
      name: name ?? this.name,
      rank: rank ?? this.rank,
      fleet: fleet ?? this.fleet,
      base: base ?? this.base,
      seniority: seniority ?? this.seniority,
      staffNo: staffNo ?? this.staffNo,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      credit: credit ?? this.credit,
      leaveDays: leaveDays ?? this.leaveDays,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'rank': rank,
        'fleet': fleet,
        'base': base,
        'seniority': seniority,
        'staffNo': staffNo,
        'avatarUrl': avatarUrl,
        'credit': credit,
        'leaveDays': leaveDays,
      };

  factory UserProfile.fromJson(Map<String, dynamic> m) {
    double? asDouble(dynamic v) => v == null
        ? null
        : (v is num ? v.toDouble() : double.tryParse(v.toString()));
    int asInt(dynamic v) => v is int ? v : int.tryParse(v.toString()) ?? 0;

    return UserProfile(
      name: (m['name'] ?? '') as String,
      rank: (m['rank'] ?? '') as String,
      fleet: (m['fleet'] ?? '') as String,
      base: (m['base'] ?? '') as String,
      seniority: asInt(m['seniority']),
      staffNo: m['staffNo'] as String?,
      avatarUrl: m['avatarUrl'] as String?,
      credit: asDouble(m['credit']),
      leaveDays: (m['leaveDays'] == null) ? null : asInt(m['leaveDays']),
    );
  }
}
