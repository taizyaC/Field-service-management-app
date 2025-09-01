import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Service Requests Overview', style: TextStyle(fontSize: 20)),
            SizedBox(height: 200, child: _buildPieChart()),
            SizedBox(height: 200, child: _buildBarChart()), 
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
        currentIndex: 2, // Set 'Service Requests' as the active tab
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
              // Stay on the current screen
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(sections: [
        PieChartSectionData(value: 40, title: 'Completed', color: Colors.green),
        PieChartSectionData(value: 30, title: 'In Progress', color: Colors.orange),
        PieChartSectionData(value: 30, title: 'Pending', color: Colors.red),
      ]),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8, color: Colors.orange)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: Colors.red)]),
        ],
      ),
    );
  }
}
