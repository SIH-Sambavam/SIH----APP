# BlueGuard (Prototype)

A cross-platform Flutter app for marine species monitoring, fish information, and AI-powered ocean protection.

## Features

- **Marine Species List**: Browse, search, and filter marine species by conservation status (Endangered, Vulnerable, Least Concern, etc.)
- **Fish Details**: View detailed information, images, and conservation status for each species
- **Interactive Map**: See marine monitoring locations on a Mapbox-powered map
- **Voice Assistant**: Interact with the app using voice commands
- **Chat AI**: Get answers to marine biology questions
- **LiveKit Integration**: Real-time communication for marine research

## Screenshots

![Fish Info Screen](docs/screenshots/fish_info.png)
![Map Screen](docs/screenshots/map_screen.png)

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio or Xcode for mobile builds
- A valid Mapbox access token (for map features)
- LiveKit API credentials (for real-time features)

### Setup
1. **Clone the repository**
   ```sh
   git clone <repo-url>
   cd prototype
   ```
2. **Install dependencies**
   ```sh
   flutter pub get
   ```
3. **Configure environment variables**
   - Copy `.env.example` to `.env` and fill in your keys:
     ```env
     MAPBOX_ACCESS_TOKEN=your_mapbox_token
     LIVEKIT_API_KEY=your_livekit_key
     LIVEKIT_API_SECRET=your_livekit_secret
     LIVEKIT_URL=wss://blueguard-tejjfg.livekit.cloud
     ```
4. **Run the app**
   - For Android:
     ```sh
     flutter run -d <android-device-id>
     ```
   - For iOS:
     ```sh
     flutter run -d <ios-device-id>
     ```
   - For Web:
     ```sh
     flutter run -d chrome
     ```

## Android Troubleshooting
See [ANDROID_TROUBLESHOOTING.md](ANDROID_TROUBLESHOOTING.md) for solutions to common issues with images and maps not loading on Android devices.

## Folder Structure
```
lib/
  app.dart
  main.dart
  controllers/
  screens/
  services/
  widgets/
assets/
  images/
  fonts/
android/
  app/
    src/
      main/
        AndroidManifest.xml
        res/
          xml/
            network_security_config.xml
```

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
