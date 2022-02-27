import 'package:flutter/material.dart';
import 'package:tntj_mosque/auth/auth.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/helpers/small_functions.dart';
import 'package:tntj_mosque/screens/screens.dart';

class LoginPage extends StatelessWidget {
  static String routeName = "/login";

  LoginPage({
    Key? key,
  }) : super(key: key);

  final AuthHelper _authHelper = AuthHelper();

  void _loginWithGoogle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Account Verification"),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          content: const Text.rich(
            TextSpan(
              text: "If you Already verified your account ",
              style: TextStyle(
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: "Click ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "Continue",
                  style: TextStyle(
                    color: themeBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, VerificationForm.routeName);
              },
              child: const Text(
                "Verify Account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _authHelper.loginWithGoogle();
              },
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: themeBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
            "السَّلَامُ عَلَيْكُمْ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Assalamu Alaikum",
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
            () => _loginWithGoogle(context),
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
}
