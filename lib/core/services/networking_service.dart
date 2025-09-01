import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_request_model.dart';

class NetworkingService {
  final String baseUrl = 'https://yourapi.com/api/service_requests'; // Replace with your actual API URL

  // Get all service requests
  Future<List<ServiceRequest>> fetchServiceRequests() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ServiceRequest.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load service requests');
    }
  }

  // Post a new service request
  Future<ServiceRequest> createServiceRequest(ServiceRequest request) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return ServiceRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create service request');
    }
  }

  // Update an existing service request
  Future<void> updateServiceRequest(ServiceRequest request) async {
    final url = Uri.parse('$baseUrl/${request.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update service request');
    }
  }

  // Delete a service request
  Future<void> deleteServiceRequest(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service request');
    }
  }
}
