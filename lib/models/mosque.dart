import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tntj_mosque/models/models.dart';

class Mosque {
  final String name;
  final String id;
  final List images;
  final String address;
  final String branch;
  final String area;
  final UserDetails userDetails;
  final String pinNo;
  final Location location;

  Mosque({
    required this.name,
    required this.id,
    required this.images,
    required this.address,
    required this.userDetails,
    required this.branch,
    required this.area,
    required this.pinNo,
    required this.location,
  });

  factory Mosque.fromData(QueryDocumentSnapshot doc) => Mosque(
        id: doc.id,
        name: doc['name'],
        images: doc['images'],
        address: doc['address'],
        branch: doc['branch'],
        area: doc['area'],
        pinNo: doc['pin_no'],
        location: Location(
          lat: doc['location'].latitude,
          long: doc['location'].longitude,
        ),
        userDetails: UserDetails(
          displayName: doc['uploaded_by']['display_name'],
          email: doc['uploaded_by']['email'],
          uid: doc['uploaded_by']['id'],
        ),
      );
}
