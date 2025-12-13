import 'dart:async';

import 'package:driver_app/features/drive/data/datasources/location_datasource.dart';
import 'package:driver_app/features/drive/data/repositories/location_repository_impl.dart';
import 'package:driver_app/features/drive/domain/entities/location.dart';
import 'package:driver_app/features/drive/domain/repositories/location_repository.dart';
import 'package:driver_app/features/drive/domain/usecases/get_current_location_usecase.dart';
import 'package:driver_app/shared/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationDataSourceProvider = Provider<LocationDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return LocationDataSourceImpl(prefs: prefs);
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final datasource = ref.watch(locationDataSourceProvider);

  return LocationRepositoryImpl(locationDataSource: datasource);
});

final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>((ref) {
  final repository = ref.watch(locationRepositoryProvider);

  return GetCurrentLocationUseCase(repository);
});

final locationProvider = AsyncNotifierProvider.autoDispose<LocationNotifier, LocationE?>(
  LocationNotifier.new,
);

class LocationNotifier extends AsyncNotifier<LocationE?> {
  @override
  FutureOr<LocationE?> build() {
    return null;
  }

  Future<bool> getCurrentLocation() async {
    state = AsyncLoading();

    try {
      final location = await ref.read(getCurrentLocationUseCaseProvider).execute();      

      state = AsyncData(location);
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }
}