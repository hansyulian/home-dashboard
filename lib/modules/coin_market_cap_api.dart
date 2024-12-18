import 'package:home_dashboard/models/coin_market_cap_api_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinMarketCapApi {
  final List<String> coinSymbols;
  static const String _baseUrl =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';
  final String _apiKey;

  CoinMarketCapApi(this._apiKey, this.coinSymbols);

  Future<List<CoinMarketCapApiData>> getAll() async {
    try {
      // Ensure BTC is included in the query
      final updatedSymbols = List<String>.from(coinSymbols);
      if (!updatedSymbols.contains('BTC')) {
        updatedSymbols.add('BTC');
      }

      final symbols = updatedSymbols.join(',');
      final response = await http.get(
        Uri.parse('$_baseUrl?symbol=$symbols&convert=USD'),
        headers: {
          'Accepts': 'application/json',
          'X-CMC_PRO_API_KEY': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'] as Map<String, dynamic>;

        // Extract BTC price from the response
        final btcData = data['BTC'];
        final btcPriceUSD = btcData?['quote']['USD']['price'];

        if (btcPriceUSD == null) {
          throw Exception('BTC price not found in the response');
        }

        // Parse data into a Map of CoinMarketCapApiData objects
        final coinDataMap = data.map((symbol, coinData) {
          return MapEntry(
            symbol,
            CoinMarketCapApiData.fromJsonResponse(
              coinData,
              optionalBtcPriceOverride: btcPriceUSD,
            ),
          );
        });

        // Sort based on the order of coinSymbols
        return coinSymbols
            .where((symbol) =>
                coinDataMap.containsKey(symbol)) // Filter valid symbols
            .map((symbol) => coinDataMap[symbol]!)
            .toList();
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
