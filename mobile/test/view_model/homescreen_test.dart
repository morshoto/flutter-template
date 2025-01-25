import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:dishcovery/screens/question_flow_screen.dart';
import 'package:dishcovery/screens/home_screen.dart';
import 'package:dishcovery/provider/location_provider.dart';

import '../core/mock.dart';
import '../core/mock.mocks.dart';

void main() {
  group('QuestionFlowScreen Widget Tests', () {
    testWidgets('QuestionFlowScreen displays correctly',
        (WidgetTester tester) async {
      // モックのセットアップ
      final mockLocationProvider = MockLocationProvider();

      // モックのレスポンスを設定（必要に応じて）
      when(mockLocationProvider.currentPosition).thenReturn(null);

      // ウィジェットのビルド
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationProvider>.value(
            value: mockLocationProvider,
            child: QuestionFlowScreen(restaurantName: 'Test Restaurant'),
          ),
        ),
      );

      // タイトルが正しく表示されているか確認
      expect(find.text('Your Preferences @ Test Restaurant'), findsOneWidget);

      // 各ボタンが表示されているか確認
      expect(find.text('No Spice'), findsOneWidget);
      expect(find.text('Mild'), findsOneWidget);
      expect(find.text('Hot'), findsOneWidget);

      // チェックボックスが表示されているか確認
      expect(find.text('Include Meat'), findsOneWidget);
      expect(find.text('Include Seafood'), findsOneWidget);
      expect(find.text('Prefer Sweet'), findsOneWidget);

      // 'Get Recommendations' ボタンが表示されているか確認
      expect(find.text('Get Recommendations'), findsOneWidget);
    });

    testWidgets('Tapping buttons updates state', (WidgetTester tester) async {
      final mockLocationProvider = MockLocationProvider();

      when(mockLocationProvider.currentPosition).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationProvider>.value(
            value: mockLocationProvider,
            child: QuestionFlowScreen(restaurantName: 'Test Restaurant'),
          ),
        ),
      );

      // 'Mild' ボタンをタップ
      await tester.tap(find.text('Mild'));
      await tester.pump();

      // 'Mild' ボタンが青色に変わっていることを確認
      final mildButton = tester
          .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Mild'));
      expect(mildButton.style?.backgroundColor?.resolve({}), Colors.blue);
    });
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen displays correctly with data',
        (WidgetTester tester) async {
      final mockLocationProvider = MockLocationProvider();
      final mockHttpClient = MockClient();

      // モックのレスポンス設定
      when(mockLocationProvider.currentPosition).thenReturn(null);
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('[]', 200),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LocationProvider>.value(
            value: mockLocationProvider,
            child: HomeScreen(),
          ),
        ),
      );

      // タイトルや UI の確認
      expect(find.text('Discover Restaurants'), findsOneWidget);
      expect(find.byType(CupertinoSearchTextField), findsOneWidget);
      expect(find.text('No restaurants found.'), findsOneWidget);
    });
  });
}
