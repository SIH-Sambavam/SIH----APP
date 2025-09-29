import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../fish_data_model.dart';
import '../widgets/mapbox_map_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late WaterQuality waterQuality;

  @override
  void initState() {
    super.initState();
    waterQuality = WaterQuality.getSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlueGuard Dashboard'),
        backgroundColor: const Color(0xFF005A7C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Marine Guardian!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005A7C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Protecting our oceans with AI-powered monitoring.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildWaterQualityCard(),
            const SizedBox(height: 16),
            _buildMarineMonitoringMap(),
            const SizedBox(height: 16),
            _buildQuickActionsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterQualityCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.waves, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Water Quality',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQualityMetric(
                    'Temperature',
                    '${waterQuality.temperature.toStringAsFixed(1)}°C',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQualityMetric(
                    'pH Level',
                    waterQuality.pH.toStringAsFixed(1),
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityMetric(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.speed, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildActionButton(
                    'Report Sighting', Icons.camera_alt, Colors.green),
                _buildActionButton(
                    'Emergency Alert', Icons.emergency, Colors.red),
                _buildActionButton('Water Test', Icons.water_drop, Colors.blue),
                _buildActionButton(
                    'AI Analysis', Icons.psychology, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title feature coming soon!')),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarineMonitoringMap() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.map, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Marine Monitoring Locations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? _buildWebMapPlaceholder()
                    : MapboxMapWidget(
                        latitude: 20.5937,
                        longitude: 78.9629,
                        zoom: 6.0,
                        markers: [
                          MapboxMarker(
                            latitude: 9.9312,
                            longitude: 76.2673,
                            title: 'Kochi Marine Station - Water Quality: Good',
                          ),
                          MapboxMarker(
                            latitude: 19.0760,
                            longitude: 72.8777,
                            title: 'Mumbai Marine Center - Active Monitoring',
                          ),
                          MapboxMarker(
                            latitude: 13.0827,
                            longitude: 80.2707,
                            title:
                                'Chennai Research Station - Fish Population: Stable',
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Showing 3 active monitoring stations across Indian coastal waters',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebMapPlaceholder() {
    return Container(
      color: Colors.blue[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 40,
            color: Colors.blue[300],
          ),
          const SizedBox(height: 12),
          Text(
            'Marine Monitoring Stations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Interactive map available on mobile devices',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStationCard('Kochi', 'Good', Colors.green),
              _buildStationCard('Mumbai', 'Active', Colors.blue),
              _buildStationCard('Chennai', 'Stable', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStationCard(String name, String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: color, size: 16),
          const SizedBox(height: 2),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: color,
            ),
          ),
          Text(
            status,
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
