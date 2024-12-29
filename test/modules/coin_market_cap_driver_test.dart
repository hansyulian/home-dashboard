import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/modules/coin_market_cap_widget_driver.dart';
import 'package:http/http.dart' as http;

void main() {
  group('CoinMarketCapDriver', () {
    setUp(() {});

    test('retrieve returns data when HTTP call completes successfully',
        () async {
      final driver = CoinMarketCapApiDriver(['BTC', 'ETH']);
      final result = await driver.safeRetrieve();
      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result.first.name, 'Bitcoin');
      expect(result.last.name, 'Ethereum');
    });
    test(
        'retrieve returns data when HTTP call completes successfully, ignoring the errors',
        () async {
      final driver = CoinMarketCapApiDriver(['BTC', 'Invalid']);
      final result = await driver.safeRetrieve();
      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result.first.name, 'Bitcoin');
    });

    test('getByCoin returns data when coinId is valid', () async {
      final result = await CoinMarketCapApiDriver.getByCoin('BTC');
      expect(result, isNotNull);
      expect(result!.name, 'Bitcoin');
    });

    test('getByCoin returns null when coinId is invalid', () async {
      final result = await CoinMarketCapApiDriver.getByCoin('INVALID');
      expect(result, isNull);
    });
  });
}
