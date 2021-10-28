import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/helpers/helpers.dart';
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

  final List<String> list = ["--"];

  String selectedArea = "Select an area";

  XFile? pickedImage;

  bool isLoading = false;

  bool isLocationSelected = false;

  Future<void> addMosque({
    required String name,
    required String branch,
    required String area,
    required String address,
    required String pinCode,
  }) async {
    int _temp = 0;
    for (var item in imageUrl) {
      if (item.trim().isEmpty) {
        _temp++;
      }
    }
    if (name.trim().isEmpty ||
        branch.trim().isEmpty ||
        (area.trim().isEmpty || area == "Select an area") ||
        address.trim().isEmpty ||
        pinCode.trim().isEmpty ||
        _temp == 3 ||
        !isLocationSelected) {
      showSnackBar("Fill all the fields to submit. Insha Allah", context);
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
      )
          .then((_) {
        setState(() {
          isLoading = false;
        });

        Navigator.pop(context);
      });
    }
  }

  showIt(String text) {
    showSnackBar(text, context);
  }

  Future getLocation() async {
    bool temp = await _helpers.getLocation(showSnack: showIt);
    setState(() {
      isLocationSelected = temp;
    });
  }

  Future selectImage(int i) async {
    var temp = await _helpers.getImage(i, ImageSource.camera);
    setState(() {
      pickedImage = temp;
      imageUrl[i] = pickedImage!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildInputText("Mosque Name", nameTextController),
                    _buildInputText("Branch Name", branchController),
                    _buildSelectArea(),
                    _buildInputText("Full Address", addressController),
                    _buildInputText("Pin Code :", pinCodeController),
                    _buildSelectLocation(),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < imageUrl.length; i++)
                          imageSelection(
                            imageUrl[i],
                            () => selectImage(i),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Padding _buildSelectLocation() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isLocationSelected ? "Location Selected" : "Location",
            style: TextStyle(
              color: isLocationSelected ? themeBlue : Colors.grey[700],
              fontSize: 17,
            ),
          ),
          TextButton.icon(
            onPressed: getLocation,
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(themeBlue)),
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text("Select location"),
          ),
        ],
      ),
    );
  }

  Padding _buildSelectArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<String>>(
          future: Helpers().getAreas(list),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error occured...."));
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
    );
  }

  Padding _buildInputText(String text, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(text),
        ),
        textInputAction: TextInputAction.next,
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