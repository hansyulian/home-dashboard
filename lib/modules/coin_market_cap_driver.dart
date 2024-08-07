import 'dart:convert';

import 'package:home_dashboard/models/coin_market_cap_widget_data.dart';
import 'package:home_dashboard/utils/print_debug.dart';
import 'package:http/http.dart' as http;

class CoinMarketCapDriver {
  final List<String> coinIds;

  CoinMarketCapDriver(this.coinIds);

  Future<List<CoinMarketCapWidgetData>> safeRetrieve() async {
    List<CoinMarketCapWidgetData?> retrievedData =
        await Future.wait(coinIds.map((coinId) {
      return getByCoin(coinId);
    }));
    List<CoinMarketCapWidgetData> result = [];
    for (var item in retrievedData) {
      if (item != null) {
        result.add(item);
      }
    }
    return result;
  }

  static Future<CoinMarketCapWidgetData?> getByCoin(String coin) async {
    if (!COIN_IDS.containsKey(coin)) {
      return null;
    }
    final coinId = COIN_IDS[coin];
    final url = Uri.parse(
        'https://3rdparty-apis.coinmarketcap.com/v1/cryptocurrency/widget?id=$coinId&convert_id=$btcCoinId,$usdCoinId');
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final result = CoinMarketCapWidgetData.fromJsonResponse(
            jsonBody['data']['$coinId']);
        return result;
      } else {
        printDebug('Request failed ${response.body}');
        return null;
      }
    } catch (err) {
      printDebug('Request error $err');
      return null;
    }
  }
}
