import 'package:driver_app/features/drive/domain/entities/location.dart';
import 'package:driver_app/features/drive/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _locationRepository;

  GetCurrentLocationUseCase(this._locationRepository);

  Future<LocationE?> execute() async {
    return await _locationRepository.getCurrentLocation();
  }
}