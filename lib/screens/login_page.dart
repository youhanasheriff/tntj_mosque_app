import 'package:flutter/material.dart';
import 'package:tntj_mosque/auth/auth.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/screens/screens.dart';
import 'package:tntj_mosque/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/small_functions.dart';

class LoginPage extends StatelessWidget {
  static String routeName = "/login";

  LoginPage({
    Key? key,
  }) : super(key: key);

  final AuthHelper _authHelper = AuthHelper();

  void sendEMail() {
    String url =
        "mailto:youhanasheriff2000@gmail.com?subject=For Verification&body=Assalamualaikum, I'm \"YOUR NAME\" from \"YOUR BRANCH NAME\". I want to add our mosque to this app.";
    launch(url);
  }

  void showDFormBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Account Verify"),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          content: const Text.rich(
            TextSpan(
              text: "If you already verified your account.\n",
              children: [
                TextSpan(
                  text: "Click ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: themeBlue,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(VerificationForm.routeName);
              },
              child: const Text(
                "Verify Account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
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
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
      barrierDismissible: true,
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
            () => showDFormBox(context), //_authHelper.loginWithGoogle,
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
                  backgroundColor:
                      getStyle<Color>(Colors.white.withOpacity(0.85)),
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

  Center buildButtons(
    String title,
    Function() action, {
    bool isGoogle = false,
  }) {
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
