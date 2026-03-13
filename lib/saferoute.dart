import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const SafeRouteScreen(),
    );
  }
}

class SafeRouteScreen extends StatefulWidget {
  const SafeRouteScreen({Key? key}) : super(key: key);

  @override
  State<SafeRouteScreen> createState() => _SafeRouteScreenState();
}

class _SafeRouteScreenState extends State<SafeRouteScreen> {
  bool voiceGuidanceEnabled = true;
  String selectedTravelMode = 'Walking';

  // Sample data - would come from your backend in a real app
  final Map<String, dynamic> recommendedRoute = {
    'duration': '12 min',
    'distance': '3.2 km',
    'path': 'Main Road → Bridge Street → XYZ School',
  };

  final List<Map<String, dynamic>> alternativeRoutes = [
    {
      'color': Colors.green,
      'path': 'Highland Ave → Central St → School',
      'duration': '15 min',
      'distance': '3.8 km',
    },
    {
      'color': Colors.amber,
      'path': 'Market St → Park Rd → School',
      'duration': '18 min',
      'distance': '4.1 km',
    },
    {
      'color': Colors.red,
      'path': 'River Rd → Bridge St → School',
      'duration': '10 min',
      'distance': '2.9 km',
    },
  ];

  final Map<String, dynamic> alert = {
    'title': 'High Water Level Alert',
    'message': 'ABC Road is currently experiencing flooding. Route has been adjusted for your safety.',
  };

  final Map<String, dynamic> nextTurn = {
    'instruction': 'Turn right in 500m onto Bridge Street',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMapSection(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRecommendedRouteSection(),
                          const SizedBox(height: 16),
                          if (alert.isNotEmpty) _buildAlertSection(),
                          const SizedBox(height: 24),
                          _buildAlternativeRoutesSection(),
                          const SizedBox(height: 24),
                          _buildTravelModeSection(),
                          const SizedBox(height: 16),
                          _buildVoiceGuidanceToggle(),
                          const SizedBox(height: 16),
                     //     _buildNextTurnSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion( // Prevents unwanted hover effect
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Go back to the previous screen
            },
            child: const Icon(Icons.arrow_back_ios, size: 20),
          ),
        ),
          const Text(
            'Safe Route',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle share button press
            },
            child: const Icon(Icons.ios_share, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
  return Container(
    height: 500,
    color: Colors.grey[200],
    child: FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(13.0827, 80.2707), // Chennai coordinates
        initialZoom: 13.0, // Zoom level
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        // Safe Route Labels with Custom Markers
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(13.0800, 80.2700), // Example location (safe route start)
              width: 80.0,
              height: 80.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 40,
                  ),
                  Text(
                    'Safe Route Start',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Marker(
              point: LatLng(13.0840, 80.2720), // Safe route point 2
              width: 80.0,
              height: 80.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 40,
                  ),
                  Text(
                    'Safe Route Point 2',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Marker(
              point: LatLng(13.0850, 80.2760), // Safe route point 3
              width: 80.0,
              height: 80.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 40,
                  ),
                  Text(
                    'Safe Route End',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Risk Areas (Polygon) - Optional for displaying risk zones
        PolygonLayer(
          polygons: [
            Polygon(
              points: [
                LatLng(13.0810, 80.2690), // Risk area boundary
                LatLng(13.0830, 80.2710),
                LatLng(13.0840, 80.2750),
                LatLng(13.0820, 80.2770),
              ],
              color: Colors.red.withOpacity(0.5), // Semi-transparent red for risk areas
              borderColor: Colors.red,
              borderStrokeWidth: 3.0,
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildRecommendedRouteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Safe Route',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              '${recommendedRoute['duration']} (${recommendedRoute['distance']})',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  recommendedRoute['path'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Start Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFE8B2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF9500),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'],
                  style: const TextStyle(
                    color: Color(0xFFFF3B30),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert['message'],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeRoutesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alternative Routes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...alternativeRoutes.map((route) => _buildAlternativeRouteItem(route)),
      ],
    );
  }

  Widget _buildAlternativeRouteItem(Map<String, dynamic> route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: route['color'],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route['path'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${route['duration']} • ${route['distance']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Mode',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTravelMode = 'Walking';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedTravelMode == 'Walking' ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_walk,
                        color: selectedTravelMode == 'Walking' ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Walking',
                        style: TextStyle(
                          color: selectedTravelMode == 'Walking' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTravelMode = 'Driving';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedTravelMode == 'Driving' ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: selectedTravelMode == 'Driving' ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Driving',
                        style: TextStyle(
                          color: selectedTravelMode == 'Driving' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceGuidanceToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.volume_up,
              color: Colors.blue[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Voice Guidance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        CupertinoSwitch(
          value: voiceGuidanceEnabled,
          activeColor: Colors.blue,
          onChanged: (value) {
            setState(() {
              voiceGuidanceEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBottomIndicator() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}

