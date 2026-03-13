import 'package:flutter/material.dart';
import 'package:uiflood/saferoute.dart';
import 'package:uiflood/shelter.dart';
import 'package:uiflood/volunteer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(FloodMapApp());
}

class FloodMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloodMapScreen(),
    );
  }
}

class FloodMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: Text(
          'Flood Map',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print("Voice search activated");
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.mic, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    hintText: "Search location",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Map Integration
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(13.0827, 80.2707), // Default location
                      initialZoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Info Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  infoCard("2.8m", "Water Level", Icons.water_drop, Colors.blue),
                  infoCard("Moderate", "Risk Level", Icons.warning, Colors.orange),
                  infoCard("4", "Shelters Nearby", Icons.house, Colors.green),
                ],
              ),
              SizedBox(height: 16),
              
              // Action Buttons with spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  actionButton("Safe Routes", Icons.route, Colors.green, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SafeRouteScreen()),
                    );
                  }),
                  SizedBox(width: 12),
                  actionButton("Shelters", Icons.home, Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NearbySheltersScreen()),
                    );
                  }),
                  SizedBox(width: 12),
                  actionButton("Volunteers", Icons.volunteer_activism, Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VolunteerNetworkScreen()),
                    );
                  }),
                ],
              ),
              SizedBox(height: 20),
              
              // Water Level Prediction
              Text(
                "Water Level Prediction",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  graphBar("2.8m", "+1h"),
                  graphBar("3.1m", "+2h"),
                  graphBar("3.4m", "+3h"),
                  graphBar("3.2m", "+4h"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget infoCard(String value, String label, IconData icon, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 30),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget actionButton(String label, IconData icon, Color bgColor, VoidCallback onPressed) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Move the graphBar function inside the class
  Widget graphBar(String height, String time) {
    return Column(
      children: [
        Container(
          width: 30,
          height: double.parse(height.substring(0, 3)) * 10,
          color: Colors.blue[900],
        ),
        SizedBox(height: 4),
        Text(height, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 14, color: Colors.grey),
            SizedBox(width: 4),
            Text(time, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  