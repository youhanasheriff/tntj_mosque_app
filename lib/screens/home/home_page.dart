import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tntj_mosque/auth/auth.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/models/user.dart' as userModel;
import 'package:tntj_mosque/screens/screens.dart';

import './Components/body_area.dart';

class HomePage extends StatelessWidget {
  static String routeName = "/home";
  HomePage({
    Key? key,
  }) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;
  final AuthHelper _authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("users").doc(user!.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error occured...."));
        } else {
          final userModel.User? _user = user!.isAnonymous
              ? null
              : userModel.User.fromData(snapshot.data!.data());

          return Scaffold(
            appBar: buildAppbar(context),
            floatingActionButton: (user!.isAnonymous ||
                    (_user == null ? true : !_user.isVerified))
                ? null
                : FloatingActionButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AddMosque.routeName),
                    child: const Icon(Icons.add),
                    backgroundColor: themeBlue,
                  ),
            body: const HomeBody(),
          );
        }
      },
    );
  }

  AppBar buildAppbar(context) {
    return AppBar(
      backgroundColor: themeBlue,
      title: const Text("List of Mosques"),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchPage.routeName);
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: _authHelper.signOut,
          icon: const Icon(
            Icons.logout_rounded,
          ),
        ),
        const SizedBox(width: 5.0)
      ],
    );
  }
}