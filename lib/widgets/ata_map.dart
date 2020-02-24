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
/// 4. Calulate distance between current location with pin marker position
class ATAMap extends StatefulWidget {
  final double centerMapLat;
  final double centerMapLng;
  final double markedLat;
  final double markedLng;
  //ATAMap({this.centerMapLat = 37.427961335, this.centerMapLng = -122.08574966},double markedLat, double markedLng){}
  ATAMap(
      {this.markedLat = 10.7440878,
      this.markedLng = 106.7007886,
      this.centerMapLat = 10.7440878,
      this.centerMapLng = 106.7007886});

  @override
  State<ATAMap> createState() => ATAMapState(
      currentMarkedLat: markedLat,
      currentMarkedLng: markedLng,
      centerMapLat: centerMapLat,
      centerMapLng: centerMapLng);
}

class ATAMapState extends State<ATAMap> {
  static const double DEFAULT_ZOOM = 17;
  static const double DEVIATION_RADIUS = 100;
  CameraPosition defaultCamera;
  static double currentLat;
  static double currentLng;
  double currentMarkedLat;
  double currentMarkedLng;
  static bool ableCheckIn = false;
  BitmapDescriptor markedLocationIcon;
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set();
  Completer<GoogleMapController> _controller = Completer();

  final double centerMapLat;
  final double centerMapLng;
  ATAMapState(
      {this.currentMarkedLat,
      this.currentMarkedLng,
      this.centerMapLat,
      this.centerMapLng}) {
    defaultCamera = CameraPosition(
      target: LatLng(centerMapLat, centerMapLng),
      zoom: DEFAULT_ZOOM,
    );
  }
  @override
  void initState() {
    super.initState();
    _setCustomMapIcons();
    //_addMarker(LatLng(this.currentMarkedLat, this.currentMarkedLng));
  }

  void _setCustomMapIcons() async {
    markedLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(128, 128)),
        'assets/images/marked-location-icon.png');
  }

  void _goToCurrentLocation() {
    setState(() async {
      try {
        var currentPosition = await Geolocator().getCurrentPosition();
        print(currentPosition);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: DEFAULT_ZOOM)));
        currentLat = currentPosition.latitude;
        currentLng = currentPosition.longitude;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          print(e.code);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("PERMISSION_DENIED"),
                    content: Text('GPS device is OFF, please turn ON !'));
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
      ableCheckIn = isAvailableCheckIn();
      //_setCustomMapIcons();
      _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
              title: '${point.latitude}, ${point.longitude}',
              snippet:
                  'Distance :${_calcDistance(maps.LatLng(point.latitude, point.longitude), maps.LatLng(currentLat, currentLng))} m -> ableCheckIn:$ableCheckIn'),
          icon: markedLocationIcon,
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

  int _calcDistance(maps.LatLng point1, maps.LatLng point2) {
    return maps.SphericalUtil.computeDistanceBetween(point1, point2).round();
  }

  bool isAvailableCheckIn() {
    return _calcDistance(maps.LatLng(currentMarkedLat, currentMarkedLng),
            maps.LatLng(currentLat, currentLng)) <=
        DEVIATION_RADIUS;
  }

  @override
  Widget build(BuildContext context) {
    //_addMarker(LatLng(this.currentMarkedLat, this.currentMarkedLng));
    return new Scaffold(
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: defaultCamera,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            Future.delayed(
                const Duration(seconds: 3),
                () => _addMarker(
                    LatLng(this.currentMarkedLat, this.currentMarkedLng)));
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
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1)),
        mini: true,
      ),
    );
  }
}
