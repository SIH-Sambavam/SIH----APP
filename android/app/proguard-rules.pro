# Keep dotenv classes
-keep class flutter_dotenv.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Mapbox classes
-keep class com.mapbox.** { *; }
-dontwarn com.mapbox.**

# Keep network-related classes for image loading
-keep class java.net.** { *; }
-keep class javax.net.ssl.** { *; }

# Keep HTTP client classes
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# General rules for Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
