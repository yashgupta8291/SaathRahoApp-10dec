class User {
  final String uid;
  final String name;
  final String email;
  final String picture;
  final String phone;
  final bool verified;

  User({
    required this.name,
    required this.uid,
    required this.email,
    required this.verified,
    required this.picture,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNo'] ?? '',
      picture: json['profilePic'] ?? '',
      verified: json['verified'] ?? false,
    );
  }
}
