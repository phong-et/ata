import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps;

/// A customize of Flutter Google Map, only use for ATA App.
///
/// Have some features
/// 1. Specify current location of device
/// 2. Pin any marker on map and move it
/// 3. Show circle around pin marker with deviation radius
/// 4. Calulate distance between current location and marker position
class ATAMap extends StatefulWidget {
  final double centerMapLat;
  final double centerMapLng;
  final double markedLat;
  final double markedLng;
  final bool isMoveableMarker;
  final String titleMarker;
  ATAMap(
      {this.markedLat = 10.7440878,
      this.markedLng = 106.7007886,
      this.centerMapLat = 10.7440878,
      this.centerMapLng = 106.7007886,
      this.isMoveableMarker = false,
      this.titleMarker = "Marked Place"});

  @override
  State<ATAMap> createState() => ATAMapState(
      currentMarkedLat: markedLat,
      currentMarkedLng: markedLng,
      centerMapLat: centerMapLat,
      centerMapLng: centerMapLng,
      isMoveableMarker: isMoveableMarker,
      titleMarker: titleMarker);
}

class ATAMapState extends State<ATAMap> {
  CameraPosition defaultCamera;
  static const double DEFAULT_ZOOM = 17;
  static const double DEVIATION_RADIUS = 100;
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

  BitmapDescriptor markedLocationIcon;
  final bool isMoveableMarker;
  final String titleMarker;

  ATAMapState({this.currentMarkedLat, this.currentMarkedLng, this.centerMapLat, this.centerMapLng, this.isMoveableMarker, this.titleMarker}) {
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
          print(e.code);
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
              title: '$titleMarker',
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
          radius: DEVIATION_RADIUS,
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
    return _calcDistance(maps.LatLng(currentMarkedLat, currentMarkedLng), maps.LatLng(currentLocationLat, currentLocationLng)) <= DEVIATION_RADIUS;
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
