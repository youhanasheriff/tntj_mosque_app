import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Helpers {
  final ImagePicker _picker = ImagePicker();
  final Location location = Location();
  late LocationData _locationData;

  final List<XFile?> images = [];
  String locationLink = "";

  Future<List<String>> getAreas(List<String> list) async {
    List<String> _temp = list;
    var snapshot = await FirebaseFirestore.instance.collection("areas").get();
    var docs = snapshot.docs;
    for (var i = 0; i < docs.length; i++) {
      _temp.add(docs[i]["name"]);
    }
    return Future.value(_temp);
  }

  Future<XFile?> getImage(int index, ImageSource source) async {
    XFile? pickedImage = await _picker.pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 512,
    );
    if (pickedImage != null) images.add(pickedImage);
    return pickedImage;
  }

  Future<bool> getLocation({showSnack}) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        showSnack("Grant location permision and try again");
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showSnack("Grant location permision and try again");
        return false;
      }
    }
    location.changeSettings(accuracy: LocationAccuracy.high);
    _locationData = await location.getLocation();

    return true;
  }

  Future uploadMosque({
    required String name,
    required String branch,
    required String area,
    required String address,
    required String pinCode,
  }) async {
    final _storage = FirebaseStorage.instance.ref("/mosques");

    final docRef = await FirebaseFirestore.instance.collection("mosques").add({
      "name": name,
      "branch": branch,
      "area": area,
      "address": address,
      "pin_no": pinCode,
      "images": [
        "https://library.kissclipart.com/20180901/xfw/kissclipart-masjid-icon-clipart-sheikh-zayed-mosque-clip-art-072931d5de56f448.png"
      ],
      "location": {
        "lat": _locationData.latitude.toString(),
        "long": _locationData.longitude.toString(),
      },
    });

    List<File> _image = [];

    for (var i = 0; i < images.length; i++) {
      _image.add(File(images[i]!.path));
    }
    List<String> imageLinks = [];
    for (var i = 0; i < _image.length; i++) {
      String imagePath = "${docRef.id}/${DateTime.now()}.jpg";

      final _uploadTask = await _storage.child(imagePath).putFile(_image[i]);

      if (_uploadTask.state == TaskState.success) {
        var downUrl = await _uploadTask.ref.getDownloadURL();
        imageLinks.add(downUrl);
      }
    }
    await docRef.update({
      "images": imageLinks,
    });
  }
}
