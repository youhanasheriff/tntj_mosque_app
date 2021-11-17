import 'package:flutter/material.dart';
import '../screens/screens.dart';

final Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => HomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  AddMosque.routeName: (context) => const AddMosque(),
  SearchPage.routeName: (context) => const SearchPage(),
  MosquePage.routeName: (context) => const MosquePage(),
  AboutPage.routeName: (context) => const AboutPage(),
  VerificationForm.routeName: (context) => const VerificationForm(),
  ImageView.routeName: (context) => const ImageView(),
  LocationSelection.routeName: (context) => const LocationSelection(),
};
