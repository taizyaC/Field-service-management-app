import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection reference for service requests
  CollectionReference get _serviceRequests => _db.collection('serviceRequests');

  // Fetch all service requests
  Stream<List<ServiceRequest>> fetchServiceRequests() {
    return _serviceRequests.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ServiceRequest.fromFirestore(doc))
        .toList());
  }
  

  // Add a new service request
  Future<void> createServiceRequest(ServiceRequest request) async {
    await _serviceRequests.add(request.toJson());
  }

  // Update an existing service request
  Future<void> updateServiceRequest(ServiceRequest request) async {
    await _serviceRequests.doc(request.id).update(request.toJson());
  }

  // Delete a service request
  Future<void> deleteServiceRequest(String requestId) async {
    await _serviceRequests.doc(requestId).delete();
  }
}
