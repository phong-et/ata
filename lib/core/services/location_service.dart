import 'package:geolocator/geolocator.dart';
import 'package:dartz/dartz.dart';
import 'package:ata/core/models/failure.dart';
import 'package:ata/core/models/location.dart';

class LocationService {
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
}
