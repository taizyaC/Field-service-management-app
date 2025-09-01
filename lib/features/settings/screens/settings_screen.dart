import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Preferences
  String _defaultCategory = 'Electrical';
  bool _notificationsEnabled = true;
  String _language = 'English';
  String _userName = 'John Doe';
  String _email = 'john@example.com';
  String _role = 'Technician';

  final List<String> _categories = ['Electrical', 'Plumbing', 'IT Support', 'HVAC', 'Carpentry'];
  final List<String> _languages = ['English', 'Spanish', 'French'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load preferences from local storage
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultCategory = prefs.getString('defaultCategory') ?? 'Electrical';
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _language = prefs.getString('language') ?? 'English';
      _userName = prefs.getString('userName') ?? 'John Doe';
      _email = prefs.getString('email') ?? 'john@example.com';
      _role = prefs.getString('role') ?? 'Technician';
    });
  }

  // Save preferences to local storage
  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultCategory', _defaultCategory);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setString('language', _language);
    await prefs.setString('userName', _userName);
    await prefs.setString('email', _email);
    await prefs.setString('role', _role);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  // Roles
  final List<String> _roles = ['Technician', 'Admin', 'Viewer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture Placeholder
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
              ),
            ),
            const SizedBox(height: 16),
            // Profile Information
            Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _userName,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                _userName = value;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _email,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(height: 20),

            // Role Selection
            Text('Role', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: InputDecoration(labelText: 'Role'),
              items: _roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Default Service Category
            Text('Service Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _defaultCategory,
              decoration: InputDecoration(labelText: 'Default Service Category'),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _defaultCategory = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Notification Settings
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Language Preferences
            Text('Language Preferences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _language,
              decoration: InputDecoration(labelText: 'Language'),
              items: _languages.map((language) {
                return DropdownMenuItem(value: language, child: Text(language));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save Settings'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
        currentIndex: 3, // Set 'Settings' as the active tab
        onTap: (index) {
          // Handle navigation logic based on the selected index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/new_service_request');
              break;
            case 2:
              Navigator.pushNamed(context, '/analytics');
              break;
            case 3:
              // Stay on the current screen
              break;
          }
        },
      ),
    );
  }
}
