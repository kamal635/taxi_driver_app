abstract interface class DriverLocationRepository {
  Future<void> updateLocation({required double lat, required double lon});
}
