class UserModel {
  String name;
  String email;
  bool isVerified;

  UserModel({
    required this.name,
    required this.email,
    required this.isVerified,
  });

  factory UserModel.fromMap(dynamic doc) {
    return UserModel(
      name: doc['name'],
      email: doc['email'],
      isVerified: doc['isVerified'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      'email': email,
      'isVerified': isVerified,
    };
  }
}
