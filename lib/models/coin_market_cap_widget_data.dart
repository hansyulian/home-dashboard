import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

const Map<String, int> coinIds = {
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
  final CoinPriceQuote usdQuote;
  final CoinPriceQuote btcQuote;

  CoinMarketCapWidgetData(
    this.id,
    this.name,
    this.symbol,
    this.usdQuote,
    this.btcQuote,
  );

  factory CoinMarketCapWidgetData.fromJsonResponse(
      Map<String, dynamic> jsonResponse) {
    int id = safeParseInt(jsonResponse['id']) ?? 0;
    String name = jsonResponse['name'];
    String symbol = jsonResponse['symbol'];
    Map<String, dynamic> quote = jsonResponse['quote'];
    CoinPriceQuote usdQuote =
        CoinPriceQuote.fromJsonResponse(quote['$usdCoinId']);
    CoinPriceQuote btcQuote =
        CoinPriceQuote.fromJsonResponse(quote['$btcCoinId']);
    return CoinMarketCapWidgetData(id, name, symbol, usdQuote, btcQuote);
  }
}

class CoinPriceQuote {
  final double value;
  final double percentChange24H;
  final double percentChange7D;

  CoinPriceQuote(this.value, this.percentChange24H, this.percentChange7D);

  factory CoinPriceQuote.fromJsonResponse(Map<String, dynamic> jsonResponse) {
    double value = safeParseDouble(jsonResponse['price']) ?? 0;
    double percentChange24H =
        safeParseDouble(jsonResponse['percentChange24h']) ?? 0;
    double percentChange7D =
        safeParseDouble(jsonResponse['percentChange7d']) ?? 0;
    return CoinPriceQuote(value, percentChange24H, percentChange7D);
  }
}
