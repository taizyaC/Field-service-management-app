import 'package:flutter/material.dart';
import '../../../core/models/service_request_model.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final ServiceRequest request;

  const ServiceRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Name: ${request.clientName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(request.description),
            const SizedBox(height: 10),
            Text(
              'Status: ${request.status}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Location:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Lat: ${request.location.latitude}, Lon: ${request.location.longitude}'),
            const SizedBox(height: 20),
            const Text(
              'Images:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildImagesSection(request.images),
            const Spacer(),
            CustomButton(
              text: 'Update Request',
              onPressed: () {
                // Navigate to edit screen with the current request
                Navigator.pushNamed(
                  context,
                  '/new_service_request',
                  arguments: request,
                );
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Delete Request',
              onPressed: () {
                _confirmDelete(context, request.id);
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to show images
  Widget _buildImagesSection(List<String> images) {
    if (images.isEmpty) {
      return const Text('No images available.');
    }
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(images[index]),
          );
        },
      ),
    );
  }

  // Confirm deletion of service request
  void _confirmDelete(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Request'),
        content: const Text('Are you sure you want to delete this request?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<FirestoreService>(context, listen: false)
                    .deleteServiceRequest(requestId);
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              } catch (e) {
                print('Error deleting request: $e');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
