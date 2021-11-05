import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tntj_mosque/auth/auth.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/screens/screens.dart';

import './Components/body_area.dart';

class HomePage extends StatelessWidget {
  static String routeName = "/home";
  HomePage({
    Key? key,
  }) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");
  final AuthHelper _authHelper = AuthHelper();
  final emptyWidget = const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      floatingActionButton: user!.isAnonymous
          ? null
          : StreamBuilder<QuerySnapshot>(
              stream: userRef
                  .where(
                    "id",
                    isEqualTo: user!.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return emptyWidget;
                } else {
                  return snapshot.data!.docs[0]['is_verified']
                      ? FloatingActionButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AddMosque.routeName),
                          child: const Icon(Icons.add),
                          backgroundColor: themeBlue,
                        )
                      : emptyWidget;
                }
              }),
      body: const HomeBody(),
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
