import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double zoom;
  final List<MarkerData>? markers;

  const GoogleMapsWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.zoom = 6.0,
    this.markers,
  });

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    if (widget.markers != null) {
      _markers = widget.markers!.map((markerData) {
        return Marker(
          markerId: MarkerId(markerData.id),
          position: LatLng(markerData.latitude, markerData.longitude),
          infoWindow: InfoWindow(
            title: markerData.title,
            snippet: markerData.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            markerData.color == 'green'
                ? BitmapDescriptor.hueGreen
                : markerData.color == 'red'
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueBlue,
          ),
        );
      }).toSet();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.blue.shade50,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading map...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        color: Colors.red.shade50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _initializeMarkers();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.latitude ?? 20.5937,
          widget.longitude ?? 78.9629,
        ),
        zoom: widget.zoom,
      ),
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        try {
          _controller = controller;
          debugPrint('Google Maps initialized successfully');
        } catch (e) {
          setState(() {
            _errorMessage = 'Failed to initialize map: $e';
          });
        }
      },
      mapType: MapType.hybrid,
      compassEnabled: true,
      mapToolbarEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
    );
  }
}

class MarkerData {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final String color;

  MarkerData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    this.color = 'blue',
  });
}
