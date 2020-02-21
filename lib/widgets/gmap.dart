import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  @override
  State<GMap> createState() => GMapState();
}

class GMapState extends State<GMap> {
  static const CameraPosition DEFAULT_VIEW = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static double currentLat;
  static double currentLng;

  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: DEFAULT_VIEW,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        //myLocationButtonEnabled: true,
        //markers: _currentLocationMarkers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: Text('To current location'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(currentLocation);
    setState(() async {
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          //bearing: 192.8334901395799,
          target: marker.position,
          //tilt: 59.440717697143555,
          zoom: 19.151926040649414)));
      currentLat = marker.position.latitude;
      currentLng = marker.position.longitude;
    });
  }
}
