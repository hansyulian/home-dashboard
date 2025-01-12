import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

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
      Map<String, dynamic> jsonResponse, double btcPriceUSD) {
    int id = safeParseInt(jsonResponse['id']) ?? 0;
    String name = jsonResponse['name'];
    String symbol = jsonResponse['symbol'];
    Map<String, dynamic> quote = jsonResponse['quote'];
    Map<String, dynamic> usdQuote = quote['$usdCoinId'];
    final usdPrice = usdQuote['price'] ?? 0;
    final btcPrice = usdPrice / btcPriceUSD;
    return CoinMarketCapWidgetData(id, name, symbol, usdPrice, btcPrice,
        usdQuote['percent_change_24h'], usdQuote['percent_change_7d']);
  }
}
