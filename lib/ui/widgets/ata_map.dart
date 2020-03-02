import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps;

/// A custom Flutter Google Map.
/// Have some features:
/// 1. Specify current location of device
/// 2. Pin any marker on map and move it
/// 3. Show circle around marked position with deviation radius
/// 4. Calulate distance between current location and marked position
/// Example code :
/// ==> admin user
/// ```dart
/// ATAMap(
///    isMoveableMarker: true,
///)
/// ```
/// ==> normal user
/// ```dart
/// ATAMap(
///    titleMarkedPosition: 'Office Position',
///    markedLat: 10.762622,
///    markedLng:  106.660172,
///)
/// ```
class ATAMap extends StatefulWidget {
  final double centerMapLat;
  final double centerMapLng;
  final double markedLat;
  final double markedLng;
  final bool isMoveableMarker;
  final double deviationRadius;
  final String titleMarkedPosition;
  ATAMap(
      {this.markedLat = 10.7440878,
      this.markedLng = 106.7007886,
      this.centerMapLat = 10.7440878,
      this.centerMapLng = 106.7007886,
      this.isMoveableMarker = false,
      this.deviationRadius = 100,
      this.titleMarkedPosition = "Marked Position"});

  @override
  State<ATAMap> createState() => ATAMapState(
      currentMarkedLat: markedLat,
      currentMarkedLng: markedLng,
      centerMapLat: centerMapLat,
      centerMapLng: centerMapLng,
      isMoveableMarker: isMoveableMarker,
      deviationRadius: deviationRadius,
      titleMarkedPosition: titleMarkedPosition);
}

class ATAMapState extends State<ATAMap> {
  CameraPosition defaultCamera;
  static const double DEFAULT_ZOOM = 17;
  //static const double deviationRadius = 100;
  static const int TIMEOUT_PIN_MARKER_MAP_LOADED = 4;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set();
  final double centerMapLat;
  final double centerMapLng;
  double currentLocationLat;
  double currentLocationLng;
  double currentMarkedLat;
  double currentMarkedLng;
  double deviationRadius;

  BitmapDescriptor markedLocationIcon;
  final bool isMoveableMarker;
  final String titleMarkedPosition;

  ATAMapState({this.currentMarkedLat, this.currentMarkedLng, this.centerMapLat, this.centerMapLng, this.isMoveableMarker, this.deviationRadius, this.titleMarkedPosition}) {
    defaultCamera = CameraPosition(
      target: LatLng(centerMapLat, centerMapLng),
      zoom: DEFAULT_ZOOM,
    );
  }
  @override
  void initState() {
    super.initState();
    _setCustomMapIcons();
  }

  void _setCustomMapIcons() async {
    markedLocationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)), 'assets/images/marked-location-icon.png');
  }

  void _goToCurrentLocation() {
    setState(() async {
      try {
        var currentPosition = await Geolocator().getCurrentPosition();
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude), zoom: DEFAULT_ZOOM)));
        currentLocationLat = currentPosition.latitude;
        currentLocationLng = currentPosition.longitude;
        _addMarker(LatLng(this.currentMarkedLat, this.currentMarkedLng));
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(title: Text("PERMISSION_DENIED"), content: Text('GPS device is OFF, please turn ON !'));
              });
        }
      }
    });
  }

  void _addMarker(LatLng point) {
    setState(() {
      _markers.clear();
      _circles.clear();
      currentMarkedLat = point.latitude;
      currentMarkedLng = point.longitude;
      _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
              title: isMoveableMarker == true ? '$currentMarkedLat, $currentMarkedLng' : '$titleMarkedPosition',
              snippet:
                  'Distance :${_calcDistance(maps.LatLng(point.latitude, point.longitude), maps.LatLng(currentLocationLat, currentLocationLng))} m -> isCheckinable:${isCheckinable()}'),
          icon: markedLocationIcon,
          draggable: isMoveableMarker,
          onDragEnd: ((newPoint) {
            if (isMoveableMarker == true) {
              _addMarker(newPoint);
              currentMarkedLat = newPoint.latitude;
              currentMarkedLng = newPoint.longitude;
            }
          })));
      _circles.add(Circle(
          circleId: CircleId(point.toString()),
          center: point,
          radius: deviationRadius,
          strokeWidth: 1,
          strokeColor: Colors.blue.withOpacity(0.3),
          fillColor: Colors.blue.withOpacity(0.2)));
    });
  }

  void _handleLongPress(LatLng point) {
    if (isMoveableMarker == true) _addMarker(point);
  }

  int _calcDistance(maps.LatLng point1, maps.LatLng point2) {
    return maps.SphericalUtil.computeDistanceBetween(point1, point2).round();
  }

  bool isCheckinable() {
    return _calcDistance(maps.LatLng(currentMarkedLat, currentMarkedLng), maps.LatLng(currentLocationLat, currentLocationLng)) <= deviationRadius;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: defaultCamera,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            await Future.delayed(
                const Duration(seconds: TIMEOUT_PIN_MARKER_MAP_LOADED), () => _addMarker(LatLng(this.currentMarkedLat, this.currentMarkedLng)));
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
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
