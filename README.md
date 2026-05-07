# FloodSense - ( Intelligent Monitoring and Rescue Coordination System )

FloodSense is a Flutter-based flood monitoring and emergency response application System.
It combines risk visualization, route guidance, shelter discovery, alerts and community volunteer coordination into a single mobile-first experience.

## Project Status

Current state: prototype / MVP in active development.

Implemented:
- Dashboard with dynamic flood risk indicator and water-level trends
- Live weather fetch from OpenWeather API
- Flood map and route-related screens using OpenStreetMap tiles
- Alert center, profile screen, shelter listing and volunteer network views
- Multi-platform Flutter project targets (Android, iOS, Web, Desktop)

Not yet production-ready:
- Centralized state management across all modules
- Secure secret handling for API keys
- Full backend integration for shelters, volunteers and alerts
- Reliable automated test coverage

## Core Features

1. Flood Risk Dashboard
- Dynamic flood risk level (low, moderate, high) based on simulated water levels
- Visual trend chart and near-term prediction bars
- Weather snapshot (temperature, humidity, wind, rain) via API call

2. Flood Map and Navigation
- Interactive map rendering with OpenStreetMap tiles
- Safe route screen with recommended path, alternatives and risk warning block
- Travel mode and voice guidance toggles in route UI

3. Alerts and Emergency Information
- Real-time style alert cards
- AI prediction-style warning panel UI
- Government/community warning list and emergency guideline checklist

4. Nearby Shelters
- Shelter listing with distance, bed availability, amenities and mini map preview
- Filter chips for nearest, available beds and medical aid

5. Volunteer Network
- Volunteer availability cards with skills and contact actions
- Emergency chat UI block
- Volunteer map markers and call-to-action panel

6. User Profile Module
- User identity and contact panel
- Notification and settings toggles
- Activity history and logout flow scaffold

## Tech Stack

- Framework: Flutter (Dart)
- Maps: flutter_map, latlong2, flutter_map_geojson, vector_map_tiles
- Charts: fl_chart
- Networking: http
- Location: geolocator, geocoding
- UI utilities: intl, google_fonts, font_awesome_flutter
- State tooling available: provider 

See dependency declarations in pubspec.yaml.

## Project Structure

Main source files are under lib:

- lib/main.dart: current primary entry file (Safe Route focused UI)
- lib/dashboard.dart: dashboard app shell, weather call, charting and bottom navigation
- lib/map.dart: flood map screen and navigation to route/shelter/volunteer modules
- lib/alert.dart: emergency alerts and warnings UI
- lib/saferoute.dart: detailed safe-route experience with map markers/polygons
- lib/shelter.dart: shelter listing, filters and mini-map cards
- lib/volunteer.dart: volunteer network map and support cards
- lib/profile.dart: profile/settings/activity screens

Asset data:
- assets/tamilnadu_districts.geojson

## How To Run

Prerequisites:
- Flutter SDK installed and configured
- A connected emulator/device or desktop/web target

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Optional target examples:

```bash
flutter run -d chrome
flutter run -d windows
```

## Development Commands

```bash
flutter analyze
flutter test
```

