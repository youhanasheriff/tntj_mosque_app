import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/helpers/helpers.dart';
import 'package:tntj_mosque/screens/screens.dart';
import 'package:tntj_mosque/widgets/custom_dropdown.dart';
import '../../helpers/small_functions.dart';

class AddMosque extends StatefulWidget {
  static String routeName = "/add_mosque";
  const AddMosque({Key? key}) : super(key: key);

  @override
  State<AddMosque> createState() => _AddMosqueState();
}

class _AddMosqueState extends State<AddMosque> {
  final nameTextController = TextEditingController();
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();
  final branchController = TextEditingController();
  final List<String> imageUrl = List.generate(3, (index) => "");
  final Helpers _helpers = Helpers();
  final SmallFunc _smallFunc = SmallFunc();
  final List<String> list = ["--"];
  String selectedArea = "Select an area";
  XFile? pickedImage;
  bool isLoading = false;
  bool isLocationAccess = false;
  bool isLocationSelected = false;
  GeoPoint? location;
  Map<String, Object?>? oldData;

  Future<void> addMosque({
    required String name,
    required String branch,
    required String area,
    required String address,
    required String pinCode,
    required GeoPoint? location,
  }) async {
    int _temp = 0;
    for (var item in imageUrl) {
      if (item.trim().isEmpty) {
        _temp++;
      }
    }
    if (name.trim().isEmpty ||
        branch.trim().isEmpty ||
        (area == "--" || area == "Select an area") ||
        address.trim().isEmpty ||
        pinCode.trim().isEmpty ||
        _temp == 3 ||
        !isLocationSelected ||
        location == null) {
      _smallFunc.showSnackBar(
          "Fill all the fields to submit. Insha Allah", context);
    } else {
      setState(() {
        isLoading = true;
      });
      _helpers
          .uploadMosque(
        name: name,
        branch: branch,
        area: area,
        address: address,
        pinCode: pinCode,
        location: location,
      )
          .then((_) {
        setState(() {
          isLoading = false;
        });
        _smallFunc.showSnackBar(
            "Your mosque is submitted it will be reviewed and added to the database. Insha Allah",
            context);
        Navigator.pop(context);
      });
    }
  }

  showIt(String text) {
    _smallFunc.showSnackBar(text, context);
  }

  Future getLocation() async {
    Map<String, Object?>? data = {
      "name": nameTextController.text,
      "branch": branchController.text,
      "area": selectedArea,
      "address": addressController.text,
      "pinCode": pinCodeController.text,
      "location": location,
    };
    Navigator.pushReplacementNamed(
      context,
      LocationSelection.routeName,
      arguments: data,
    );
  }

  void chooseImage(int i) async {
    XFile? temp;
    void setPic() {
      if (temp != null) {
        setState(() {
          pickedImage = temp;
          imageUrl[i] = pickedImage!.path;
        });
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _selectImageSource(
                "Gallery",
                () async {
                  Navigator.pop(context);
                  temp = await _helpers.getImage(i, ImageSource.gallery);
                  setPic();
                },
                icon: Icons.photo,
              ),
              _selectImageSource(
                "Camera",
                () async {
                  Navigator.pop(context);
                  temp = await _helpers.getImage(i, ImageSource.camera);
                  setPic();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _selectImageSource(String text, Function() action,
      {IconData icon = Icons.camera_alt_outlined}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        IconButton(
          iconSize: 56,
          onPressed: action,
          icon: Icon(icon),
        ),
        Text(text),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    oldData =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>?;
    if (oldData != null) {
      if (oldData!['name'] != null) {
        nameTextController.text = oldData!['name'] as String;
      }
      if (oldData!['branch'] != null) {
        branchController.text = oldData!['branch'] as String;
      }
      if (oldData!['area'] != null) {
        selectedArea = oldData!['area'] as String;
      }
      if (oldData!['address'] != null) {
        addressController.text = oldData!['address'] as String;
      }
      if (oldData!['pinCode'] != null) {
        pinCodeController.text = oldData!['pinCode'] as String;
      }
      if (oldData!['location'] != null) {
        location = oldData!['location'] as GeoPoint;
        isLocationSelected = true;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Mosque"),
        centerTitle: false,
        backgroundColor: themeBlue,
        actions: [
          IconButton(
            onPressed: () {
              addMosque(
                name: nameTextController.text,
                branch: branchController.text,
                area: selectedArea,
                address: addressController.text,
                pinCode: pinCodeController.text,
                location: location,
              );
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nameTextController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          label: Text("Mosque Name"),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: branchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          label: Text("Branch Name"),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List<String>>(
                          future: Helpers().getAreas(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error occured...."));
                            } else {
                              var docs = snapshot.data!;

                              return CustomDropDown<String>(
                                lists: docs,
                                isTitle: false,
                                selectedArea: selectedArea,
                                searchText: "Search",
                                onChange: (value) {
                                  setState(() {
                                    selectedArea = value!;
                                  });
                                },
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          label: Text("Full Address "),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: pinCodeController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          label: Text("Pin Code : "),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isLocationSelected
                                ? "Location Selected"
                                : "Location",
                            style: TextStyle(
                              color: isLocationSelected
                                  ? themeBlue
                                  : Colors.grey[700],
                              fontSize: 17,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: isLocationAccess ? null : getLocation,
                            style: ButtonStyle(
                              foregroundColor:
                                  isLocationAccess ? null : getStyle(themeBlue),
                            ),
                            icon: const Icon(Icons.add_location_alt_outlined),
                            label: const Text("Select location"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < imageUrl.length; i++)
                          imageSelection(
                            imageUrl[i],
                            () => chooseImage(i),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget imageSelection(String imageUrl, Function() onPress) {
    bool isEmpty = imageUrl.trim() == "";

    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: themeBlue.withOpacity(0.3),
          image: isEmpty
              ? null
              : DecorationImage(
                  image: FileImage(
                    File(imageUrl),
                  ),
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
        ),
        alignment: Alignment.center,
        child: isEmpty
            ? const Padding(
                padding: EdgeInsets.only(right: 5.0, bottom: 5.0),
                child: Icon(
                  Icons.add_a_photo_rounded,
                  size: 35,
                  color: themeBlue,
                ),
              )
            : null,
      ),
    );
  }
}
