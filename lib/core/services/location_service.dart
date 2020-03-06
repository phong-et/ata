import 'package:ata/core/models/office.dart';
import 'package:ata/core/services/office_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dartz/dartz.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/location.dart';

class LocationService {
  final OfficeService _officeService;
  LocationService(OfficeService officeService) : _officeService = officeService;

  Either<Failure, Office> _officeSettings;
  Either<Failure, Location> _deviceLocation;

  //* all async request here
  Future<void> refreshService() async {
    await _officeService.fetchOfficeSettings();
    _officeSettings = _officeService.officeSettings;
    _deviceLocation = await fetchDeviceLocation();
  }

  Location getOfficeLocation() {
    return _officeSettings.fold(
      (failure) => Location(lat: 0.0, lng: 0.0),
      (office) => Location(lat: office.lat, lng: office.lng),
    );
  }

  Location getDeviceLocation() {
    return _deviceLocation.fold(
      (failure) => Location(lat: 1.1, lng: 1.1),
      (location) => Location(lat: location.lat, lng: location.lng),
    );
  }

  double getAuthRange() {
    return _officeSettings.fold(
      (failure) => 0.1,
      (office) => office.authRange,
    );
  }

  Future<bool> checkLocationForAttendance() async {
    return (await isWithinAuthRange(getDeviceLocation(), getOfficeLocation(), getAuthRange())).fold(
      (failure) => false,
      (isWithin) => isWithin,
    );
  }

  //* Utils
  Future<Either<Failure, bool>> isWithinAuthRange(
      Location deviceLocation, Location officeLocation, double authRange) async {
    try {
      final double distance = await Geolocator().distanceBetween(
        deviceLocation.lat,
        deviceLocation.lng,
        officeLocation.lat,
        officeLocation.lng,
      );
      return Right(distance <= authRange);
    } catch (error) {
      return Left(Failure(error.toString()));
    }
  }

  Future<Either<Failure, Location>> fetchDeviceLocation() async {
    bool isEnabled = await Geolocator().isLocationServiceEnabled();
    if (isEnabled) {
      try {
        var device = await Geolocator().getCurrentPosition().timeout(Duration(seconds: 15));
        return Right(Location(lat: device.latitude, lng: device.longitude));
      } catch (failure) {
        return Left(Failure(failure.toString()));
      }
    } else {
      return Left(Failure('Device\'s GPS is OFF, please turn ON !'));
    }
  }
}
