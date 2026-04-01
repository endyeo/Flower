import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/flower_location.dart';

/// Service that provides flower location data.
///
/// Data can come from the Korean 공공데이터포털 API or from the built-in
/// sample dataset when the API is unavailable or no key is configured.
class FlowerDataService {
  FlowerDataService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Set your 공공데이터포털 (data.go.kr) API key here.
  ///
  /// The app falls back to the embedded sample data when this is empty.
  static const String _apiKey = '';

  static const String _baseUrl =
      'https://api.odcloud.kr/api/15106827/v1/uddi:flower-viewing-spots';

  /// Returns flower locations. Tries the live API first; uses sample data
  /// as a fallback when the API key is absent or the call fails.
  Future<List<FlowerLocation>> getFlowerLocations() async {
    if (_apiKey.isNotEmpty) {
      try {
        return await _fetchFromApi();
      } catch (_) {
        // Fall back to sample data on any error.
      }
    }
    return _sampleFlowerLocations;
  }

  Future<List<FlowerLocation>> _fetchFromApi() async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'serviceKey': _apiKey,
      'page': '1',
      'perPage': '100',
    });

    final response = await _client.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          'API error: ${response.statusCode} ${response.reasonPhrase}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> data = body['data'] as List<dynamic>? ?? [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(FlowerLocation.fromJson)
        .toList();
  }

  /// Built-in representative flower viewing spots across Korea.
  /// Source: 문화체육관광부 꽃 구경 명소 공공데이터 (sample subset)
  static final List<FlowerLocation> _sampleFlowerLocations = [
    // ── 벚꽃 (Cherry Blossom) ──────────────────────────────────────────────
    const FlowerLocation(
      id: 'cb001',
      name: '여의도 윤중로',
      address: '서울특별시 영등포구 여의도동',
      position: LatLng(37.5241, 126.9335),
      flowerType: FlowerType.cherryBlossom,
      description: '한강변을 따라 약 1.7km에 걸쳐 벚꽃이 만개하는 서울의 대표적인 벚꽃 명소.',
      region: '서울',
    ),
    const FlowerLocation(
      id: 'cb002',
      name: '경주 불국사',
      address: '경상북도 경주시 불국로 385',
      position: LatLng(35.7897, 129.3316),
      flowerType: FlowerType.cherryBlossom,
      description: '유네스코 세계문화유산으로 지정된 불국사 경내에서 즐기는 봄 벚꽃.',
      region: '경상북도',
    ),
    const FlowerLocation(
      id: 'cb003',
      name: '진해 군항제',
      address: '경상남도 창원시 진해구',
      position: LatLng(35.1374, 128.6614),
      flowerType: FlowerType.cherryBlossom,
      description: '국내 최대 규모의 벚꽃 축제. 매년 4월 초 개최.',
      region: '경상남도',
    ),
    const FlowerLocation(
      id: 'cb004',
      name: '경포대 벚꽃길',
      address: '강원도 강릉시 경포로 365',
      position: LatLng(37.7930, 128.9076),
      flowerType: FlowerType.cherryBlossom,
      description: '경포호를 따라 늘어선 아름다운 벚꽃 가로수길.',
      region: '강원도',
    ),
    const FlowerLocation(
      id: 'cb005',
      name: '석촌호수 벚꽃축제',
      address: '서울특별시 송파구 송파동',
      position: LatLng(37.5100, 127.1014),
      flowerType: FlowerType.cherryBlossom,
      description: '석촌호수를 한 바퀴 둘러싼 벚꽃 산책로.',
      region: '서울',
    ),
    const FlowerLocation(
      id: 'cb006',
      name: '쌍계사 십리벚꽃길',
      address: '경상남도 하동군 화개면 쌍계사길',
      position: LatLng(35.2313, 127.5996),
      flowerType: FlowerType.cherryBlossom,
      description: '화개장터에서 쌍계사까지 이어지는 약 6km의 벚꽃 터널.',
      region: '경상남도',
    ),

    // ── 개나리 (Forsythia) ─────────────────────────────────────────────────
    const FlowerLocation(
      id: 'fs001',
      name: '남산 개나리 산책로',
      address: '서울특별시 중구 남산공원길 123',
      position: LatLng(37.5512, 126.9882),
      flowerType: FlowerType.forsythia,
      description: '남산을 따라 노란 개나리가 가득한 봄 산책로.',
      region: '서울',
    ),
    const FlowerLocation(
      id: 'fs002',
      name: '인천 자유공원',
      address: '인천광역시 중구 자유공원남로 25',
      position: LatLng(37.4759, 126.6267),
      flowerType: FlowerType.forsythia,
      description: '인천 자유공원 내 노란 개나리 군락지.',
      region: '인천',
    ),

    // ── 진달래 (Azalea) ────────────────────────────────────────────────────
    const FlowerLocation(
      id: 'az001',
      name: '비슬산 참꽃 군락지',
      address: '대구광역시 달성군 유가읍 비슬산길 281',
      position: LatLng(35.6832, 128.4953),
      flowerType: FlowerType.azalea,
      description: '봄이면 100만 송이 이상의 진달래가 비슬산을 붉게 물들이는 절경.',
      region: '대구',
    ),
    const FlowerLocation(
      id: 'az002',
      name: '소요산 진달래',
      address: '경기도 동두천시 소요동',
      position: LatLng(37.9288, 127.0614),
      flowerType: FlowerType.azalea,
      description: '소요산 전체가 분홍빛 진달래로 물드는 봄 명소.',
      region: '경기도',
    ),
    const FlowerLocation(
      id: 'az003',
      name: '황매산 진달래 & 철쭉',
      address: '경상남도 합천군 가회면 황매산로 1798',
      position: LatLng(35.5124, 127.9844),
      flowerType: FlowerType.azalea,
      description: '봄에 진달래와 철쭉이 동시에 피어 장관을 이루는 황매산.',
      region: '경상남도',
    ),

    // ── 유채꽃 (Rapeseed) ──────────────────────────────────────────────────
    const FlowerLocation(
      id: 'rs001',
      name: '제주 성산일출봉 유채꽃밭',
      address: '제주특별자치도 서귀포시 성산읍 성산리',
      position: LatLng(33.4584, 126.9429),
      flowerType: FlowerType.rapeseed,
      description: '성산일출봉을 배경으로 펼쳐진 노란 유채꽃 물결.',
      region: '제주',
    ),
    const FlowerLocation(
      id: 'rs002',
      name: '가파도 청보리 & 유채꽃',
      address: '제주특별자치도 서귀포시 대정읍 가파리',
      position: LatLng(33.1716, 126.2669),
      flowerType: FlowerType.rapeseed,
      description: '청보리와 유채꽃이 어우러지는 봄의 가파도 풍경.',
      region: '제주',
    ),
    const FlowerLocation(
      id: 'rs003',
      name: '광양 매화마을 유채꽃',
      address: '전라남도 광양시 다압면 섬진강매화로 794',
      position: LatLng(35.0699, 127.7214),
      flowerType: FlowerType.rapeseed,
      description: '섬진강변 매화마을 주변에 만발하는 유채꽃.',
      region: '전라남도',
    ),

    // ── 목련 (Magnolia) ────────────────────────────────────────────────────
    const FlowerLocation(
      id: 'mg001',
      name: '천리포수목원',
      address: '충청남도 태안군 소원면 천리포1길 187',
      position: LatLng(36.8973, 126.2178),
      flowerType: FlowerType.magnolia,
      description: '세계 최대 규모의 목련 컬렉션을 보유한 수목원.',
      region: '충청남도',
    ),
    const FlowerLocation(
      id: 'mg002',
      name: '창경궁 목련',
      address: '서울특별시 종로구 창경궁로 185',
      position: LatLng(37.5788, 126.9946),
      flowerType: FlowerType.magnolia,
      description: '창경궁 경내에서 봄을 알리는 흰 목련.',
      region: '서울',
    ),

    // ── 코스모스 (Cosmos) ──────────────────────────────────────────────────
    const FlowerLocation(
      id: 'cs001',
      name: '순천만 국가정원 코스모스',
      address: '전라남도 순천시 국가정원1호길 47',
      position: LatLng(34.9174, 127.4893),
      flowerType: FlowerType.cosmos,
      description: '가을이면 순천만 국가정원을 물들이는 코스모스 군락.',
      region: '전라남도',
    ),
    const FlowerLocation(
      id: 'cs002',
      name: '서울 하늘공원 코스모스',
      address: '서울특별시 마포구 하늘공원로 95',
      position: LatLng(37.5718, 126.8957),
      flowerType: FlowerType.cosmos,
      description: '서울 상암동 하늘공원의 드넓은 코스모스 꽃밭.',
      region: '서울',
    ),

    // ── 해바라기 (Sunflower) ───────────────────────────────────────────────
    const FlowerLocation(
      id: 'sf001',
      name: '태안 천리포 해바라기 축제',
      address: '충청남도 태안군 남면 신온리',
      position: LatLng(36.7323, 126.2648),
      flowerType: FlowerType.sunflower,
      description: '여름이면 드넓은 해바라기 밭이 펼쳐지는 태안 남면.',
      region: '충청남도',
    ),
    const FlowerLocation(
      id: 'sf002',
      name: '고창 해바라기 축제',
      address: '전라북도 고창군 공음면 선동리',
      position: LatLng(35.4437, 126.6935),
      flowerType: FlowerType.sunflower,
      description: '고창 학원농장 일대에서 열리는 여름 해바라기 축제.',
      region: '전라북도',
    ),

    // ── 등나무 (Wisteria) ──────────────────────────────────────────────────
    const FlowerLocation(
      id: 'ws001',
      name: '창덕궁 후원 등나무',
      address: '서울특별시 종로구 율곡로 99',
      position: LatLng(37.5819, 126.9914),
      flowerType: FlowerType.wisteria,
      description: '창덕궁 후원의 수령 수백 년 된 등나무 군락.',
      region: '서울',
    ),
    const FlowerLocation(
      id: 'ws002',
      name: '경남 함안 악양 등꽃 터널',
      address: '경상남도 함안군 악양면',
      position: LatLng(35.2744, 128.4060),
      flowerType: FlowerType.wisteria,
      description: '봄이면 보라빛 등나무꽃으로 뒤덮이는 아름다운 꽃 터널.',
      region: '경상남도',
    ),
  ];
}
