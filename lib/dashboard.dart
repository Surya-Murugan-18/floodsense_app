import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:uiflood/map.dart';
import 'package:uiflood/alert.dart';
import 'package:uiflood/profile.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flood Monitoring Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SF Pro Display',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  double _waterLevel = 1.0; // Initial Water Level
  String _floodRiskLevel = 'LOW RISK';
  Color _riskColor = Colors.green;
  double _progressValue = 0.15;


  // Weather Variables
  String location = "Chennai";
  double temperature = 24.0;
  String condition = "Partly Cloudy";
  int humidity = 65;
  double windSpeed = 12.0;
  double rainChance = 30.0;


  @override
  void initState() {
    super.initState();
    _startWaterLevelUpdates();
    _fetchWeatherData();
  }

  void _startWaterLevelUpdates() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _waterLevel = (_waterLevel + 0.2) % 4.5; // Update dynamically
        _updateFloodRisk();
      });
    });
  }

  void _updateFloodRisk() {
    if (_waterLevel < 2.0) {
      _floodRiskLevel = 'LOW RISK';
      _riskColor = Colors.green;
      _progressValue = 0.15;
    } else if (_waterLevel < 3.5) {
      _floodRiskLevel = 'MODERATE RISK';
      _riskColor = Colors.orange;
      _progressValue = 0.5;
    } else {
      _floodRiskLevel = 'HIGH RISK';
      _riskColor = Colors.red;
      _progressValue = 0.85;
    }
  }
  

  Future<void> _fetchWeatherData() async {
    final apiKey = '75d756bab73f1670470fddb041740183'; // Replace with your OpenWeather API Key
    final city = "Chennai"; // You can make this dynamic
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data['main']['temp'].toDouble();
          condition = data['weather'][0]['description'];
          humidity = data['main']['humidity'].toInt();
          windSpeed = data['wind']['speed'].toDouble();
          rainChance = (data['rain'] != null) ? data['rain']['1h'] ?? 0.0 : 0.0;
        });
      } else {
        print("Failed to load weather data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }
  
  final String floodRiskLevel = 'LOW RISK';
  
  final List<FlSpot> waterLevelSpots = [
    FlSpot(0, 1.9),
    FlSpot(4, 1.8),
    FlSpot(8, 2.2),
    FlSpot(12, 2.0),
    FlSpot(16, 2.3),
    FlSpot(20, 2.1),
    FlSpot(24, 2.0),
  ];
  
  final List<Map<String, dynamic>> waterPredictions = [
    {'level': 2.8, 'time': '+1h'},
    {'level': 3.1, 'time': '+2h'},
    {'level': 3.4, 'time': '+3h'},
    {'level': 3.2, 'time': '+4h'},
  ];
  
  final List<Map<String, dynamic>> nearbyVolunteers = [
    {
      'name': 'John Smith',
      'distance': 0.5,
      'image': 'assets/-1.png',
    },
    {
      'name': 'Sarah Wilson',
      'distance': 0.8,
      'image': 'assets/-1.png',
    },

    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildLocationBar(),
                const SizedBox(height: 16),
                _buildWeatherCard(),
                const SizedBox(height: 20),
                _buildFloodRiskSection(),
                const SizedBox(height: 20),
                _buildWaterLevelTrendsSection(),
                const SizedBox(height: 30),
                _buildWaterLevelPredictionSection(),
                const SizedBox(height: 30),
                _buildNearbyVolunteersSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            onPressed: () {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlertsScreen()), // Navigate to alert.dart
        );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBar() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 18,
          color: Colors.black54,
        ),
        const SizedBox(width: 4),
        Text(
          'Current Location: $location',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF4A90E2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Icon(Icons.cloud, color: Colors.white, size: 48),
            ],
          ),
          Text(
            condition.toUpperCase(),
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherInfoItem(Icons.water_drop_outlined, 'Humidity', '$humidity%'),
              _buildWeatherInfoItem(Icons.air, 'Wind', '${windSpeed.toStringAsFixed(1)} km/h'),
              _buildWeatherInfoItem(Icons.umbrella_outlined, 'Rain', '${rainChance.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildWeatherInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
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
                color: _riskColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _floodRiskLevel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _riskColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progressValue,
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(_riskColor),
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

  Widget _buildWaterLevelTrendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catchment Area',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 0.65,
                verticalInterval: 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[200],
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[200],
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 4,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      if (value == 0) {
                        text = '00:00';
                      } else if (value == 4) {
                        text = '04:00';
                      } else if (value == 8) {
                        text = '08:00';
                      } else if (value == 12) {
                        text = '12:00';
                      } else if (value == 16) {
                        text = '16:00';
                      } else if (value == 20) {
                        text = '20:00';
                      } else if (value == 24) {
                        text = '24:00';
                      }
                      return Text(
                        text,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.65,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      if (value == 0) {
                        text = '0';
                      } else if (value.toStringAsFixed(2) == '0.65') {
                        text = '0.65';
                      } else if (value.toStringAsFixed(2) == '1.30') {
                        text = '1.3';
                      } else if (value.toStringAsFixed(2) == '1.95') {
                        text = '1.95';
                      } else if (value.toStringAsFixed(1) == '2.6') {
                        text = '2.6';
                      }
                      return Text(
                        text,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              minX: 0,
              maxX: 24,
              minY: 0,
              maxY: 2.6,
              lineBarsData: [
                LineChartBarData(
                  spots: waterLevelSpots,
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF4A90E2),
                    ],
                  ),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A90E2).withOpacity(0.3),
                        const Color(0xFF4A90E2).withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterLevelPredictionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Water Level Prediction',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  waterPredictions.length,
                  (index) => _buildPredictionItem(
                    waterPredictions[index]['level'],
                    index,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${index + 1}h',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPredictionItem(double level, int index) {
    // Calculate height based on the level (higher level = taller bar)
    final double height = 60.0 * (level / 4.0); // Normalize to max height
    
    return Column(
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${level.toStringAsFixed(1)} m',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyVolunteersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Contacts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: nearbyVolunteers
                .map((volunteer) => Expanded(
                      child: _buildVolunteerItem(
                        volunteer['name'],
                        volunteer['distance'],
                        volunteer['image'],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteerItem(String name, double distance, String imageUrl) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$distance km',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
       Center(
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF007AFF),
      foregroundColor: Colors.white,
      minimumSize: const Size(150, 40), // Set a fixed width instead of infinity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: const Text('Call'),
  ),
)

      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
    if (index == 1) {  // Assuming 'Map' is at index 1
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FloodMapScreen()),
      );
    }
     else if (index == 2) {  // Assuming 'Map' is at index 2
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
    
     else {
      setState(() {
        _selectedIndex = index;
      });
    }
  },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF007AFF),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
       
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}


