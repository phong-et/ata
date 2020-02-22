import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapsToolkit;

//import 'package:maps_toolkit/maps_toolkit.dart' as mapToolkit;
class ATAMap extends StatefulWidget {
  @override
  State<ATAMap> createState() => ATAMapState();
}

class ATAMapState extends State<ATAMap> {
  static const CameraPosition DEFAULT_VIEW = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static double currentLat;
  static double currentLng;
  static double currentMarkedLat;
  static double currentMarkedLng;

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(128, 128)),
        'assets/images/current-location-marker.png');
  }

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
          circles: _circles,
          onLongPress: _handleLongPress),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: Text('To current location'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    setState(() async {
      try {
        var currentLocation = await Geolocator().getCurrentPosition();
        //print(currentLocation);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            //bearing: 192.8334901395799,
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            //tilt: 59.440717697143555,
            zoom: 19.151926040649414)));
        currentLat = currentLocation.latitude;
        currentLng = currentLocation.longitude;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("PERMISSION_DENIED"),
                    content: Text('GPS device is OFF'));
              });
        }
      }
    });
  }

  void _addMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'Lat: ${point.latitude}, lng:${point.longitude}',
          ),
          icon: pinLocationIcon,
          onTap: () {
            print('Tapped');
          },
          draggable: true,
          onDragEnd: ((newPoint) {
            _markers.clear();
            _circles.clear();
            _addMarker(newPoint);
            currentMarkedLat = newPoint.latitude;
            currentMarkedLng = newPoint.longitude;
          })));
    });
    _circles.add(Circle(
        circleId: CircleId(point.toString()),
        center: point,
        radius: 1000,
        strokeWidth: 1,
        strokeColor: Colors.blue.withOpacity(0.3),
        fillColor: Colors.blue.withOpacity(0.2)));
    _calcDistance(mapsToolkit.LatLng(currentMarkedLat, currentMarkedLng),
        mapsToolkit.LatLng(currentLat, currentLng));
  }

  void _handleLongPress(LatLng point) {
    _markers.clear();
    _circles.clear();
    _addMarker(point);
  }

  void _calcDistance(mapsToolkit.LatLng point1, mapsToolkit.LatLng point2) {
    final distance =
        mapsToolkit.SphericalUtil.computeDistanceBetween(point1, point2) / 1000;
    print('Distance is $distance km.');
  }
}
