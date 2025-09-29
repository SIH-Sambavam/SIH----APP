import 'package:flutter/material.dart';
import '../fish_data_model.dart';
import 'fish_detail_screen.dart';

class FishInfoScreen extends StatefulWidget {
  const FishInfoScreen({super.key});

  @override
  State<FishInfoScreen> createState() => _FishInfoScreenState();
}

class _FishInfoScreenState extends State<FishInfoScreen> {
  List<Fish> fishList = [];
  List<Fish> filteredFishList = [];
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fishList = Fish.getSampleFish();
    filteredFishList = fishList;
  }

  void _filterFish() {
    setState(() {
      filteredFishList = fishList.where((fish) {
        final matchesSearch = searchQuery.isEmpty ||
            fish.commonName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            fish.scientificName
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

        final matchesFilter = selectedFilter == 'All' ||
            (selectedFilter == 'Endangered' && fish.isEndangered) ||
            fish.conservationStatus
                .toLowerCase()
                .contains(selectedFilter.toLowerCase());

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _setFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      _filterFish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Species'),
        backgroundColor: const Color(0xFF005A7C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search fish species...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      _filterFish();
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Endangered'),
                      _buildFilterChip('Vulnerable'),
                      _buildFilterChip('Least Concern'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFishList.length,
              itemBuilder: (context, index) {
                final fish = filteredFishList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  fish.isEndangered ? Colors.red : Colors.blue,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              fish.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                    'Image load error for ${fish.scientificName}: $error');
                                debugPrint('Failed URL: ${fish.imageUrl}');
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: fish.isEndangered
                                      ? Colors.red
                                      : Colors.blue,
                                  child: const Icon(
                                    Icons.phishing,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.shade200,
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                    color: fish.isEndangered
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Image count badge
                        if (fish.additionalImages.isNotEmpty)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF005A7C),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${fish.additionalImages.length + 1}', // +1 for main image
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      fish.commonName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fish.scientificName,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.eco,
                              size: 16,
                              color:
                                  fish.isEndangered ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              fish.conservationStatus,
                              style: TextStyle(
                                color: fish.isEndangered
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Additional images preview
                        if (fish.additionalImages.isNotEmpty)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fish.additionalImages.length
                                        .clamp(0, 4), // Show max 4 images
                                    itemBuilder: (context, imageIndex) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: Image.network(
                                              fish.additionalImages[imageIndex],
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey.shade200,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey.shade400,
                                                    size: 16,
                                                  ),
                                                );
                                              },
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Container(
                                                  color: Colors.grey.shade100,
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Show count if there are more images
                              if (fish.additionalImages.length > 4)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF005A7C),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '+${fish.additionalImages.length - 4}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FishDetailScreen(fish: fish),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = selectedFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter),
        selected: isSelected,
        onSelected: (selected) => _setFilter(filter),
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF005A7C).withValues(alpha: 0.2),
        checkmarkColor: const Color(0xFF005A7C),
      ),
    );
  }
}
