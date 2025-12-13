import 'package:driver_app/features/drive/data/datasources/location_datasource.dart';
import 'package:driver_app/features/drive/domain/entities/location.dart';
import 'package:driver_app/features/drive/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;

  LocationRepositoryImpl({required this.locationDataSource});

  @override
  Future<LocationE?> getCurrentLocation() async {
    final locationModel = await locationDataSource.getCurrentLocation();
    
    return locationModel?.toEntity();
  }
}