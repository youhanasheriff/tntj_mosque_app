import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/models/mosque.dart';
import 'package:tntj_mosque/screens/mosque/mosque_page.dart';

class MosqueCard extends StatelessWidget {
  final Mosque mosque;

  const MosqueCard({
    Key? key,
    required this.mosque,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            MosquePage.routeName,
            arguments: mosque,
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: themeBlue,
              ),
              width: double.infinity,
              child: Stack(
                children: [
                  Image(
                    image: CachedNetworkImageProvider(mosque.images[0]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black45,
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mosque.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mosque.branch,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              MapsLauncher.launchCoordinates(
                                  double.parse(mosque.location.lat),
                                  double.parse(mosque.location.long));
                            },
                            icon: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
