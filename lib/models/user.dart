import 'package:tntj_mosque/models/models.dart';

class User {
  final String id;
  final String name;
  final String branch;
  final String area;
  final UserDetails userDetails;
  final int mobile;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.branch,
    required this.area,
    required this.userDetails,
    required this.mobile,
    required this.isVerified,
  });

  factory User.fromData(doc) => User(
        id: doc['id'],
        name: doc['user_name'],
        branch: doc['branch'],
        area: doc['area'],
        userDetails: UserDetails(
          displayName: doc['user_details']['display_name'],
          email: doc['user_details']['email'],
          uid: doc['user_details']['id'],
        ),
        mobile: doc['mobile'],
        isVerified: doc['is_verified'],
      );
}

Map<String, dynamic> userToJson(User userData) {
  return {
    "id": userData.id,
    "user_name": userData.name,
    "branch": userData.branch,
    "area": userData.area,
    "user_details": {
      "display_name": userData.userDetails.displayName,
      "id": userData.userDetails.uid,
      "email": userData.userDetails.email
    },
    "mobile": userData.mobile,
    "is_verified": userData.isVerified,
  };
}
