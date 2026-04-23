import 'package:geolocator/geolocator.dart';
import '../../data/models/data_models.dart';

class LocationService {
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }
  
  Future<LocationResult> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        return LocationResult.failure('Location permission denied');
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return LocationResult.success(GeoPointModel(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      return LocationResult.failure('Failed to get location');
    }
  }
  
  Future<LocationResult> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        return getCurrentLocation();
      }
      
      return LocationResult.success(GeoPointModel(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      return getCurrentLocation();
    }
  }
  
  Future<LocationResult> getMockLocation() async {
    return LocationResult.success(const GeoPointModel(
      latitude: 31.7917,
      longitude: -7.0926,
    ));
  }
  
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}

class LocationResult {
  final GeoPointModel? data;
  final String? error;
  final bool isSuccess;
  
  const LocationResult._({this.data, this.error, required this.isSuccess});
  
  factory LocationResult.success(GeoPointModel data) => 
      LocationResult._(data: data, isSuccess: true);
  factory LocationResult.failure(String error) => 
      LocationResult._(error: error, isSuccess: false);
}