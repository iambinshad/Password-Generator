import 'dart:developer';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {



  LocationPermission? permission;

  String locationAddress = 'Pick a Address';
  double latitude = 23, longitude = 86;
  String currentLocation = "Current Location";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
       permission = await Geolocator.requestPermission();
    });
    return Scaffold(
        appBar: AppBar(
          title:const Text("data"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => fetchCurrentLocation(),
                child: Text(currentLocation)),
            Center(
              child: InkWell(
                child: Text(locationAddress),
                onTap: () {
                  showModel(context);
                },
              ),
            ),
          ],
        ));
  }

  showModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 900,
          color: Colors.red,
          child: Center(
            child: OpenStreetMapSearchAndPick(

                onGetCurrentLocationPressed: fetchCurrentLocation,
                center: LatLong(latitude, longitude),
                buttonColor: Colors.teal,
                buttonText: 'Set Current Location',
                onPicked: (pickedData) {
                  

                  Navigator.pop(context);

                  setState(() {
                    locationAddress = pickedData.address;
                    latitude = pickedData.latLong.latitude;
                    longitude = pickedData.latLong.longitude;
                  });
                }),
          ),
        );
      },
    );
  }

   Future<LatLng> fetchCurrentLocation() async {
    try {

      LatLng position = await getCurrentLocation();
      // log(position.latitude.toString());
      // log(position.longitude.toString());
      setState(() {
        
        currentLocation =
            'Latitude:${position.latitude}longitude${position.longitude}';
      });
      return position;
    } catch (e) {
      setState(() {
        currentLocation = 'Error : $e';
      });
      
    }
    return LatLng(23, 86);
  }

 Future<LatLng> getCurrentLocation() async {
  bool serviceEnabled;
  // LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      return Future.error('Location permissions are denied.');
    }
  }

  // Fetch the current location
  Position position = await Geolocator.getCurrentPosition();
  return LatLng(position.latitude, position.longitude);
}

}


