import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
      title: 'Nearby Shelters',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const NearbySheltersScreen(),
    );
  }
}

// Shelter Model
class Shelter {
  final String name;
  final double distance;
  final int availableBeds;
  final int totalBeds;
  final List<String> amenities;
  final String address;
  final LatLng location;

  Shelter({
    required this.name,
    required this.distance,
    required this.availableBeds,
    required this.totalBeds,
    required this.amenities,
    required this.address,
    required this.location,
  });

  bool get isAvailable => availableBeds > 0;
}

// Shelter Service
class ShelterService {
  Future<List<Shelter>> getNearbyShelters() async {
    // In a real app, this would fetch data from an API
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Shelter(
        name: 'Central High School',
        distance: 2.5,
        availableBeds: 50,
        totalBeds: 200,
        amenities: ['Food', 'Water', 'Medical', 'Restroom'],
        address: '123 Main Street, Downtown Area',
        location: LatLng(40.7128, -74.0060), // New York coordinates as example
      ),
      Shelter(
        name: 'Community Center',
        distance: 3.8,
        availableBeds: 0,
        totalBeds: 150,
        amenities: ['Food', 'Water', 'Restroom'],
        address: '456 Park Road, Westside',
        location: LatLng(40.7282, -73.9942), // Slightly different coordinates
      ),
      Shelter(
        name: 'Sports Complex',
        distance: 4.2,
        availableBeds: 120,
        totalBeds: 300,
        amenities: ['Food', 'Water', 'Medical', 'Restroom'],
        address: '789 Stadium Drive, Eastside',
        location: LatLng(40.7021, -74.0137), // Another nearby location
      ),
    ];
  }

  Future<List<Shelter>> filterShelters(String filter) async {
    final shelters = await getNearbyShelters();
    
    switch (filter) {
      case 'Nearest':
        return shelters..sort((a, b) => a.distance.compareTo(b.distance));
      case 'Available Beds':
        return shelters..sort((a, b) => b.availableBeds.compareTo(a.availableBeds));
      case 'Medical Aid':
        return shelters.where((shelter) => shelter.amenities.contains('Medical')).toList();
      default:
        return shelters;
    }
  }
}

class NearbySheltersScreen extends StatefulWidget {
  const NearbySheltersScreen({Key? key}) : super(key: key);

  @override
  State<NearbySheltersScreen> createState() => _NearbySheltersScreenState();
}

class _NearbySheltersScreenState extends State<NearbySheltersScreen> {
  final ShelterService _shelterService = ShelterService();
  List<Shelter> shelters = [];
  bool isLoading = true;
  String selectedFilter = 'Nearest';
  final List<String> filters = ['Nearest', 'Available Beds', 'Medical Aid', 'Food'];

  @override
  void initState() {
    super.initState();
    _loadShelters();
  }

  Future<void> _loadShelters() async {
    setState(() {
      isLoading = true;
    });
    
    final loadedShelters = await _shelterService.filterShelters(selectedFilter);
    
    setState(() {
      shelters = loadedShelters;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(),
        title: const Text('Nearby Shelters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: _loadShelters,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search shelters by area or name',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedFilter == filters[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(filters[index]),
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filters[index];
                            _loadShelters();
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.blue : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: shelters.length,
              itemBuilder: (context, index) {
                final shelter = shelters[index];
                final isAvailable = shelter.availableBeds > 0;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shelter.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${shelter.distance} km',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available: ${shelter.availableBeds} / ${shelter.totalBeds} beds',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            for (final amenity in shelter.amenities)
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      _getAmenityIcon(amenity),
                                      color: Colors.blueGrey[700],
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      amenity,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueGrey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                shelter.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: shelter.location,
                            initialZoom: 14.0,
                          //  interactiveFlags: InteractiveFlag.none,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: shelter.location,
                                  width: 40,
                                  height: 40,
                                  child: const Icon( // 🔹 Use 'child' instead of 'builder'
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                 ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.directions),
                                label: const Text('Get Directions'),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.call),
                                label: const Text('Call Coordinator'),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < shelters.length - 1) const Divider(height: 32),
                    ],
                  ),
                );
              },
            ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity) {
      case 'Food':
        return Icons.restaurant;
      case 'Water':
        return Icons.water_drop;
      case 'Medical':
        return Icons.medical_services;
      case 'Restroom':
        return Icons.wc;
      default:
        return Icons.help_outline;
    }
  }
}