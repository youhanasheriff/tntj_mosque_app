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

class Location {
  final double lat;
  final double long;

  Location({
    required this.lat,
    required this.long,
  });
}
