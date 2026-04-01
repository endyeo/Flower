import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:flower/models/flower_location.dart';

void main() {
  group('FlowerType', () {
    test('koreanName returns correct names', () {
      expect(FlowerType.cherryBlossom.koreanName, '벚꽃');
      expect(FlowerType.forsythia.koreanName, '개나리');
      expect(FlowerType.azalea.koreanName, '진달래');
      expect(FlowerType.wisteria.koreanName, '등나무');
      expect(FlowerType.magnolia.koreanName, '목련');
      expect(FlowerType.rapeseed.koreanName, '유채꽃');
      expect(FlowerType.cosmos.koreanName, '코스모스');
      expect(FlowerType.sunflower.koreanName, '해바라기');
    });

    test('emoji returns non-empty string for all types', () {
      for (final type in FlowerType.values) {
        expect(type.emoji.isNotEmpty, isTrue);
      }
    });

    test('bloomMonths returns correct months for cherry blossom', () {
      expect(FlowerType.cherryBlossom.bloomMonths, containsAll([3, 4]));
    });

    test('bloomMonths for unknown is empty', () {
      expect(FlowerType.unknown.bloomMonths, isEmpty);
    });
  });

  group('FlowerLocation', () {
    const location = FlowerLocation(
      id: 'test001',
      name: '여의도 윤중로',
      address: '서울특별시 영등포구 여의도동',
      position: LatLng(37.5241, 126.9335),
      flowerType: FlowerType.cherryBlossom,
      description: '벚꽃 명소',
      region: '서울',
    );

    test('toString contains name and flowerType', () {
      expect(location.toString(), contains('여의도 윤중로'));
      expect(location.toString(), contains('벚꽃'));
    });

    test('equality is based on id', () {
      const same = FlowerLocation(
        id: 'test001',
        name: '다른 이름',
        address: '다른 주소',
        position: LatLng(0, 0),
        flowerType: FlowerType.forsythia,
      );
      expect(location, equals(same));
    });

    test('hashCode is based on id', () {
      const same = FlowerLocation(
        id: 'test001',
        name: '다른 이름',
        address: '다른 주소',
        position: LatLng(0, 0),
        flowerType: FlowerType.forsythia,
      );
      expect(location.hashCode, equals(same.hashCode));
    });

    test('fromJson parses cherry blossom correctly', () {
      final json = {
        'id': 'cb001',
        'name': '여의도 윤중로',
        'address': '서울특별시 영등포구',
        'latitude': '37.5241',
        'longitude': '126.9335',
        'flowerType': '벚꽃',
        'region': '서울',
      };
      final parsed = FlowerLocation.fromJson(json);
      expect(parsed.id, 'cb001');
      expect(parsed.name, '여의도 윤중로');
      expect(parsed.flowerType, FlowerType.cherryBlossom);
      expect(parsed.position.latitude, closeTo(37.5241, 0.0001));
      expect(parsed.position.longitude, closeTo(126.9335, 0.0001));
      expect(parsed.region, '서울');
    });

    test('fromJson with alternative field names (공공데이터포털 format)', () {
      final json = {
        'ESNTL_ID': 'api001',
        'FCLTY_NM': '경복궁 벚꽃길',
        'RDNMADR_NM': '서울특별시 종로구 사직로 161',
        'LATITUDE': '37.5790',
        'LONGITUDE': '126.9770',
        'FLOWER_NM': '벚꽃',
        'CTPRVN_NM': '서울',
      };
      final parsed = FlowerLocation.fromJson(json);
      expect(parsed.id, 'api001');
      expect(parsed.name, '경복궁 벚꽃길');
      expect(parsed.flowerType, FlowerType.cherryBlossom);
    });

    test('fromJson handles unknown flower type gracefully', () {
      final json = {
        'id': 'u001',
        'name': '알 수 없는 꽃',
        'address': '주소',
        'latitude': '37.0',
        'longitude': '127.0',
        'flowerType': '알 수 없음',
      };
      final parsed = FlowerLocation.fromJson(json);
      expect(parsed.flowerType, FlowerType.unknown);
    });

    test('fromJson handles missing lat/lng gracefully', () {
      final json = {
        'id': 'u002',
        'name': '좌표 없음',
        'address': '주소',
      };
      final parsed = FlowerLocation.fromJson(json);
      expect(parsed.position.latitude, 0.0);
      expect(parsed.position.longitude, 0.0);
    });

    test('toJson round-trip', () {
      final json = location.toJson();
      expect(json['id'], location.id);
      expect(json['name'], location.name);
      expect(json['latitude'], location.position.latitude);
      expect(json['longitude'], location.position.longitude);
      expect(json['flowerType'], location.flowerType.name);
      expect(json['region'], location.region);
    });
  });
}
