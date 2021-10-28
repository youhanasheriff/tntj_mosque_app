import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tntj_mosque/models/mosque.dart';

import '../../../widgets/card.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("mosques").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error occured...."));
          } else {
            var docs = snapshot.data!.docs;
            return snapshot.data!.docs.isEmpty
                ? Center(
                    child: Text(
                      "No data available...",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: user!.isAnonymous
                        ? snapshot.data!.docs.length + 1
                        : snapshot.data!.docs.length + 0,
                    itemBuilder: (context, index) {
                      if (user!.isAnonymous &&
                          snapshot.data!.docs.length == index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Login with google to add a mosque",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else {
                        Mosque mosque = Mosque.fromData(docs[index]);
                        return MosqueCard(
                          mosque: mosque,
                        );
                      }
                    },
                  );
          }
        },
      ),
    );
  }
}
