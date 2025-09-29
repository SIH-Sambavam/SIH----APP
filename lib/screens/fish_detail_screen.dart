import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../fish_data_model.dart';
import '../widgets/mapbox_map_widget.dart';

class PopulationDataPoint {
  final int year;
  final double population;
  final bool hasEvent;
  final bool isProjected;

  PopulationDataPoint(
    this.year,
    this.population,
    this.hasEvent, {
    this.isProjected = false,
  });
}

class FishDetailScreen extends StatefulWidget {
  final Fish fish;

  const FishDetailScreen({super.key, required this.fish});

  @override
  State<FishDetailScreen> createState() => _FishDetailScreenState();
}

class _FishDetailScreenState extends State<FishDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showHistoricalDistribution = false;
  int _selectedImageIndex = 0;

  // Sample population data for distribution graph
  final List<PopulationDataPoint> _populationData = [
    PopulationDataPoint(2000, 850000, false),
    PopulationDataPoint(2005, 820000, false),
    PopulationDataPoint(2010, 780000, true), // Event marker
    PopulationDataPoint(2015, 720000, false),
    PopulationDataPoint(2020, 680000, false),
    PopulationDataPoint(2025, 650000, false),
    PopulationDataPoint(2030, 620000, false, isProjected: true),
    PopulationDataPoint(2035, 580000, false, isProjected: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildTabBar(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildDistributionTab(),
                      _buildPopulationTab(),
                      _buildGenomicsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF1E3A8A),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E40AF),
                    Color(0xFF0F172A),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fish.commonName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.fish.scientificName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFBFDBFE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildStatusChip(
                        widget.fish.conservationStatus,
                        _getStatusColor(widget.fish.conservationStatus),
                      ),
                      _buildStatusChip(
                        widget.fish.habitat,
                        const Color(0xFF059669),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'endangered':
        return const Color(0xFFDC2626);
      case 'vulnerable':
        return const Color(0xFFEA580C);
      case 'near threatened':
        return const Color(0xFFD97706);
      case 'least concern':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF1E40AF),
        labelColor: const Color(0xFF1E40AF),
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Distribution'),
          Tab(text: 'Population'),
          Tab(text: 'Genomics'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(),
          const SizedBox(height: 24),
          _buildBasicInfoCard(),
          const SizedBox(height: 16),
          _buildHabitatCard(),
          const SizedBox(height: 16),
          _buildBiologyCard(),
          const SizedBox(height: 16),
          _buildConservationCard(),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = [
      widget.fish.imageUrl,
      ...widget.fish
          .additionalImages, // Add only the additional images from the data model
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: _getImageProvider(images[_selectedImageIndex]),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Handle image loading error gracefully
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = entry.key),
                  child: Container(
                    width: 60,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedImageIndex == entry.key
                            ? const Color(0xFF1E40AF)
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image(
                        image: _getImageProvider(entry.value),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return _buildInfoCard(
      'Basic Information',
      Icons.info_outline,
      [
        _buildInfoRow('Maximum Length',
            '${widget.fish.averageLength.toStringAsFixed(0)} cm'),
        _buildInfoRow('Average Weight', _getWeight()),
        _buildInfoRow('Average Lifespan', _getLifespan()),
        _buildInfoRow('Family', _getFamily()),
        _buildInfoRow('Order', _getOrder()),
      ],
    );
  }

  Widget _buildHabitatCard() {
    return _buildInfoCard(
      'Habitat Parameters',
      Icons.waves,
      [
        _buildInfoRow('Temperature Range', _getTemperatureRange()),
        _buildInfoRow('Depth Range', _getDepthRange()),
        _buildInfoRow('Salinity Tolerance', 'Marine (35 PSU)'),
        _buildInfoRow('Preferred Substrate', widget.fish.habitat),
        _buildInfoRow('Geographic Range', _getGeographicRange()),
      ],
    );
  }

  Widget _buildBiologyCard() {
    return _buildInfoCard(
      'Biology & Ecology',
      Icons.biotech,
      [
        _buildInfoRow('Diet', _getDiet()),
        _buildInfoRow('Characteristics', widget.fish.characteristics),
        _buildInfoRow('Feeding Behavior', _getFeedingBehavior()),
        _buildInfoRow('Reproduction', _getReproduction()),
        _buildInfoRow('Social Behavior', _getSocialBehavior()),
      ],
    );
  }

  Widget _buildConservationCard() {
    return _buildInfoCard(
      'Conservation & Threats',
      Icons.security,
      [
        _buildInfoRow('IUCN Status', widget.fish.conservationStatus),
        _buildInfoRow('Population Trend',
            widget.fish.isEndangered ? 'Declining' : 'Stable'),
        _buildInfoRow('Main Threats', widget.fish.threats.join(', ')),
        _buildInfoRow('Protection Measures', _getProtectionMeasures()),
        _buildInfoRow('Recovery Actions', _getRecoveryActions()),
      ],
    );
  }

  Widget _buildDistributionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDistributionControls(),
          const SizedBox(height: 16),
          _buildDistributionMap(),
          const SizedBox(height: 16),
          _buildPopulationGraph(),
          const SizedBox(height: 16),
          _buildDistributionLegend(),
        ],
      ),
    );
  }

  Widget _buildDistributionControls() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.map, color: Color(0xFF1E40AF)),
            const SizedBox(width: 12),
            const Text(
              'Distribution View:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Spacer(),
            Switch.adaptive(
              value: _showHistoricalDistribution,
              onChanged: (value) =>
                  setState(() => _showHistoricalDistribution = value),
              activeColor: const Color(0xFF1E40AF),
            ),
            const SizedBox(width: 8),
            Text(
              _showHistoricalDistribution ? 'Historical' : 'Current',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionMap() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: kIsWeb
              ? _buildWebDistributionMap()
              : _buildMobileDistributionMap(),
        ),
      ),
    );
  }

  Widget _buildWebDistributionMap() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.public,
                  size: 64,
                  color: const Color(0xFF1E40AF).withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  _showHistoricalDistribution
                      ? 'Historical Distribution (1950-2000)'
                      : 'Current Distribution (2020-2025)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getGeographicRange(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDistributionMap() {
    // Create markers for different fish habitats
    List<MapboxMarker> markers = [];

    // Add markers based on fish species
    switch (widget.fish.commonName) {
      case 'Indian Mackerel':
        markers.add(MapboxMarker(
          latitude: 19.0760,
          longitude: 72.8777,
          title: 'Mumbai Coast - Indian Mackerel Habitat',
        ));
        markers.add(MapboxMarker(
          latitude: 8.5241,
          longitude: 76.9366,
          title: 'Kerala Waters',
        ));
        break;
      case 'Whale Shark':
        markers.add(MapboxMarker(
          latitude: 22.2587,
          longitude: 70.0557,
          title: 'Gujarat Coast - Whale Shark Sanctuary',
        ));
        break;
      case 'Yellowfin Tuna':
        markers.add(MapboxMarker(
          latitude: 14.5995,
          longitude: 73.7124,
          title: 'Arabian Sea - Tuna Fishing Zone',
        ));
        break;
      default:
        markers.add(MapboxMarker(
          latitude: 15.2993,
          longitude: 74.1240,
          title: 'Indian Ocean Waters',
        ));
    }

    return MapboxMapWidget(
      latitude: 15.2993,
      longitude: 74.1240,
      zoom: 5.0,
      markers: markers,
    );
  }

  Widget _buildDistributionLegend() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribution Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Primary Habitat', widget.fish.habitat),
            _buildInfoRow('Geographic Range', _getGeographicRange()),
            _buildInfoRow(
                'Conservation Status', widget.fish.conservationStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulationGraph() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart,
                    color: Color(0xFF1E40AF), size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Population Distribution Trends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(
                  widget.fish.isEndangered
                      ? Icons.trending_down
                      : Icons.trending_up,
                  color: widget.fish.isEndangered ? Colors.red : Colors.green,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: CustomPaint(
                painter: PopulationGraphPainter(_populationData),
                child: Container(),
              ),
            ),
            const SizedBox(height: 16),
            _buildGraphLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Historical Data', Colors.blue, Icons.circle),
        _buildLegendItem('Projections', Colors.orange, Icons.circle_outlined),
        _buildLegendItem('Conservation Events', Colors.red, Icons.warning),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPopulationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPopulationOverview(),
          const SizedBox(height: 16),
          _buildPopulationInsights(),
          const SizedBox(height: 16),
          _buildActionableInsights(),
        ],
      ),
    );
  }

  Widget _buildPopulationOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Population Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsightRow('Conservation Status',
                widget.fish.conservationStatus, Icons.security),
            _buildInsightRow(
                'Population Trend',
                widget.fish.isEndangered ? 'Declining' : 'Stable',
                Icons.trending_down),
            _buildInsightRow(
                'Primary Threats', widget.fish.threats.first, Icons.warning),
            _buildInsightRow(
                'Protection Level', _getProtectionLevel(), Icons.shield),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulationInsights() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Species Analysis',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Average Length', '${widget.fish.averageLength} cm'),
            _buildInfoRow('Habitat Type', widget.fish.habitat),
            _buildInfoRow('Main Characteristics', widget.fish.characteristics),
            _buildInfoRow(
                'Endangered Status', widget.fish.isEndangered ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionableInsights() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFF059669)),
                SizedBox(width: 8),
                Text(
                  'Conservation Recommendations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              'Sustainable Fishing',
              'Implement responsible fishing practices to protect this species',
              Icons.sailing,
            ),
            _buildRecommendationItem(
              'Habitat Protection',
              'Preserve marine habitats where this species lives',
              Icons.shield,
            ),
            _buildRecommendationItem(
              'Research & Monitoring',
              'Continue scientific research and population monitoring',
              Icons.science,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenomicsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDnaSampleCard(),
          const SizedBox(height: 16),
          _buildGeneticMarkersCard(),
          const SizedBox(height: 16),
          _buildGenomicSequenceCard(),
          const SizedBox(height: 16),
          _buildDatabaseLinksCard(),
        ],
      ),
    );
  }

  Widget _buildDnaSampleCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.biotech, color: Color(0xFF1E40AF), size: 28),
                SizedBox(width: 12),
                Text(
                  'Genetic Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Scientific Name', widget.fish.scientificName),
            _buildInfoRow('Species Classification', _getFamily()),
            _buildInfoRow('Genetic Markers', 'COI, 16S rRNA available'),
            _buildInfoRow('DNA Samples', 'Available from multiple locations'),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneticMarkersCard() {
    return _buildInfoCard(
      'Genetic Markers',
      Icons.dns,
      [
        _buildInfoRow('COI Gene',
            'Cytochrome c oxidase subunit I - Species identification'),
        _buildInfoRow('16S rRNA', 'Ribosomal RNA - Phylogenetic analysis'),
        _buildInfoRow('Microsatellites', 'Population structure analysis'),
        _buildInfoRow('SNPs', 'Single nucleotide polymorphisms'),
        _buildInfoRow('Control Region', 'Mitochondrial control region'),
      ],
    );
  }

  Widget _buildGenomicSequenceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.code, color: Color(0xFF1E40AF)),
                SizedBox(width: 8),
                Text(
                  'Genomic Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Species Name', widget.fish.scientificName),
            _buildInfoRow('Common Name', widget.fish.commonName),
            _buildInfoRow('Genetic Status', 'Sequenced and cataloged'),
            _buildInfoRow('Database Access', 'Available in major databases'),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseLinksCard() {
    return _buildInfoCard(
      'External Resources',
      Icons.link,
      [
        _buildLinkRow(
            'FishBase', 'Comprehensive fish database', 'https://fishbase.org'),
        _buildLinkRow('IUCN Red List', 'Conservation status information',
            'https://iucnredlist.org'),
        _buildLinkRow(
            'NCBI', 'Genetic sequence database', 'https://ncbi.nlm.nih.gov'),
        _buildLinkRow('Ocean Biogeographic Info', 'Marine biodiversity data',
            'https://obis.org'),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF1E40AF)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String title, String description, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening $title...')),
          );
        },
        child: Row(
          children: [
            const Icon(Icons.open_in_new, size: 16, color: Color(0xFF1E40AF)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1E40AF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
      String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.green.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to determine if image is local asset or network image
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return NetworkImage(imagePath);
    }
  }

  // Helper methods to get species-specific data
  String _getWeight() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return '15,000-20,000 kg';
      case 'Yellowfin Tuna':
        return '180-200 kg';
      case 'Malabar Grouper':
        return '60-80 kg';
      default:
        return '2-5 kg';
    }
  }

  String _getLifespan() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return '70-130 years';
      case 'Yellowfin Tuna':
        return '6-7 years';
      case 'Malabar Grouper':
        return '37 years';
      default:
        return '8-12 years';
    }
  }

  String _getFamily() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Rhincodontidae';
      case 'Yellowfin Tuna':
        return 'Scombridae';
      case 'Malabar Grouper':
        return 'Serranidae';
      case 'Indian Mackerel':
        return 'Scombridae';
      default:
        return 'Clupeidae';
    }
  }

  String _getOrder() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Orectolobiformes';
      case 'Yellowfin Tuna':
      case 'Indian Mackerel':
        return 'Perciformes';
      case 'Malabar Grouper':
        return 'Perciformes';
      default:
        return 'Clupeiformes';
    }
  }

  String _getTemperatureRange() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return '21-30°C';
      case 'Yellowfin Tuna':
        return '15-31°C';
      case 'Malabar Grouper':
        return '24-30°C';
      default:
        return '20-30°C';
    }
  }

  String _getDepthRange() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return '0-1928m';
      case 'Yellowfin Tuna':
        return '0-250m';
      case 'Malabar Grouper':
        return '5-60m';
      default:
        return '0-200m';
    }
  }

  String _getGeographicRange() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Global tropical and warm temperate waters';
      case 'Yellowfin Tuna':
        return 'Tropical and subtropical oceans worldwide';
      case 'Malabar Grouper':
        return 'Indo-Pacific: Red Sea to South Africa';
      case 'Indian Mackerel':
        return 'Indo-Pacific: Persian Gulf to Southeast Asia';
      default:
        return 'Indian Ocean and Western Pacific';
    }
  }

  String _getDiet() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Plankton, small fish, fish eggs';
      case 'Yellowfin Tuna':
        return 'Fish, squid, crustaceans';
      case 'Malabar Grouper':
        return 'Fish, crustaceans, cephalopods';
      default:
        return 'Zooplankton, small crustaceans';
    }
  }

  String _getFeedingBehavior() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Filter feeder, ram feeding';
      case 'Yellowfin Tuna':
        return 'Active predator, schooling hunter';
      case 'Malabar Grouper':
        return 'Ambush predator, solitary hunter';
      default:
        return 'Schooling, filter feeding';
    }
  }

  String _getReproduction() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Ovoviviparous, 300+ pups';
      case 'Yellowfin Tuna':
        return 'Broadcast spawning, millions of eggs';
      case 'Malabar Grouper':
        return 'Protogynous hermaphrodite';
      default:
        return 'Broadcast spawning, seasonal';
    }
  }

  String _getSocialBehavior() {
    switch (widget.fish.commonName) {
      case 'Whale Shark':
        return 'Usually solitary, occasional aggregations';
      case 'Yellowfin Tuna':
        return 'Highly social, large schools';
      case 'Malabar Grouper':
        return 'Solitary, territorial';
      default:
        return 'Schooling, highly social';
    }
  }

  String _getProtectionMeasures() {
    switch (widget.fish.conservationStatus.toLowerCase()) {
      case 'endangered':
        return 'CITES protection, international monitoring';
      case 'vulnerable':
        return 'Regional fishing quotas, protected areas';
      case 'near threatened':
        return 'Fishing regulations, monitoring programs';
      default:
        return 'Sustainable fishing practices';
    }
  }

  String _getRecoveryActions() {
    return 'Marine protected areas, fishing restrictions, habitat restoration';
  }

  String _getProtectionLevel() {
    if (widget.fish.isEndangered) {
      return 'High - International protection';
    } else if (widget.fish.conservationStatus
        .toLowerCase()
        .contains('threatened')) {
      return 'Medium - Regional protection';
    } else {
      return 'Standard - General regulations';
    }
  }
}

