import 'dart:developer';

import 'package:driver_app/core/utils/permissions.dart';
import 'package:driver_app/features/drive/data/models/location_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocationDataSource {
  Future<LocationModel?> getCurrentLocation(); 
}

class LocationDataSourceImpl implements LocationDataSource {
  final SharedPreferences prefs;

  LocationDataSourceImpl({required this.prefs});

  @override
  Future<LocationModel?> getCurrentLocation() async {
    try {
      final hasPermission = await Permissions.checkLocationServices();

      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        )
      );

      String? address;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = '${place.street}, ${place.subLocality}, ${place.locality}';
        }
      } catch (e) {
        log('Error getting address: $e');
      }

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      log('Error getting location: $e');
      return null;
    }
  }
}