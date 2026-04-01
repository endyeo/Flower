import 'package:latlong2/latlong.dart';

/// Types of flowers that can be displayed on the map.
enum FlowerType {
  cherryBlossom, // 벚꽃
  forsythia, // 개나리
  azalea, // 진달래
  wisteria, // 등나무
  magnolia, // 목련
  rapeseed, // 유채꽃
  cosmos, // 코스모스
  sunflower, // 해바라기
  unknown,
}

extension FlowerTypeExtension on FlowerType {
  String get koreanName {
    switch (this) {
      case FlowerType.cherryBlossom:
        return '벚꽃';
      case FlowerType.forsythia:
        return '개나리';
      case FlowerType.azalea:
        return '진달래';
      case FlowerType.wisteria:
        return '등나무';
      case FlowerType.magnolia:
        return '목련';
      case FlowerType.rapeseed:
        return '유채꽃';
      case FlowerType.cosmos:
        return '코스모스';
      case FlowerType.sunflower:
        return '해바라기';
      case FlowerType.unknown:
        return '꽃';
    }
  }

  String get emoji {
    switch (this) {
      case FlowerType.cherryBlossom:
        return '🌸';
      case FlowerType.forsythia:
        return '🌼';
      case FlowerType.azalea:
        return '🌺';
      case FlowerType.wisteria:
        return '💜';
      case FlowerType.magnolia:
        return '🤍';
      case FlowerType.rapeseed:
        return '💛';
      case FlowerType.cosmos:
        return '🏵️';
      case FlowerType.sunflower:
        return '🌻';
      case FlowerType.unknown:
        return '🌷';
    }
  }

  /// Approximate bloom months (1-12).
  List<int> get bloomMonths {
    switch (this) {
      case FlowerType.cherryBlossom:
        return [3, 4];
      case FlowerType.forsythia:
        return [3, 4];
      case FlowerType.azalea:
        return [4, 5];
      case FlowerType.wisteria:
        return [4, 5];
      case FlowerType.magnolia:
        return [3, 4];
      case FlowerType.rapeseed:
        return [3, 4, 5];
      case FlowerType.cosmos:
        return [9, 10];
      case FlowerType.sunflower:
        return [7, 8];
      case FlowerType.unknown:
        return [];
    }
  }
}

/// Represents a flower viewing location.
class FlowerLocation {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final FlowerType flowerType;
  final String? description;
  final String? imageUrl;
  final String? region;

  const FlowerLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.flowerType,
    this.description,
    this.imageUrl,
    this.region,
  });

  /// Creates a [FlowerLocation] from a JSON map (e.g., from 공공데이터포털 API).
  factory FlowerLocation.fromJson(Map<String, dynamic> json) {
    final double lat = double.tryParse(
          json['latitude']?.toString() ??
              json['lat']?.toString() ??
              json['LATITUDE']?.toString() ??
              '0',
        ) ??
        0.0;
    final double lng = double.tryParse(
          json['longitude']?.toString() ??
              json['lng']?.toString() ??
              json['LONGITUDE']?.toString() ??
              '0',
        ) ??
        0.0;

    return FlowerLocation(
      id: json['id']?.toString() ?? json['ESNTL_ID']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['FCLTY_NM']?.toString() ??
          json['title']?.toString() ??
          '',
      address: json['address']?.toString() ??
          json['RDNMADR_NM']?.toString() ??
          json['addr']?.toString() ??
          '',
      position: LatLng(lat, lng),
      flowerType: _parseFlowerType(
        json['flowerType']?.toString() ?? json['FLOWER_NM']?.toString() ?? '',
      ),
      description: json['description']?.toString() ?? json['SUMRY']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? json['THUMB_IMGE_URL']?.toString(),
      region: json['region']?.toString() ?? json['CTPRVN_NM']?.toString(),
    );
  }

  static FlowerType _parseFlowerType(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('벚꽃') || lower.contains('cherry')) {
      return FlowerType.cherryBlossom;
    } else if (lower.contains('개나리') || lower.contains('forsythia')) {
      return FlowerType.forsythia;
    } else if (lower.contains('진달래') || lower.contains('azalea')) {
      return FlowerType.azalea;
    } else if (lower.contains('등나무') || lower.contains('wisteria')) {
      return FlowerType.wisteria;
    } else if (lower.contains('목련') || lower.contains('magnolia')) {
      return FlowerType.magnolia;
    } else if (lower.contains('유채') || lower.contains('rapeseed')) {
      return FlowerType.rapeseed;
    } else if (lower.contains('코스모스') || lower.contains('cosmos')) {
      return FlowerType.cosmos;
    } else if (lower.contains('해바라기') || lower.contains('sunflower')) {
      return FlowerType.sunflower;
    }
    return FlowerType.unknown;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'flowerType': flowerType.name,
        'description': description,
        'imageUrl': imageUrl,
        'region': region,
      };

  @override
  String toString() =>
      'FlowerLocation(id: $id, name: $name, flowerType: ${flowerType.koreanName})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowerLocation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
