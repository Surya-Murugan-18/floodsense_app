import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class TamilNaduMap extends StatefulWidget {
  @override
  _TamilNaduMapState createState() => _TamilNaduMapState();
}

class _TamilNaduMapState extends State<TamilNaduMap> {
  bool isLoading = true;
  List<Polygon> floodPolygons = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      String geoJsonStr = await rootBundle.loadString('assets/tamilnadu_districts.geojson');
      Map<String, dynamic> geoJsonMap = jsonDecode(geoJsonStr);

      List<dynamic> features = geoJsonMap['features'];

      floodPolygons = features.map((feature) {
        List<dynamic> coordinates = feature['geometry']['coordinates'][0]; // Assuming Polygon type
        String floodRisk = feature['properties']['flood_risk'] ?? 'low';

        // Convert coordinates to LatLng format
        List<LatLng> latLngPoints = coordinates.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]); // GeoJSON format [lng, lat]
        }).toList();

        // Determine color based on flood risk
        Color floodColor;
        switch (floodRisk.toLowerCase()) {
          case 'high':
            floodColor = Colors.red.withOpacity(0.7);
            break;
          case 'medium':
            floodColor = Colors.yellow.withOpacity(0.7);
            break;
          default:
            floodColor = Colors.green.withOpacity(0.7);
        }

        return Polygon(
          points: latLngPoints,
          color: floodColor,
          borderColor: Colors.black,
          borderStrokeWidth: 2.0,
        );
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading GeoJSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Tamil Nadu Flood Risk Map")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(10.7905, 78.7047), // Tamil Nadu Center
                  initialZoom: 7.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  PolygonLayer(polygons: floodPolygons),
                ],
              ),
      ),
    );
  }
}

void main() {
  runApp(TamilNaduMap());
}
