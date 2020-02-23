import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapsToolkit;

/// A customize of Flutter Google Map, only use for ATA App.
///
/// Have some features
/// 1. Specify current location of device
/// 2. Pin any marker on map and move it
/// 3. Show circle around pin marker with deviation radius
/// 4. Calulate distance between current location with pin marker position
class ATAMap extends StatefulWidget {
  @override
  State<ATAMap> createState() => ATAMapState();
}

class ATAMapState extends State<ATAMap> {
  static const double DEFAULT_ZOOM = 14;
  // unit meter (m)
  static const double DEVIATION_RADIUS = 100;

  static const CameraPosition DEFAULT_VIEW = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: DEFAULT_ZOOM,
  );
  static double currentLat;
  static double currentLng;
  static double currentMarkedLat;
  static double currentMarkedLng;

  BitmapDescriptor markedLocationIcon;
  BitmapDescriptor currentLocationIcon;
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _setCustomMapIcons();
  }

  void _setCustomMapIcons() async {
    markedLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(128, 128)),
        'assets/images/marked-location-icon.png');
  }

  void _goToCurrentLocation() {
    setState(() async {
      try {
        var currentLocation = await Geolocator().getCurrentPosition();
        print(currentLocation);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            //bearing: 192.8334901395799,
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            //tilt: 59.440717697143555,
            zoom: DEFAULT_ZOOM)));
        currentLat = currentLocation.latitude;
        currentLng = currentLocation.longitude;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          print(e);
          print('PERMISSION_DENIED');
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
      _markers.clear();
      _circles.clear();
      _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
              title: '${point.latitude}, ${point.longitude}',
              snippet:
                  'Distance with current location ${_calcDistance(mapsToolkit.LatLng(point.latitude, point.longitude), mapsToolkit.LatLng(currentLat, currentLng))} m'),
          icon: markedLocationIcon,
          onTap: () {
            print('Tapped');
          },
          draggable: true,
          onDragEnd: ((newPoint) {
            _addMarker(newPoint);
            currentMarkedLat = newPoint.latitude;
            currentMarkedLng = newPoint.longitude;
          })));
      _circles.add(Circle(
          circleId: CircleId(point.toString()),
          center: point,
          radius: DEVIATION_RADIUS,
          strokeWidth: 1,
          strokeColor: Colors.blue.withOpacity(0.3),
          fillColor: Colors.blue.withOpacity(0.2)));
    });
  }

  void _handleLongPress(LatLng point) {
    _addMarker(point);
  }

  int _calcDistance(mapsToolkit.LatLng point1, mapsToolkit.LatLng point2) {
    return mapsToolkit.SphericalUtil.computeDistanceBetween(point1, point2).round();
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
          myLocationButtonEnabled: false,
          mapToolbarEnabled: true,
          compassEnabled: true,
          markers: _markers,
          circles: _circles,
          onLongPress: _handleLongPress),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black54,
        child: Icon(Icons.my_location),
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white70, width: 1)),
        mini: true,
      ),
    );
  }
}
