import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/helpers/helpers.dart';
import 'package:tntj_mosque/models/mosque.dart';
import 'package:tntj_mosque/widgets/widget.dart';

class SearchPage extends StatefulWidget {
  static String routeName = "/search";
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedArea = "--";

  void onChange(value) {
    setState(() {
      selectedArea = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: false,
        backgroundColor: themeBlue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10.0,
        ),
        width: double.infinity,
        child: FutureBuilder<List<String>>(
          future: Helpers().getAreas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error occured...."));
            } else {
              var docs = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomDropDown<String>(
                    searchText: "Search",
                    title: "Search an area",
                    lists: docs,
                    selectedArea: selectedArea,
                    onChange: onChange,
                  ),
                  if (selectedArea == "--")
                    const Center(
                      child: Text(
                        "Select an area to Search",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  if (selectedArea != "--")
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("mosques")
                          .where(
                            "area",
                            isEqualTo: selectedArea,
                          )
                          .where(
                            "is_verified",
                            isEqualTo: true,
                          )
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("Error occured...."));
                        } else {
                          var mosques = snapshot.data!.docs;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: mosques.length,
                              itemBuilder: (context, index) {
                                Mosque mosque = Mosque.fromData(mosques[index]);
                                return MosqueCard(
                                  mosque: mosque,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
