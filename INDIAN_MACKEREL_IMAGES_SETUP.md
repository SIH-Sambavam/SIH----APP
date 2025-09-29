# Indian Mackerel Images Setup

## Overview
The BlueGuard app now supports multiple images for each fish species. For the Indian Mackerel, we've added support for the two additional images you provided.

## Image Setup Instructions

### 1. Replace Placeholder Files
Navigate to the following directory:
```
prototype/assets/images/fish/
```

You'll find two placeholder files that need to be replaced with your actual images:

#### File 1: `indian_mackerel_school.jpg`
- **Replace with**: The school of Indian Mackerel image (the blue underwater image showing multiple fish)
- **Recommended size**: 800x600 pixels or similar aspect ratio
- **Format**: JPG, PNG, or WebP

#### File 2: `indian_mackerel_individual.jpg`
- **Replace with**: The individual Indian Mackerel images (the green/silver fish specimens)
- **Recommended size**: 800x600 pixels or similar aspect ratio
- **Format**: JPG, PNG, or WebP

### 2. File Naming Convention
Make sure the image files are named exactly as specified:
- `indian_mackerel_school.jpg` (for the school image)
- `indian_mackerel_individual.jpg` (for the individual fish image)

### 3. How It Works in the App

When users view the Indian Mackerel details:

1. **Default Image**: The original Unsplash network image loads first
2. **Additional Images**: Your local images appear as additional options in the image gallery
3. **Image Gallery**: Users can tap on thumbnail images to switch between:
   - Original network image
   - School of Indian Mackerel (your first image)
   - Individual specimens (your second image)
   - Habitat image (generated)
   - Underwater image (generated)

### 4. Technical Details

- **Image Provider**: The app automatically detects whether to use `AssetImage` (for local files) or `NetworkImage` (for web URLs)
- **Error Handling**: If local images fail to load, placeholder icons will be shown
- **Performance**: Local images load faster than network images and work offline

### 5. Adding More Images for Other Fish Species

To add images for other fish species, follow this pattern:

1. Add image files to `assets/images/fish/`
2. Update the fish data in `fish_data_model.dart`:
```dart
Fish(
  commonName: 'Species Name',
  // ... other properties
  additionalImages: [
    'assets/images/fish/species_image1.jpg',
    'assets/images/fish/species_image2.jpg',
  ],
  // ... rest of properties
),
```

### 6. Supported Image Formats
- JPG/JPEG
- PNG
- WebP
- GIF (static)

### 7. Recommended Image Specifications
- **Resolution**: 800x600 to 1200x900 pixels
- **Aspect Ratio**: 4:3 or 16:9
- **File Size**: Under 2MB for optimal performance
- **Quality**: High quality for detailed marine biology viewing

## Testing the Images

After replacing the placeholder files:

1. Run `flutter pub get` to ensure assets are recognized
2. Run the app: `flutter run`
3. Navigate to Fish Info → Indian Mackerel
4. Check the image gallery to see your images

The image gallery will show thumbnails at the bottom, and users can tap to view each image in full size.