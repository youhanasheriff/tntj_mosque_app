import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/models/mosque.dart';
import 'package:share/share.dart';
import 'package:tntj_mosque/screens/screens.dart';

class MosquePage extends StatelessWidget {
  static String routeName = "/mosque_page";
  const MosquePage({Key? key}) : super(key: key);

  void shareLocation(Mosque mosque) async {
    var uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${mosque.location.lat},${mosque.location.long}'
    });
    String url =
        "Here is the mosque you are searching for ${mosque.name} at $uri";
    await Share.share(url);
  }

  @override
  Widget build(BuildContext context) {
    var mosque = ModalRoute.of(context)!.settings.arguments as Mosque;
    String name =
        mosque.name[0].toUpperCase() + mosque.name.replaceRange(0, 1, "");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        title: Text(name),
        elevation: 2,
      ),
      body: Column(
        children: [
          Hero(
            tag: mosque.id,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ImageView.routeName,
                  arguments: mosque.images,
                );
              },
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      image: CachedNetworkImageProvider(
                        mosque.images[0],
                      ),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            shareLocation(mosque);
                          },
                          icon: Icon(
                            Icons.share,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildTextField("Area : ", mosque.area),
          const SizedBox(height: 10),
          _buildTextField("Branch : ", mosque.branch),
          const SizedBox(height: 10),
          _buildTextField("Address : ", mosque.address),
          const SizedBox(height: 10),
          _buildTextField("Pin No. : ", mosque.pinNo),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeBlue,
        onPressed: () {
          MapsLauncher.launchCoordinates(
            mosque.location.lat,
            mosque.location.long,
          );
        },
        child: Icon(
          Icons.location_on_outlined,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Padding _buildTextField(String text, secondaryText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            text,
            style: headTextStyle,
          ),
          Text(
            secondaryText,
            style: bodyTextStyle,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
