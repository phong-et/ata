import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

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

  Set<Marker> _markers = Set();
  //final ArgumentCallback<LatLng> onTap;
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
          markers: _markers,
          myLocationButtonEnabled: true,
          //markers: _currentLocationMarkers,
          //onTap: _handleTap
          onLongPress: _handleTap),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: Text('To current location'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    try {
      var currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
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
        //_markers.add(marker);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("PERMISSION_DENIED"),
                  content: Text('Please turn on location device'));
            });
      }
    }
  }
  void _addMarker(LatLng point){
    setState(() {
    _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'Lat: ${point.latitude}, lng:${point.longitude}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          onTap: () {
            print('Tapped');
          },
          draggable: true,
          onDragEnd: ((newPoint) {
            _markers.clear();
            _addMarker(newPoint);
          })));
    });
  }
  void _handleTap(LatLng point) {
    // setState(() {
    //   // _markers.clear();
    //   // _markers.add(Marker(
    //   //     markerId: MarkerId(point.toString()),
    //   //     position: point,
    //   //     infoWindow: InfoWindow(
    //   //       title: 'Lat: ${point.latitude}, lng:${point.longitude}',
    //   //     ),
    //   //     icon: BitmapDescriptor.defaultMarkerWithHue(
    //   //         BitmapDescriptor.hueMagenta),
    //   //     onTap: () {
    //   //       print('Tapped');
    //   //     },
    //   //     draggable: true,
    //   //     onDragEnd: ((value) {
    //   //       print(value.latitude);
    //   //       print(value.longitude);
    //   //       print('---');
    //   //       print(point.latitude);
    //   //       print(point.longitude);
    //   //     })));
    //   _addMarker(point);
    // });
     _addMarker(point);
  }
}
