import 'package:cloud_firestore/cloud_firestore.dart';

class Mosque {
  final String name;
  final String id;
  final List images;
  final String address;
  final String branch;
  final String area;
  final String pinNo;
  final Location location;

  Mosque({
    required this.name,
    required this.id,
    required this.images,
    required this.address,
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
          lat: doc['location']['lat'],
          long: doc['location']['long'],
        ),
      );
}

class Location {
  final String lat;
  final String long;

  Location({
    required this.lat,
    required this.long,
  });
}
