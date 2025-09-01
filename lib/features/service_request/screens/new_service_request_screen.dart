import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase

class NewServiceRequestScreen extends StatefulWidget {
  const NewServiceRequestScreen({super.key});

  @override
  _NewServiceRequestScreenState createState() => _NewServiceRequestScreenState();
}

class _NewServiceRequestScreenState extends State<NewServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String _clientName = '';
  String _serviceDescription = '';
  String _category = 'Electrical'; // Default category
  final List<String> _categories = ['Electrical', 'Plumbing', 'IT Support', 'HVAC', 'Carpentry'];
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  LocationData? _currentLocation;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final Location _location = Location();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  int _selectedIndex = 0; // Index for Bottom Navigation Bar

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _fetchLocation();
  }

  Future<void> _requestPermissions() async {
    await [Permission.location, Permission.camera].request();
  }

  Future<void> _fetchLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      var location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });
    } else {
      print('Location permission not granted');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = pickedImage;
      });
    } else {
      print('Camera permission not granted');
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save data locally
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('clientName', _clientName);
      await prefs.setString('serviceDescription', _serviceDescription);
      await prefs.setString('category', _category);
      await prefs.setString('date', _selectedDate.toIso8601String());
      await prefs.setString('time', _selectedTime.format(context));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service Request Saved Locally and Syncing...'))
      );

      // Sync with Firebase
      await _syncWithFirebase();

      // Close the form after saving
      Navigator.pop(context);
    }
  }

  Future<void> _syncWithFirebase() async {
    final serviceRequestData = {
      'clientName': _clientName,
      'serviceDescription': _serviceDescription,
      'category': _category,
      'date': _selectedDate.toIso8601String(),
      'time': _selectedTime.format(context),
      'location': _currentLocation != null
          ? {'latitude': _currentLocation!.latitude, 'longitude': _currentLocation!.longitude}
          : null,
      'image': _image != null ? await _image!.readAsBytes() : null, // Convert image to bytes if available
    };

    try {
      await _firestore.collection('serviceRequests').add(serviceRequestData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service Request Synced with Firebase!'))
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Sync with Firebase: $error'))
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Service Request")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Client Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the client\'s name' : null,
                onSaved: (value) => _clientName = value!,
              ),
              const SizedBox(height: 16),

              // Service Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Service Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a description of the service' : null,
                onSaved: (value) => _serviceDescription = value!,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: Text("Service Date: ${_selectedDate.toLocal()}".split(' ')[0]), // Fix for showing selected date
                trailing: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ),
              const Divider(),

              // Time Picker
              ListTile(
                title: Text("Service Time: ${_selectedTime.format(context)}"),
                trailing: ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time'),
                ),
              ),
              const Divider(),

              // Location
              ListTile(
                title: Text(_currentLocation != null
                    ? 'Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}'
                    : 'Fetching location...'),
                trailing: ElevatedButton(
                  onPressed: _fetchLocation,
                  child: const Text('Refresh Location'),
                ),
              ),
              const Divider(),

              // Image Picker
              if (_image != null) Image.file(File(_image!.path)),
              ListTile(
                title: const Text('Capture Image'),
                trailing: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Open Camera'),
                ),
              ),
              const Divider(),

              // Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Service Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 1, // Set 'Service Requests' as the active tab
        onTap: (index) {
          // Handle navigation logic based on the selected index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              // Stay on the current screen
              break;
            case 2:
              Navigator.pushNamed(context, '/analytics');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
