// Fish data model for BlueGuard app
class Fish {
  final String commonName;
  final String scientificName;
  final String imageUrl;
  final List<String> additionalImages; // New field for extra images
  final String characteristics;
  final String habitat;
  final String conservationStatus;
  final double averageLength; // in cm
  final List<String> threats;
  final bool isEndangered;

  Fish({
    required this.commonName,
    required this.scientificName,
    required this.imageUrl,
    this.additionalImages = const [], // Default to empty list
    required this.characteristics,
    required this.habitat,
    required this.conservationStatus,
    required this.averageLength,
    required this.threats,
    required this.isEndangered,
  });

  // A static method to provide sample data for the prototype
  static List<Fish> getSampleFish() {
    return [
      Fish(
        commonName: 'Indian Mackerel',
        scientificName: 'Rastrelliger kanagurta',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpdZAGO4pnQhzCFtH2rszoGvbqNfc_Nd91iw&s',
        additionalImages: [
          'https://upload.wikimedia.org/wikipedia/commons/4/41/Rastrelliger_kanagurta_JNC2855.JPG',
          'https://www.kaiyukan.com/connect/encyclopedia/assets_c/2025/01/056_gurukuma_02-thumb-885xauto-72085.jpg',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQ9bFuti4asBOL5M89Cy15fBaWwviXXgkmMQ&s',
          'https://static.wikia.nocookie.net/endlessocean/images/8/82/Indian_Mackerel_EOL.jpg/revision/latest?cb=20250216211106',
        ],
        characteristics:
            'A small, oily fish with a streamlined body and forked tail. Rich in omega-3 fatty acids. Typically grows up to 25 cm.',
        habitat:
            'Found in warm, shallow coastal waters. They form large schools and feed on plankton. Prefers water temperatures between 20°C and 30°C.',
        conservationStatus: 'Least Concern',
        averageLength: 25.0,
        threats: ['Overfishing', 'Climate change', 'Pollution'],
        isEndangered: false,
      ),
      Fish(
        commonName: 'Indian Oil Sardine',
        scientificName: 'Sardinella longiceps',
        imageUrl:
            'https://5.imimg.com/data5/VY/IM/GLADMIN-34449827/indian-oil-sardine-1000x1000.png',
        additionalImages: [
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Indian_Oil_Sardine.JPG/1024px-Indian_Oil_Sardine.JPG',
          'https://image.slidesharecdn.com/biologyofindianoilsardine-220920070558-52a9af8b/75/BIOLOGY-OF-INDIAN-OIL-SARDINE-pptx-11-2048.jpg',
          'https://static.wixstatic.com/media/42a449_5b4a5fe4da5740519aa5a7344dc65a9a~mv2.png/v1/fill/w_415,h_415,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/Image-empty-state.png',
        ],
        characteristics:
            'A small, silver-colored fish known for the high oil content in its body. Crucial part of the marine food chain.',
        habitat:
            'Pelagic, schooling fish found along the Indian coast. Abundant during the monsoon and post-monsoon seasons in nutrient-rich upwelling zones.',
        conservationStatus: 'Near Threatened',
        averageLength: 15.0,
        threats: ['Overfishing', 'Ocean acidification'],
        isEndangered: false,
      ),
      Fish(
        commonName: 'Yellowfin Tuna',
        scientificName: 'Thunnus albacares',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb7VdEo-7HEBY8ZnMgxrXbOKsGW-e4P5FiyA&s',
        additionalImages: [
          'https://cdn.prod.website-files.com/64c871291cf9e6192ef11f7a/66690d0f15477364171dd0ee_Yellowfin%20Tuna%20Species%20Guide_hero%20banner_2880x1800.jpg',
          'https://cdn.shopify.com/s/files/1/0230/8793/9662/files/2018_-_SCENIC_FISH_TUNA.5_1024x1024.jpg?v=1682541465',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIfGBhO75eOb439u9n0EQwW5dWwoO2YtrzCA&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpBJe_9rBq21W-K33Ea1BnG3Q2vpg182rJOw&s',
        ],
        characteristics:
            'A large, torpedo-shaped fish with distinctive yellow dorsal and anal fins. Highly migratory and a popular commercial fish.',
        habitat:
            'Inhabits the upper layers of the open ocean, typically in tropical and subtropical waters. Often found near the thermocline.',
        conservationStatus: 'Near Threatened',
        averageLength: 150.0,
        threats: ['Overfishing', 'Bycatch', 'Climate change'],
        isEndangered: false,
      ),
      Fish(
        commonName: 'Malabar Grouper',
        scientificName: 'Epinephelus malabaricus',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Epinephelus_malabaricus_in_UShaka_Sea_World_1098.jpg/500px-Epinephelus_malabaricus_in_UShaka_Sea_World_1098.jpg',
        additionalImages: [
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Malabar_grouper_melb_aquarium.jpg/500px-Malabar_grouper_melb_aquarium.jpg',
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Malabar_Grouper_%28Epinephelus_malabaricus%29_%288502057283%29.jpg/500px-Malabar_Grouper_%28Epinephelus_malabaricus%29_%288502057283%29.jpg',
          'https://wp.web.fishboxapp.com/wp-content/local-uploads/full/malabar_grouper_realistic.png',
        ],
        characteristics:
            'A large, robust fish with a big mouth and brownish-grey body covered in dark spots. Can change its sex from female to male.',
        habitat:
            'Prefers lagoons, reefs, and estuaries. Often found in brackish water and can tolerate a wide range of salinities. A bottom-dwelling predator.',
        conservationStatus: 'Vulnerable',
        averageLength: 80.0,
        threats: ['Habitat loss', 'Overfishing', 'Coastal development'],
        isEndangered: true,
      ),
      Fish(
        commonName: 'Whale Shark',
        scientificName: 'Rhincodon typus',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQetxOK9kkk_b7UuJB9C8_mSHKPBfrNZDuURw&s',
        additionalImages: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwv2WK0BW0W3Og1kGdBTc89z5E4-30nYj9Gg&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNMyzNz1i61ED34dB_BUlBG1rOmCQPM6FIjA&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQT2dSkgQ6TQFUvH59lzSR8dUKwDLmhWLIsIQ&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYeg9XmYd0rVkHY6uAWNU4Vi-arl2gsGsp6adIcqn-aTkTXrP0txkeMeWyqrVWPRo1aus&usqp=CAU',
        ],
        characteristics:
            'The largest fish in the ocean, filter-feeding on plankton and small fish. Gentle giants with distinctive spotted pattern.',
        habitat:
            'Open oceans in tropical waters. Often found near the surface feeding on plankton blooms.',
        conservationStatus: 'Endangered',
        averageLength: 1000.0,
        threats: ['Ship strikes', 'Fishing nets', 'Tourism pressure'],
        isEndangered: true,
      ),
    ];
  }
}

