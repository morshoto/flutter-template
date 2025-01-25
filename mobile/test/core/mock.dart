import 'package:mockito/annotations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:dishcovery/provider/location_provider.dart';

// Mockitoを使用してMockクラスを生成
@GenerateMocks([LocationProvider, http.Client])
void main() {}
