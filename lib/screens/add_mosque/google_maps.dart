import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tntj_mosque/config/config.dart';
import 'package:tntj_mosque/helpers/small_functions.dart';
import 'package:tntj_mosque/screens/screens.dart';

class LocationSelection extends StatefulWidget {
  static String routeName = "/add_location";
  const LocationSelection({Key? key}) : super(key: key);

  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  final Location locationPkg = Location();
  final SmallFunc _smallFunc = SmallFunc();

  late GoogleMapController _googleMapController;
  late Map<String, double> initialLocation;
  late LocationData locationData;
  Map<String, double>? location;

  showIt(String text) {
    _smallFunc.showSnackBar(text, context);
  }

  @override
  void initState() {
    locationPkg.changeSettings(accuracy: LocationAccuracy.high);
    super.initState();
  }

  goToAddMosque(oldData) {
    Map<String, double>? data;
    if (location == null) {
      data = {
        'lat': locationData.latitude ?? 00,
        'long': locationData.longitude ?? 00,
      };
    } else {
      data = location;
    }
    if (data != null) {
      oldData['location'] = GeoPoint(
        data['lat']!,
        data['long']!,
      );
      Navigator.pushReplacementNamed(
        context,
        AddMosque.routeName,
        arguments: oldData,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var oldData =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>?;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            AddMosque.routeName,
          ),
          icon: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text("Select Location"),
        backgroundColor: themeBlue,
        actions: [
          IconButton(
            onPressed: () => goToAddMosque(oldData),
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: FutureBuilder<LocationData>(
        future: locationPkg.getLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          locationData = snapshot.data!;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(locationData.latitude!, locationData.longitude!),
              zoom: 17,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (controller) => _googleMapController = controller,
            onLongPress: addMarker,
            markers: {
              if (location == null)
                Marker(
                  markerId: const MarkerId("Current Location"),
                  infoWindow: const InfoWindow(title: "Current Location"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  ),
                  position:
                      LatLng(locationData.latitude!, locationData.longitude!),
                ),
              if (location != null)
                Marker(
                  markerId: const MarkerId("selected_location"),
                  infoWindow: const InfoWindow(title: "Selected Location"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                  position: LatLng(location!['lat']!, location!['long']!),
                ),
            },
          );
        },
      ),
    );
  }

  void addMarker(LatLng pos) {
    setState(() {
      location = {
        "lat": pos.latitude,
        "long": pos.longitude,
      };
    });
  }
}
