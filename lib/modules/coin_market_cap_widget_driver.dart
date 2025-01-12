import 'dart:convert';

import 'package:home_dashboard/models/coin_market_cap_widget_data.dart';
import 'package:home_dashboard/models/coin_tracker_data.dart';
import 'package:home_dashboard/modules/coin_tracker_driver_base.dart';
import 'package:home_dashboard/utils/print_debug.dart';
import 'package:http/http.dart' as http;

class CoinMarketCapWidgetDriver extends CoinTrackerDriverBase {
  final List<String> coinSymbols;

  CoinMarketCapWidgetDriver(this.coinSymbols);

  Future<List<CoinMarketCapWidgetData>> safeRetrieve() async {
    final coinSymbolsJoin = coinSymbols.join(',');
    final url = Uri.parse(
        'https://3rdparty-apis.coinmarketcap.com/v1/cryptocurrency/widget?symbol=$coinSymbolsJoin,BTC&convert_id=$usdCoinId,1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        List<CoinMarketCapWidgetData> result = [];
        double btcPriceUSD = 0;
        data.forEach((key, value) {
          if (value['symbol'] != "BTC") {
            return;
          }
          btcPriceUSD = value['quote']['$usdCoinId']['price'];
        });
        data.forEach((key, value) {
          CoinMarketCapWidgetData record =
              CoinMarketCapWidgetData.fromJsonResponse(value, btcPriceUSD);
          result.add(record);
        });
        result.sort((a, b) => coinSymbols
            .indexOf(a.symbol)
            .compareTo(coinSymbols.indexOf(b.symbol)));
        return result;
      } else {
        printDebug('Request failed ${response.body}');
        return [];
      }
    } catch (err) {
      printDebug('Request error $err');
      return [];
    }
  }

  @override
  Future<List<CoinTrackerData>> getAll() async {
    var data = await safeRetrieve();
    return data.map((record) {
      return CoinTrackerData(
          record.id,
          record.name,
          record.symbol,
          record.priceUSD,
          record.priceBTC,
          record.percentChange24H,
          record.percentChange7D);
    }).toList();
  }
}
