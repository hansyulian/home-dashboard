import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

const Map<String, int> COIN_IDS = {
  'BTC': 1,
  'ETH': 1027,
  'BCH': 1831,
  'LTC': 2,
  'DFI': 5804,
  'USD': 2781,
  'SOL': 5426,
  'DOT': 6636,
  'MATIC': 3890,
};
const btcCoinId = 1;
const usdCoinId = 2781;

class CoinMarketCapWidgetData {
  final int id;
  final String name;
  final String symbol;
  final double percentChange24H;
  final double percentChange7D;
  final double priceUSD;
  final double priceBTC;

  CoinMarketCapWidgetData(
    this.id,
    this.name,
    this.symbol,
    this.priceUSD,
    this.priceBTC,
    this.percentChange24H,
    this.percentChange7D,
  );

  factory CoinMarketCapWidgetData.fromJsonResponse(
      Map<String, dynamic> jsonResponse) {
    int id = safeParseInt(jsonResponse['id']) ?? 0;
    String name = jsonResponse['name'];
    String symbol = jsonResponse['symbol'];
    Map<String, dynamic> quote = jsonResponse['quote'];
    Map<String, dynamic> btcQuote = quote['$btcCoinId'];
    Map<String, dynamic> usdQuote = quote['$usdCoinId'];
    return CoinMarketCapWidgetData(
        id,
        name,
        symbol,
        safeParseDouble(usdQuote['price']) ?? 0,
        safeParseDouble(btcQuote['price']) ?? 0,
        usdQuote['percent_change_24h'],
        usdQuote['percent_change_7d']);
  }
}
