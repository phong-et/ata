import 'package:ata/core/models/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class FingerPrintService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<Either<Failure, bool>> authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) return Left(Failure('Fingerprint Scan is not available!'));
      bool authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: false,
      );
      return Right(authenticated);
    } on PlatformException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
