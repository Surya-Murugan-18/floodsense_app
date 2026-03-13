import 'package:flutter/material.dart';

void main() {
  runApp(SafeRouteApp());
}

class SafeRouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeRouteScreen(),
    );
  }
}

class SafeRouteScreen extends StatefulWidget {
  @override
  _SafeRouteScreenState createState() => _SafeRouteScreenState();
}

class _SafeRouteScreenState extends State<SafeRouteScreen> {
  bool isWalkingSelected = true;
  bool isVoiceGuidanceEnabled = true;
  int selectedRouteIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Safe Route',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder
            Container(
              height: 250,
              color: Colors.grey[300],
              child: Center(child: Text("Map Placeholder")),
            ),
            SizedBox(height: 16),

            // Recommended Safe Route
            Text("Recommended Safe Route",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 16),
            Row(children: [Icon(Icons.access_time, color: Colors.grey), SizedBox(width: 6), Text("12 min (3.2 km)")]),
            SizedBox(height: 16),

            // Start Navigation Button
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("    Main Road → Bridge Street → XYZ School",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Start Navigation Action
                      print("Navigation Started...");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text("Start Navigation",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // High Water Level Alert
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.yellow, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "High Water Level Alert\n",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize:16),
        ),

TextSpan(
          text: "\n", // Adding space between lines
        ),

        TextSpan(
          text: "ABC Road is currently experiencing flooding. Route has been adjusted for your safety.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
        ),
      ],
    ),
  ),
)

                ],
              ),
            ),
            SizedBox(height: 16),

            // Alternative Routes
            Text("Alternative Routes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            alternativeRoute(0, "Highland Ave → Central St → School", "15 min • 3.8 km", Colors.green),
            alternativeRoute(1, "Market St → Park Rd → School", "18 min • 4.1 km", Colors.yellow),
            alternativeRoute(2, "River Rd → Bridge St → School", "10 min • 2.9 km", Colors.red),
            SizedBox(height: 16),

            // Travel Mode
            Text("Travel Mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 3),
            Row(
              children: [
                modeButton("Walking", Icons.directions_walk, isWalkingSelected, () {
                  setState(() => isWalkingSelected = true);
                }),
                SizedBox(width: 8),
                modeButton("Vehicle", Icons.directions_car, !isWalkingSelected, () {
                  setState(() => isWalkingSelected = false);
                }),
              ],
            ),
            SizedBox(height: 16),

            // Voice Guidance
            Row(
              children: [
                Icon(Icons.volume_up, color: Colors.blue),
                SizedBox(width: 8),
                Text("Voice Guidance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                Spacer(),
                Switch(
                  value: isVoiceGuidanceEnabled,
                  activeColor: Colors.lightBlue,
                  onChanged: (val) {
                    setState(() {
                      isVoiceGuidanceEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget alternativeRoute(int index, String route, String time, Color indicatorColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRouteIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: selectedRouteIndex == index ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 4),
                  Text(time, style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget modeButton(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() {}),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.black),
                SizedBox(height: 4),
                Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
