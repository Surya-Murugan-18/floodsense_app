import 'package:flutter/material.dart';
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
      
      title: 'Volunteer Network',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const VolunteerNetworkScreen(),
      
    );
  }
}

class VolunteerNetworkScreen extends StatelessWidget {
  const VolunteerNetworkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                       Navigator.pop(context); 
                    },
                  ),
                  const Text(
                    'Volunteer Network',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Map View
           SizedBox(
  height: 350,
  child: FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(13.0827, 80.2707),  // Coordinates for Chennai
      initialZoom: 13.0,  // Zoom level adjusted for Chennai
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
      ),
     MarkerLayer(
        markers: [
          Marker(
            point: LatLng(13.0827, 80.2707),  // Place the volunteer at Chennai coordinates (or any other location)
            width: 80.0,
            height: 80.0,
            child: const Icon(
              Icons.person_pin,  // Volunteer icon (you can use any icon or custom image)
              color: Colors.blue,  // Change icon color if needed
              size: 40.0,  // Icon size
            ),
          ),

Marker(
            point: LatLng(13.0900, 80.2707),  // Place the volunteer at Chennai coordinates (or any other location)
            width: 80.0,
            height: 80.0,
            child: const Icon(
              Icons.person_pin,  // Volunteer icon (you can use any icon or custom image)
              color: Colors.blue,  // Change icon color if needed
              size: 40.0,  // Icon size
            ),
          ),




Marker(
            point: LatLng(13.1000, 80.2707),  // Place the volunteer at Chennai coordinates (or any other location)
            width: 80.0,
            height: 80.0,
            child: const Icon(
              Icons.person_pin,  // Volunteer icon (you can use any icon or custom image)
              color: Colors.blue,  // Change icon color if needed
              size: 40.0,  // Icon size
            ),
          ),

          

        ],
      ),
    ],
  ),
),


            
            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  // Nearby Volunteers Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby Volunteers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '5 Available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Volunteer Cards
                  VolunteerCard(
                    name: 'Sarah Wilson',
                    distance: 1.2,
                    rating: 4.8,
                    helps: 32,
                    image: 'assets/-1.png',
                    skills: const ['Medical', 'Transport'],
                    isOnline: true,
                  ),
                  
                  VolunteerCard(
                    name: 'Michael Chen',
                    distance: 2.5,
                    rating: 4.8,
                    helps: 32,
                    image: 'assets/-1.png',
                    skills: const ['Medical', 'Rescue'],
                    isOnline: false,
                  ),
                  
                  VolunteerCard(
                    name: 'Emma Davis',
                    distance: 3.0,
                    rating: 4.8,
                    helps: 32,
                    image: 'assets/-1.png',
                    skills: const ['Transport', 'Supplies'],
                    isOnline: true,
                  ),
                  
                  // Emergency Chat Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Emergency Chat',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '2 new',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Please bring a rescue boat, my house is submerged.',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type your message...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send ,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Join Network Section
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Join Our Volunteer Network',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Make a difference in your community. Join our network of dedicated volunteers.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
Center(
  child: SizedBox(
    width: 550, // Set width explicitly
    height: 50, // Set height explicitly
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Sign Up as Volunteer',
        style: TextStyle(
          fontSize: 20, // Slightly increased font size
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VolunteerCard extends StatelessWidget {
  final String name;
  final double distance;
  final double rating;
  final int helps;
  final String image;
  final List<String> skills;
  final bool isOnline;

  const VolunteerCard({
    Key? key,
    required this.name,
    required this.distance,
    required this.rating,
    required this.helps,
    required this.image,
    required this.skills,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image with Online Indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(image),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              
              // Volunteer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$distance km away',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($helps helps)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Request Help Button
             SizedBox(
  width: 140, // Adjust width as needed
  height: 40, // Adjust height as needed
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(12), // Keep it rectangular
    ),
    child: TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Increased padding
        minimumSize: Size(100, 30), // Set minimum size
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Keep it rectangular
        ),
      ),
      child: Text(
        'Request Help',
        style: TextStyle(
          fontSize: 16, // Increased font size
          color: Colors.blue[600],
        ),
      ),
    ),
  ),
),

            ],
          ),
          
          const SizedBox(height: 12),
          
          // Skills and Contact Button
          Row(
            children: [
              // Skills
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: skills.map((skill) {
                    Color skillColor;
                    if (skill == 'Medical') {
                      skillColor = Colors.blue;
                    } else if (skill == 'Transport') {
                      skillColor = Colors.cyan;
                    } else if (skill == 'Rescue') {
                      skillColor = Colors.orange;
                    } else {
                      skillColor = Colors.purple;
                    }
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: skillColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: skillColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Contact Button
              ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // No rounded corners
    ),
    minimumSize: const Size(140, 40), // Adjust button size
  ),
  child: const Text(
    'Contact',
    style: TextStyle(
      fontSize: 14, // Slightly increased for better visibility
      fontWeight: FontWeight.w500,
      color: Colors.white, // Text in white
    ),
  ),
),

            ],
          ),
        ],
      ),
    );
  }
}