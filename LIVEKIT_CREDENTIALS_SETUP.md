# LiveKit Sandbox Setup Guide

## Issue: Invalid API Key (401 Error)

You're seeing this error because the API credentials don't match your sandbox "blueguard-tejjfg".

## Solution: Get Correct Credentials

1. **Go to LiveKit Cloud Dashboard**
   - Visit: https://cloud.livekit.io/
   - Log into your account

2. **Find Your Sandbox**
   - Look for sandbox: `blueguard-tejjfg`
   - Click on it to view details

3. **Get API Credentials**
   - In the sandbox dashboard, find:
     - **API Key** (starts with "API...")
     - **API Secret** (longer string)
   - Copy both values

4. **Update Code**
   - Open: `lib/services/token_service_blueguard.dart`
   - Replace:
     ```dart
     static const String _apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
     static const String _apiSecret = 'YOUR_ACTUAL_API_SECRET_HERE';
     ```
   - With your actual credentials:
     ```dart
     static const String _apiKey = 'APIxxxxxxxxxxxxxxx';  // Your actual API key
     static const String _apiSecret = 'your_actual_secret_here';  // Your actual secret
     ```

5. **Update .env File (Optional)**
   - You can also update the `.env` file with correct credentials:
     ```
     LIVEKIT_URL=wss://blueguard-tejjfg.livekit.cloud
     LIVEKIT_API_KEY=your_actual_api_key
     LIVEKIT_API_SECRET=your_actual_api_secret
     ```

## Current Status

✅ **Sandbox URL**: `wss://blueguard-tejjfg.livekit.cloud` (correct)
❌ **API Key**: Invalid - needs to be updated
❌ **API Secret**: Invalid - needs to be updated

## After Updating Credentials

Once you update the credentials, run:
```bash
flutter run -d chrome
```

The voice assistant should connect successfully to your LiveKit sandbox.

## What Each Credential Does

- **Sandbox ID**: `blueguard-tejjfg` - identifies your LiveKit room server
- **API Key**: Identifies your application 
- **API Secret**: Used to sign JWT tokens for authentication
- **Server URL**: `wss://blueguard-tejjfg.livekit.cloud` - WebSocket connection endpoint

The 401 error means the API key/secret pair doesn't have permission to access the `blueguard-tejjfg` sandbox.