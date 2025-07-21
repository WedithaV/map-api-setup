import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'services/api_service.dart';
import 'models/service_center.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Center Locator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<ServiceCenter> _serviceCenters = [];
  String _message = '';
  Position? _currentPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _message = 'Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _message = 'Location permissions are denied.');
        return;
      }
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _fetchNearbyServiceCenters();
    } catch (e) {
      setState(() => _message = 'Error getting location: $e');
    }
  }

  Future<void> _fetchNearbyServiceCenters() async {
    if (_currentPosition == null) return;
    try {
      final centers = await _apiService.getNearbyServiceCenters(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      setState(() {
        _serviceCenters = centers;
        _message = centers.isEmpty ? 'No service centers found nearby.' : '';
      });
      if (_mapController != null && centers.isNotEmpty) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(centers[0].latitude, centers[0].longitude),
          ),
        );
      }
    } catch (e) {
      setState(() => _message = 'Error fetching service centers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Service Centers')),
      body: Column(
        children: [
          if (_currentPosition != null)
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  zoom: 14,
                ),
                onMapCreated: (controller) => _mapController = controller,
                markers: _serviceCenters
                    .map((center) => Marker(
                          markerId: MarkerId(center.id.toString()),
                          position: LatLng(center.latitude, center.longitude),
                          infoWindow: InfoWindow(title: center.name),
                        ))
                    .toSet(),
              ),
            ),
          Expanded(
            child: _message.isNotEmpty
                ? Center(child: Text(_message))
                : ListView.builder(
                    itemCount: _serviceCenters.length,
                    itemBuilder: (context, index) {
                      final center = _serviceCenters[index];
                      return ListTile(
                        title: Text(center.name),
                        subtitle: Text('Lat: ${center.latitude.toStringAsFixed(4)}, Lng: ${center.longitude.toStringAsFixed(4)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}