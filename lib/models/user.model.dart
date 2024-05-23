class User {
  final String id;
  final String email;
  final String? fullName;
  final String? profileImageUrl;
  final bool banned;
  final String? banReason;

  User({
    required this.id,
    required this.email,
    this.fullName,
    this.profileImageUrl,
    required this.banned,
    this.banReason,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      profileImageUrl: json['profileImageUrl'],
      banned: json['banned'],
      banReason: json['banReason'],
    );
  }
}
