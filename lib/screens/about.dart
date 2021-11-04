import 'package:flutter/material.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static String routeName = "/about";

  const AboutPage({Key? key}) : super(key: key);

  void goToInsta() {
    Uri uri = Uri.https("www.instagram.com", "/youhana.sheriff/");
    String url = uri.toString();
    launch(url);
  }

  void sendEMail() {
    String url =
        "mailto:youhanasheriff2000@gmail.com?subject=Feeback&body=Your%20App%20is%20cool!!";
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Scaffold(
        backgroundColor: themeBlue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 6),
            CircleAvatar(
              radius: width * 0.28,
              backgroundImage: const AssetImage("assets/image.jpg"),
            ),
            const Spacer(flex: 2),
            buildTitle("Developed By : "),
            const SizedBox(height: 20),
            buildText("Alias - ", "Youhana Sheriff"),
            buildText("Full Name - ", "Mohammed Youhana Sheriff"),
            const Spacer(flex: 1),
            buildTitle("Contact : "),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: getStyle(themeBlue),
                elevation: getStyle(1),
              ),
              onPressed: goToInsta,
              child: buildText("Insta : ", "@youhana.sheriff"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: getStyle(themeBlue),
                elevation: getStyle(1),
              ),
              onPressed: sendEMail,
              child: buildText("email : ", "youhanasheriff2000@gmail.com"),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  MaterialStateProperty<T> getStyle<T>(T value) {
    return MaterialStateProperty.all(value);
  }

  Text buildTitle(title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: headTextStyle.copyWith(
        color: Colors.white,
      ),
    );
  }

  Row buildText(title, subTitile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: bodyTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subTitile,
          textAlign: TextAlign.center,
          style: bodyTextStyle.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
