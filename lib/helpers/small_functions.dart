import 'package:flutter/material.dart';

class SmallFunc {
  void showSnackBar(String text, BuildContext context) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

MaterialStateProperty<T> getStyle<T>(T value) {
  return MaterialStateProperty.all(value);
}
