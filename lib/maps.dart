import 'dart:convert';
import 'dart:async';

import 'package:dog_app_flutter/main.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// Fetch data from Firebase Realtime Database
Future<List<DogData>> fetchDogData() async {
  var client = http.Client();
  final response = await client.get(Uri.parse(
      'https://dog-app-flutter-default-rtdb.europe-west1.firebasedatabase.app/dog_data.json'));

  return parseDogData(response.body);
}

// A function that converts a response body into a List<DogData>.
List<DogData> parseDogData(responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<DogData>((json) => DogData.fromJson(json)).toList();
}

// DogData data model
class DogData {
  final String markerID;
  final String name;
  final String position;
  final String address;
  //final String details;

  const DogData({
    required this.markerID,
    required this.name,
    required this.position,
    required this.address,
    //required this.details,
  });

  factory DogData.fromJson(Map<String, dynamic> json) {
    final markerID = json['markerID'] as String;
    final name = json['name'] as String;
    final position = json['position'] as String;
    final address = json['address'] as String;
    //final details = json['details'] as String;

    return DogData(
      markerID: markerID,
      name: name,
      position: position,
      address: address,
      //details: details,
    );
  }
}

class Maps extends StatefulWidget {
  const Maps({super.key, required List<SignedOutAction> actions});

  @override
  // ignore: library_private_types_in_public_api
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor customIcon;
  Set<Marker> markers = {};
  LatLng showLocation =
      const LatLng(65.01243958465295, 25.465190300650292); // OULU

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
  }

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/icons/dog_paw_location_icon_100.png');
  }

  Future<Position?> getUserCurrentLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      debugPrint(
          "Location permissions are permanently denied, we cannot request permissions.");
      return null;
    }

    if (permission == LocationPermission.denied) {
      await _requestLocationPermission();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    setCustomMarker();
    getUserCurrentLocation().then((position) {
      if (position != null) {
        setState(() {
          showLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
    fetchDogData().then((dogData) {
      //createMarkers(dogParks);
      for (var i = 0; i < dogData.length; i++) {
        markers.add(Marker(
            markerId: MarkerId(dogData[i].markerID),
            position: LatLng(double.parse(dogData[i].position.split(',')[0]),
                double.parse(dogData[i].position.split(',')[1])),
            infoWindow: InfoWindow(
              title: dogData[i].name,
              snippet: dogData[i].address,
            ),
            icon: customIcon //markerIcon,
            ));
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Map"),
        backgroundColor: Palette.primary,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<DogData>>(
        future: fetchDogData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                //Innital position on map
                target: showLocation,
                zoom: 12.0,
              ),
              markers: markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _controller.complete(controller);
                });
              },
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
