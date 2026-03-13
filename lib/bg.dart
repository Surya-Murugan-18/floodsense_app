import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _waterLevel = 0.2; // Initial water level (20%)

  @override
  void initState() {
    super.initState();
    _simulateWaterLevelChanges(); // Start automatic water level updates
  }

  void _simulateWaterLevelChanges() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _waterLevel += (0.1 * (DateTime.now().second % 2 == 0 ? 1 : -1));
        _waterLevel = _waterLevel.clamp(0.0, 1.0); // Keep within range
      });
    });
  }

  // Get risk color based on water level
  Color _getRiskColor() {
    if (_waterLevel <= 0.4) return const Color(0xFF4CAF50); // Green (Low Risk)
    if (_waterLevel <= 0.7) return Colors.orange; // Medium Risk
    return Colors.red; // High Risk
  }

  // Get risk level text
  String _getRiskText() {
    if (_waterLevel <= 0.4) return "Low Risk";
    if (_waterLevel <= 0.7) return "Moderate Risk";
    return "High Risk";
  }

  Widget _buildFloodRiskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Flood Risk Level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getRiskColor().withOpacity(0.1), // Adjust background color
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _getRiskText(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getRiskColor(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _waterLevel,
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(_getRiskColor()),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Low',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              'Moderate',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              'High',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flood Risk Monitoring"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildFloodRiskSection(), // Use modified flood risk UI
        ),
      ),
    );
  }
}
