import 'package:flutter/material.dart';
import 'package:tntj_mosque/auth/auth.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/screens/screens.dart';

class LoginPage extends StatelessWidget {
  static String routeName = "/login";

  LoginPage({
    Key? key,
  }) : super(key: key);

  final AuthHelper _authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          const Text(
            "السَّلَامُ عَلَيْكُمْ‎", // "TNTJ Mosque",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Assalamu Alaikum", // "TNTJ Mosque",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 50),
          buildButtons(
            "Sign in Anonymously",
            _authHelper.loginAnnonymosly,
          ),
          const SizedBox(height: 15),
          buildButtons(
            "Sign in with google",
            _authHelper.loginWithGoogle,
            isGoogle: true,
          ),
          const Spacer(flex: 2),
          const Text(
            "TNTJ Mosque",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: getStyle<Color>(themeLightBlue),
                  elevation: getStyle(2),
                  shape: getStyle(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AboutPage.routeName);
                },
                child: Text(
                  "About",
                  style: bodyTextStyle.copyWith(color: Colors.black87),
                ),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Center buildButtons(String title, Function() action,
      {bool isGoogle = false}) {
    return Center(
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          padding: getStyle(
            EdgeInsets.symmetric(horizontal: isGoogle ? 25 : 35, vertical: 10),
          ),
          shape: getStyle(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          backgroundColor: getStyle(
            Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isGoogle
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      "assets/icons/google.png",
                      width: 25,
                    ),
                  )
                : const SizedBox.shrink(),
            Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  MaterialStateProperty<T> getStyle<T>(T value) {
    return MaterialStateProperty.all(value);
  }
}
