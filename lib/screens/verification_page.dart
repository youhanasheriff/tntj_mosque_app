import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tntj_mosque/auth/auth.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/helpers/small_functions.dart';
import 'package:tntj_mosque/models/user.dart' as user_model;
import 'package:tntj_mosque/screens/home/home_page.dart';

class VerificationForm extends StatelessWidget {
  static String routeName = "/verification";

  VerificationForm({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final branchController = TextEditingController();
  final areaController = TextEditingController();
  final mailController = TextEditingController();
  final mobileController = TextEditingController();
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("users");

  _onSubmit(BuildContext context) async {
    await AuthHelper().loginWithGoogle();
    final User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> userData = user_model.userToJson(user_model.User(
      id: user!.uid,
      name: nameController.text,
      branch: branchController.text,
      area: areaController.text,
      email: user.email,
      mobile: int.parse(mobileController.text),
      isVerified: false,
    ));
    collectionRef.doc(user.uid).set(userData);
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        title: const Text("Verify Account"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Fill this form to verify your account.",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 8,
                  thickness: 1,
                ),
                _buildInputText("Full Name", nameController),
                _buildInputText("Branch Name", branchController),
                _buildInputText("Area Name", areaController),
                _buildInputText(
                  "Mobile No.",
                  mobileController,
                  inputType: TextInputType.phone,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "* We will call you for your accout verification",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                _buildButtons(
                  "Submit",
                  () => _onSubmit(context),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildInputText(String text, TextEditingController controller,
      {TextInputType inputType = TextInputType.name}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixText: inputType == TextInputType.phone ? "+91 " : null,
          label: Text(text),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Center _buildButtons(
    String title,
    Function() action,
  ) {
    return Center(
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          padding: getStyle(
            const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
          ),
          shape: getStyle(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55 / 2),
            ),
          ),
          backgroundColor: getStyle(
            themeBlue,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
