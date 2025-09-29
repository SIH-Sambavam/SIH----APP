import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxMapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double zoom;
  final List<MapboxMarker>? markers;

  const MapboxMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.zoom = 2.0,
    this.markers,
  });

  @override
  State<MapboxMapWidget> createState() => _MapboxMapWidgetState();
}

class _MapboxMapWidgetState extends State<MapboxMapWidget> {
  MapboxMap? _mapboxMap;
  String? _mapboxAccessToken;

  @override
  void initState() {
    super.initState();
    _mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    if (_mapboxAccessToken == null) {
      debugPrint('Mapbox access token not found in environment variables');
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _addMarkers();
  }

  void _addMarkers() {
    if (_mapboxMap != null && widget.markers != null) {
      for (var marker in widget.markers!) {
        _mapboxMap!.annotations.createPointAnnotationManager().then((manager) {
          manager.create(PointAnnotationOptions(
            geometry: {
              "type": "Point",
              "coordinates": [marker.longitude, marker.latitude]
            },
            textField: marker.title,
            textSize: 12.0,
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mapboxAccessToken == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Mapbox token not configured',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MapWidget(
      key: ValueKey(_mapboxAccessToken),
      cameraOptions: CameraOptions(
        center: {
          "type": "Point",
          "coordinates": [
            widget.longitude ?? 0.0,
            widget.latitude ?? 0.0,
          ]
        },
        zoom: widget.zoom,
      ),
      styleUri: MapboxStyles.MAPBOX_STREETS,
      textureView: true,
      onMapCreated: _onMapCreated,
    );
  }
}

class MapboxMarker {
  final double latitude;
  final double longitude;
  final String title;
  final String? iconImage;

  MapboxMarker({
    required this.latitude,
    required this.longitude,
    required this.title,
    this.iconImage,
  });
}
