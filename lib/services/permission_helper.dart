import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<void> requestRequiredPermissions(BuildContext context) async {
    try {
      // List of permissions needed for the app
      final permissions = [
        Permission.location,
        Permission.locationWhenInUse,
        Permission.camera,
        Permission.microphone,
      ];

      // Check which permissions are not granted
      final Map<Permission, PermissionStatus> statuses = {};
      for (final permission in permissions) {
        statuses[permission] = await permission.status;
      }

      // Filter permissions that need to be requested
      final permissionsToRequest = statuses.entries
          .where((entry) =>
              entry.value == PermissionStatus.denied ||
              entry.value == PermissionStatus.restricted)
          .map((entry) => entry.key)
          .toList();

      if (permissionsToRequest.isNotEmpty) {
        debugPrint(
            'Requesting permissions: ${permissionsToRequest.map((p) => p.toString()).join(', ')}');

        final requestResults = await permissionsToRequest.request();

        // Check if any critical permissions were denied
        final deniedPermissions = requestResults.entries
            .where((entry) => entry.value != PermissionStatus.granted)
            .map((entry) => entry.key)
            .toList();

        if (deniedPermissions.isNotEmpty) {
          debugPrint(
              'Denied permissions: ${deniedPermissions.map((p) => p.toString()).join(', ')}');

          if (context.mounted) {
            _showPermissionDialog(context, deniedPermissions);
          }
        }
      }
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
  }

  static void _showPermissionDialog(
      BuildContext context, List<Permission> deniedPermissions) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'This app needs the following permissions to work properly:'),
              const SizedBox(height: 12),
              ...deniedPermissions.map((permission) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(_getPermissionIcon(permission), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(_getPermissionDescription(permission))),
                      ],
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  static IconData _getPermissionIcon(Permission permission) {
    switch (permission) {
      case Permission.location:
      case Permission.locationWhenInUse:
        return Icons.location_on;
      case Permission.camera:
        return Icons.camera_alt;
      case Permission.microphone:
        return Icons.mic;
      default:
        return Icons.security;
    }
  }

  static String _getPermissionDescription(Permission permission) {
    switch (permission) {
      case Permission.location:
      case Permission.locationWhenInUse:
        return 'Location access for marine monitoring stations';
      case Permission.camera:
        return 'Camera access for taking photos of marine life';
      case Permission.microphone:
        return 'Microphone access for voice assistant features';
      default:
        return 'Required for app functionality';
    }
  }
}
