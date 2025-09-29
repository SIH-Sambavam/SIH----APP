# Android Troubleshooting Guide for BlueGuard App

## Overview
This document provides solutions for common Android-specific issues when images and maps don't load properly on mobile devices while working fine in Chrome/web.

## Issues Fixed

### 1. Network Security Configuration
**Problem**: Android blocks HTTP requests and external image loading by default
**Solution**: Enhanced `network_security_config.xml` with:
- Debug overrides for development
- Comprehensive domain whitelist for image hosts
- Mapbox-specific domain configurations
- Google services domains

### 2. Missing Android Permissions
**Problem**: App lacks necessary permissions for network, location, and camera access
**Solution**: Added missing permissions in `AndroidManifest.xml`:
- `ACCESS_NETWORK_STATE` - Check network connectivity
- `ACCESS_WIFI_STATE` - WiFi connection monitoring
- `WRITE_EXTERNAL_STORAGE` - Image caching
- `READ_EXTERNAL_STORAGE` - Access cached images

### 3. Image Loading Issues
**Problem**: Network images fail to load on Android due to security restrictions
**Solution**: 
- Created `NetworkImageWidget` with proper error handling
- Added User-Agent headers for better compatibility
- Implemented progressive loading states
- Enhanced error messages and fallback UI

### 4. Mapbox Integration Issues
**Problem**: Mapbox maps don't initialize properly on Android
**Solution**:
- Enhanced `MapboxMapWidget` with platform-specific initialization
- Added proper token validation and error states
- Implemented loading indicators and retry mechanisms
- Added comprehensive debug logging

### 5. Permission Handling
**Problem**: App doesn't request runtime permissions on Android 6.0+
**Solution**:
- Created `PermissionHelper` service
- Automatic permission request on app startup
- User-friendly permission explanation dialogs
- Settings redirection for denied permissions

## Testing the Fixes

### Android Device Testing
1. Clean build: `flutter clean && flutter pub get`
2. Build and install: `flutter run -d <device-id>`
3. Check logs: `flutter logs` to monitor network requests
4. Test offline/online scenarios

### Debug Commands
```bash
# View detailed logs
flutter logs --verbose

# Check connected devices
flutter devices

# Build release APK for testing
flutter build apk --release

# Install on specific device
flutter install -d <device-id>
```

### Network Debugging
1. Check if images load in airplane mode (cached)
2. Monitor network requests in Android Studio
3. Verify DNS resolution works
4. Test with different network types (WiFi/Mobile)

## Common Android-Specific Issues

### Issue: Images load slowly or timeout
**Cause**: Network configuration or DNS issues
**Solution**: 
- Check `network_security_config.xml` includes all domains
- Verify device has stable internet connection
- Consider implementing image caching

### Issue: Maps show blank/white screen
**Cause**: Mapbox token not accessible or network blocked
**Solution**:
- Verify `.env` file is properly loaded
- Check Mapbox token validity
- Ensure device has location permissions
- Check network connectivity

### Issue: Permissions denied dialog appears repeatedly
**Cause**: User denied permissions permanently
**Solution**:
- Guide users to app settings
- Explain why permissions are needed
- Provide fallback functionality for denied permissions

### Issue: App crashes on startup
**Cause**: Missing dependencies or configuration errors
**Solution**:
- Run `flutter doctor` to check setup
- Verify all dependencies in `pubspec.yaml`
- Check Android SDK and build tools versions

## Production Considerations

1. **Security**: Remove debug overrides from `network_security_config.xml`
2. **Performance**: Implement proper image caching strategy
3. **Offline**: Add offline functionality for core features
4. **Analytics**: Monitor network request failures
5. **Testing**: Test on various Android versions and devices

## Environment Variables Required
Ensure these are properly set in `.env`:
```
MAPBOX_ACCESS_TOKEN=your_mapbox_token
LIVEKIT_API_KEY=your_livekit_key  
LIVEKIT_API_SECRET=your_livekit_secret
LIVEKIT_URL=wss://blueguard-tejjfg.livekit.cloud
```

## Next Steps
1. Test on real Android devices with different OS versions
2. Monitor crash reports and network failures
3. Optimize image loading performance
4. Consider implementing offline capabilities
5. Add proper error reporting and analytics