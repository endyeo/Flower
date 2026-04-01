import 'package:flutter_test/flutter_test.dart';
import 'package:flower/models/flower_location.dart';
import 'package:flower/services/flower_data_service.dart';

void main() {
  group('FlowerDataService', () {
    late FlowerDataService service;

    setUp(() {
      service = FlowerDataService();
    });

    test('returns sample data when no API key is configured', () async {
      final locations = await service.getFlowerLocations();

      expect(locations, isNotEmpty);
      // Verify we have a variety of flower types.
      final types = locations.map((l) => l.flowerType).toSet();
      expect(types, contains(FlowerType.cherryBlossom));
      expect(types, contains(FlowerType.forsythia));
      expect(types, contains(FlowerType.rapeseed));
    });

    test('all sample locations have valid Korean coordinates', () async {
      final locations = await service.getFlowerLocations();

      for (final loc in locations) {
        expect(
          loc.position.latitude,
          inInclusiveRange(33.0, 38.5),
          reason: '${loc.name} latitude out of Korea range',
        );
        expect(
          loc.position.longitude,
          inInclusiveRange(125.0, 130.0),
          reason: '${loc.name} longitude out of Korea range',
        );
      }
    });

    test('all sample locations have non-empty names and addresses', () async {
      final locations = await service.getFlowerLocations();

      for (final loc in locations) {
        expect(loc.name, isNotEmpty,
            reason: 'Location ${loc.id} has empty name');
        expect(loc.address, isNotEmpty,
            reason: 'Location ${loc.id} has empty address');
      }
    });

    test('sample locations include multiple regions in Korea', () async {
      final locations = await service.getFlowerLocations();
      final regions = locations
          .where((l) => l.region != null)
          .map((l) => l.region!)
          .toSet();
      // Expect locations from at least 3 distinct regions.
      expect(regions.length, greaterThanOrEqualTo(3));
    });

    test('no duplicate IDs in sample data', () async {
      final locations = await service.getFlowerLocations();
      final ids = locations.map((l) => l.id).toList();
      final uniqueIds = ids.toSet();
      expect(uniqueIds.length, equals(ids.length),
          reason: 'Duplicate IDs found in sample data');
    });
  });
}