class PopulationGraphPainter extends CustomPainter {
  final List<PopulationDataPoint> data;

  PopulationGraphPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final eventPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate scales
    final minPop =
        data.map((d) => d.population).reduce((a, b) => a < b ? a : b);
    final maxPop =
        data.map((d) => d.population).reduce((a, b) => a > b ? a : b);

    final margin = 40.0;
    final graphWidth = size.width - 2 * margin;
    final graphHeight = size.height - 2 * margin;

    // Draw grid lines
    for (int i = 0; i <= 5; i++) {
      final y = margin + (graphHeight * i / 5);
      canvas.drawLine(
        Offset(margin, y),
        Offset(size.width - margin, y),
        gridPaint,
      );

      // Y-axis labels (population)
      final popValue = maxPop - (maxPop - minPop) * i / 5;
      textPainter.text = TextSpan(
        text: '${(popValue / 1000).toStringAsFixed(0)}K',
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 6));
    }

    // Draw X-axis grid and labels
    for (int i = 0; i < data.length; i++) {
      final x = margin + (graphWidth * i / (data.length - 1));

      if (i % 2 == 0) {
        // Show every other year label
        canvas.drawLine(
          Offset(x, margin),
          Offset(x, size.height - margin),
          gridPaint,
        );

        textPainter.text = TextSpan(
          text: data[i].year.toString(),
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(
            canvas, Offset(x - textPainter.width / 2, size.height - 20));
      }
    }

    // Create path for population line
    final path = Path();
    final projectedPath = Path();
    bool projectedStarted = false;

    for (int i = 0; i < data.length; i++) {
      final x = margin + (graphWidth * i / (data.length - 1));
      final y = margin +
          graphHeight -
          ((data[i].population - minPop) / (maxPop - minPop) * graphHeight);

      if (i == 0) {
        path.moveTo(x, y);
      } else if (!data[i].isProjected && !data[i - 1].isProjected) {
        path.lineTo(x, y);
      } else if (data[i].isProjected && !projectedStarted) {
        // Start projected line from the last historical point
        projectedPath.moveTo(
          margin + (graphWidth * (i - 1) / (data.length - 1)),
          margin +
              graphHeight -
              ((data[i - 1].population - minPop) /
                  (maxPop - minPop) *
                  graphHeight),
        );
        projectedPath.lineTo(x, y);
        projectedStarted = true;
      } else if (data[i].isProjected) {
        projectedPath.lineTo(x, y);
      }

      // Draw event markers
      if (data[i].hasEvent) {
        canvas.drawCircle(Offset(x, y), 6, eventPaint);

        // Add event label
        textPainter.text = const TextSpan(
          text: 'Event',
          style: TextStyle(
              color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 20));
      }
    }

    // Draw the lines
    canvas.drawPath(path, paint);
    if (projectedStarted) {
      // Make projected line dashed
      final dashPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      canvas.drawPath(projectedPath, dashPaint);
    }

    // Draw data points
    for (int i = 0; i < data.length; i++) {
      final x = margin + (graphWidth * i / (data.length - 1));
      final y = margin +
          graphHeight -
          ((data[i].population - minPop) / (maxPop - minPop) * graphHeight);

      final pointPaint = Paint()
        ..color = data[i].isProjected ? Colors.orange : Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
