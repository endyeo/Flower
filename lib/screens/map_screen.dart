import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/flower_location.dart';
import '../services/flower_data_service.dart';
import '../widgets/flower_widgets.dart';

/// Main screen: a full-screen map with flower location markers.
class MapScreen extends StatefulWidget {
  MapScreen({super.key, FlowerDataService? dataService})
      : _dataService = dataService ?? FlowerDataService();

  final FlowerDataService _dataService;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _koreaCenter = LatLng(36.5, 127.8);
  static const double _initialZoom = 7.0;
  static const double _markerSize = 36.0;

  final MapController _mapController = MapController();

  List<FlowerLocation> _allLocations = [];
  Set<FlowerType> _activeFilters = FlowerType.values.toSet();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFlowerLocations();
  }

  Future<void> _loadFlowerLocations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final locations = await widget._dataService.getFlowerLocations();
      if (mounted) {
        setState(() {
          _allLocations = locations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '데이터를 불러오는 데 실패했습니다: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<FlowerLocation> get _filteredLocations => _allLocations
      .where((loc) => _activeFilters.contains(loc.flowerType))
      .toList();

  void _toggleFilter(FlowerType type) {
    setState(() {
      if (_activeFilters.contains(type)) {
        if (_activeFilters.length > 1) {
          _activeFilters = Set.from(_activeFilters)..remove(type);
        }
      } else {
        _activeFilters = Set.from(_activeFilters)..add(type);
      }
    });
  }

  void _showLocationDetail(FlowerLocation location) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FlowerDetailSheet(location: location),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🌸', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text(
              '꽃 지도',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: _loadFlowerLocations,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildMapArea()),
        ],
      ),
    );
  }

  /// Horizontal scrollable list of flower-type filter chips.
  Widget _buildFilterBar() {
    final types = FlowerType.values
        .where((t) => t != FlowerType.unknown)
        .toList();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: types.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FlowerFilterChip(
                flowerType: type,
                selected: _activeFilters.contains(type),
                onToggle: () => _toggleFilter(type),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMapArea() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('꽃 명소 데이터를 불러오는 중...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFlowerLocations,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final visible = _filteredLocations;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _koreaCenter,
            initialZoom: _initialZoom,
            minZoom: 4,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.flower',
              maxZoom: 18,
            ),
            MarkerLayer(
              markers: visible.map(_buildMarker).toList(),
            ),
          ],
        ),
        // Marker count badge
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${visible.length}개 꽃 명소',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Marker _buildMarker(FlowerLocation location) {
    final color = flowerColor(location.flowerType);
    return Marker(
      point: location.position,
      width: _markerSize,
      height: _markerSize,
      child: GestureDetector(
        onTap: () => _showLocationDetail(location),
        child: Tooltip(
          message: location.name,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                location.flowerType.emoji,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
