import 'package:ata/core/services/office_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dartz/dartz.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/location.dart';

class LocationService {
  final OfficeService _officeService;
  LocationService(OfficeService officeService) : _officeService = officeService;

  Location officeLocation;
  Location deviceLocation;
  double authRange = 0.1;
  bool isWithinOfficeAuthRange = false;

  Future<Either<Failure, Location>> fetchDeviceLocation() async {
    bool isEnabled = await Geolocator().isLocationServiceEnabled();
    if (isEnabled) {
      try {
        var device = await Geolocator().getCurrentPosition();
        return Right(Location(lat: device.latitude, lng: device.longitude));
      } catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(Failure('Device\'s GPS is OFF, please turn ON !'));
    }
  }

  Future<Either<Failure, bool>> compareAuthRange(
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

  Future<void> updateLocationStatus() async {
    await _officeService.fetchOfficeSettings();
    _officeService.officeSettings.fold(
      (failure) => officeLocation = Location(lat: 0.0, lng: 0.0),
      (office) {
        officeLocation = Location(lat: office.lat, lng: office.lng);
        authRange = office.authRange;
      },
    );
    deviceLocation = (await fetchDeviceLocation()).fold(
      (failure) => Location(lat: 1.1, lng: 1.1),
      (location) => Location(lat: location.lat, lng: location.lng),
    );
    isWithinOfficeAuthRange = (await compareAuthRange(deviceLocation, officeLocation, authRange)).fold(
      (failure) => false,
      (isWithin) => isWithin,
    );
  }
}
