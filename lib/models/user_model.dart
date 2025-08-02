class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String role;
  final String address;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      role: map['role'],
      address: map['address'],
    );
  }
}
