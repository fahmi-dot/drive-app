import 'package:driver_app/features/drive/domain/entities/location.dart';

abstract class LocationRepository {
  Future<LocationE?> getCurrentLocation();
}