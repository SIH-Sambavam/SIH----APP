import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMapbox();
  }

  Future<void> _initializeMapbox() async {
    try {
      _mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];

      debugPrint('Mapbox Initialization:');
      debugPrint('- Platform: ${defaultTargetPlatform.name}');
      debugPrint('- Dotenv loaded: ${dotenv.env.isNotEmpty}');
      debugPrint('- Token length: ${_mapboxAccessToken?.length ?? 0}');

      if (_mapboxAccessToken == null || _mapboxAccessToken!.isEmpty) {
        setState(() {
          _errorMessage = 'Mapbox access token not found';
          _isLoading = false;
        });
        return;
      }

      // Set access token for Mapbox
      MapboxOptions.setAccessToken(_mapboxAccessToken!);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Mapbox initialization error: $e');
      setState(() {
        _errorMessage = 'Failed to initialize Mapbox: $e';
        _isLoading = false;
      });
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
            geometry:
                Point(coordinates: Position(marker.longitude, marker.latitude)),
            textField: marker.title,
            textSize: 12.0,
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while initializing
    if (_isLoading) {
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
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading map...',
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

    // Show error message if initialization failed
    if (_errorMessage != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.red.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _initializeMapbox();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show fallback if no token
    if (_mapboxAccessToken == null || _mapboxAccessToken!.isEmpty) {
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
        center: Point(
          coordinates: Position(
            widget.longitude ?? 0.0,
            widget.latitude ?? 0.0,
          ),
        ),
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
