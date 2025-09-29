import 'package:flutter/material.dart';
import '../widgets/mapbox_map_widget.dart';

class MapTestScreen extends StatelessWidget {
  const MapTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox Test'),
        backgroundColor: const Color(0xFF005A7C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Testing Mapbox Integration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MapboxMapWidget(
                    latitude: 19.0760, // Mumbai
                    longitude: 72.8777,
                    zoom: 10.0,
                    markers: [
                      MapboxMarker(
                        latitude: 19.0760,
                        longitude: 72.8777,
                        title: 'Mumbai - Marine Research Center',
                      ),
                      MapboxMarker(
                        latitude: 19.1136,
                        longitude: 72.8697,
                        title: 'Bandra - Fish Market',
                      ),
                      MapboxMarker(
                        latitude: 18.9220,
                        longitude: 72.8347,
                        title: 'Colaba - Fishing Port',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Map shows Mumbai coastal areas with marine research locations.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
