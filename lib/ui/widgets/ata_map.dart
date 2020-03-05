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
///
/// #admin user
/// ```dart
/// AtaMap(
///    isMoveableMarker: true,
///)
/// ```
/// #normal user
/// ```dart
/// AtaMap(
///    titleMarkedPosition: 'Office Position',
///    markedLat: 10.762622,
///    markedLng:  106.660172,
///)
/// ```
class AtaMap extends StatefulWidget {
  final double centerMapLat;
  final double centerMapLng;
  final double markedLat;
  final double markedLng;
  final bool isMoveableMarker;
  final double authRange;
  final String titleMarkedPosition;

  AtaMap(
      {this.markedLat = 10.7440878,
      this.markedLng = 106.7007886,
      this.centerMapLat = 10.7440878,
      this.centerMapLng = 106.7007886,
      this.isMoveableMarker = false,
      this.authRange = 100,
      this.titleMarkedPosition = "Office Location"});

  @override
  State<AtaMap> createState() => AtaMapState();
}

class AtaMapState extends State<AtaMap> {
  double currentMarkedLat;
  double currentMarkedLng;
  double currentLocationLat;
  double currentLocationLng;
  bool isMapReady = false;
  static const int TIMEOUT_PIN_MARKER_MAP_LOADED = 2;
  static const double DEFAULT_ZOOM = 17;
  CameraPosition get defaultCamera {
    return CameraPosition(
      target: LatLng(widget.centerMapLat, widget.centerMapLng),
      zoom: DEFAULT_ZOOM,
    );
  }

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set();
  BitmapDescriptor markedLocationIcon;
  @override
  void initState() {
    super.initState();
    currentMarkedLat = widget.markedLat;
    currentMarkedLng = widget.markedLng;
    print('currentMarkedLat :$currentMarkedLat, currentMarkedLng:$currentMarkedLng');
    _setCustomMapIcons();
  }

  void _setCustomMapIcons() async {
    markedLocationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)), 'assets/images/marked-location-icon.png');
  }

  Future<Position> getCurrentLocation() async => await Geolocator().getCurrentPosition();

  void _catchGPSOff(PlatformException e) {
    if (e.code == 'PERMISSION_DENIED') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(title: Text("PERMISSION_DENIED"), content: Text('GPS device is OFF, please turn ON !'));
          });
    }
  }

  void _animateMap(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: DEFAULT_ZOOM)));
    if (_markers.length == 0) _addMarker(LatLng(currentMarkedLat, currentMarkedLng));
  }

  void _gotoOfficeLocation() async {
    try {
      _animateMap(LatLng(currentMarkedLat, currentMarkedLng));
    } on PlatformException catch (e) {
      _catchGPSOff(e);
    }
  }

  void _goToCurrentLocation() async {
    try {
      Position currentPosition = await getCurrentLocation();
      _animateMap(LatLng(currentPosition.latitude, currentPosition.longitude));
      currentLocationLat = currentPosition.latitude;
      currentLocationLng = currentPosition.longitude;
    } on PlatformException catch (e) {
      _catchGPSOff(e);
    }
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
              title: widget.isMoveableMarker ? '$currentMarkedLat, $currentMarkedLng' : '${widget.titleMarkedPosition}',
              snippet: 'Distance :${_calcDistance()} m -> isCheckinable:${isCheckinable()}'),
          icon: markedLocationIcon,
          draggable: widget.isMoveableMarker,
          onDragEnd: ((newPoint) {
            if (widget.isMoveableMarker) _addMarker(newPoint);
          })));
      _circles.add(Circle(
          circleId: CircleId(point.toString()),
          center: point,
          radius: widget.authRange,
          strokeWidth: 1,
          strokeColor: Colors.blue.withOpacity(0.3),
          fillColor: Colors.blue.withOpacity(0.2)));
    });
  }

  void _handleLongPress(LatLng point) {
    if (widget.isMoveableMarker && isMapReady) _addMarker(point);
  }

  int _calcDistance() {
    return maps.SphericalUtil.computeDistanceBetween(
            maps.LatLng(currentMarkedLat, currentMarkedLng), maps.LatLng(currentLocationLat, currentLocationLng))
        .round();
  }

  bool isCheckinable() => _calcDistance() <= widget.authRange;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: defaultCamera,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            Position currentLocation = await getCurrentLocation();
            currentLocationLat = currentLocation.latitude;
            currentLocationLng = currentLocation.longitude;
            _addMarker(LatLng(widget.markedLat, widget.markedLng));
            isMapReady = true;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: _markers,
          circles: _circles,
          onLongPress: _handleLongPress),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
                onPressed: _gotoOfficeLocation,
                backgroundColor: Colors.white70,
                foregroundColor: Colors.black54,
                child: Icon(Icons.home),
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white70, width: 1)),
                mini: true),
            FloatingActionButton(
                onPressed: _goToCurrentLocation,
                backgroundColor: Colors.white70,
                foregroundColor: Colors.black54,
                child: Icon(Icons.my_location),
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white70, width: 1)),
                mini: true)
          ],
        ),
      ),
    );
  }
}
