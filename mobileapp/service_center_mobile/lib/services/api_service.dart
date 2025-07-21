import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_center.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.11:5152/api/servicecenters';

  Future<List<ServiceCenter>> getNearbyServiceCenters(double lat, double lng) async {
    try {
      final uri = Uri.parse('$baseUrl/nearby?lat=$lat&lng=$lng');
      print('Attempting to fetch from: $uri'); // Debug log
      final response = await http.get(uri);
      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => ServiceCenter.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load service centers: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getNearbyServiceCenters: $e'); // Debug log
      throw Exception('Failed to load service centers: $e');
    }
  }
}