// Water quality data model
class WaterQuality {
  final double temperature; // Celsius
  final double pH;
  final double dissolvedOxygen; // mg/L
  final double salinity; // ppt
  final double turbidity; // NTU
  final String status; // "Good", "Fair", "Poor"
  final DateTime timestamp;

  WaterQuality({
    required this.temperature,
    required this.pH,
    required this.dissolvedOxygen,
    required this.salinity,
    required this.turbidity,
    required this.status,
    required this.timestamp,
  });

  static WaterQuality getSampleData() {
    return WaterQuality(
      temperature: 26.5,
      pH: 8.1,
      dissolvedOxygen: 7.2,
      salinity: 35.0,
      turbidity: 2.1,
      status: "Good",
      timestamp: DateTime.now(),
    );
  }
}

// Alert data model
class Alert {
  final String id;
  final String title;
  final String description;
  final String severity; // "Low", "Medium", "High", "Critical"
  final DateTime timestamp;
  final bool isRead;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
    required this.isRead,
  });

  static List<Alert> getSampleAlerts() {
    return [
      Alert(
        id: "1",
        title: "Temperature spike detected",
        description: "Water temperature increased to 32°C in zone A",
        severity: "High",
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
      ),
      Alert(
        id: "2",
        title: "Low oxygen levels",
        description: "Dissolved oxygen dropped to 4.5 mg/L",
        severity: "Medium",
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isRead: false,
      ),
      Alert(
        id: "3",
        title: "Unusual fish behavior",
        description: "Schooling pattern anomaly detected",
        severity: "Low",
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
      ),
    ];
  }
}
