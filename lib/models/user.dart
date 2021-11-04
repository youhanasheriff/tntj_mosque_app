import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String branch;
  final String area;
  final String? email;
  final int mobile;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.branch,
    required this.area,
    this.email,
    required this.mobile,
    required this.isVerified,
  });

  factory User.fromData(doc) => User(
        id: doc['id'],
        name: doc['name'] ?? "",
        branch: doc['branch'],
        area: doc['area'],
        email: doc['email'],
        mobile: doc['mobile'],
        isVerified: doc['is_verified'],
      );
}

Map<String, dynamic> userToJson(User userData) {
  return {
    "id": userData.id,
    "userName": userData.name,
    "branch": userData.branch,
    "area": userData.area,
    "email": userData.email,
    "mobile": userData.mobile,
    "is_verified": userData.isVerified,
  };
}
