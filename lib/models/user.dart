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
        name: doc['name'] ?? "",
        branch: doc['branch'],
        area: doc['area'],
        userDetails: UserDetails(displayName: doc['name'], email: '', uid: ''),
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
    "user_details": {
      "name": userData.userDetails.displayName,
      "id": userData.userDetails.uid,
      "email": userData.userDetails.email
    },
    "mobile": userData.mobile,
    "is_verified": userData.isVerified,
  };
}

class UserDetails {
  final String displayName;
  final String uid;
  final String email;

  UserDetails({
    required this.displayName,
    required this.uid,
    required this.email,
  });
}
