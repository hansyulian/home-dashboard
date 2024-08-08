import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/models/coin_market_cap_widget_data.dart';

void main() {
  test('CoinMarketCapWidgetData.fromJsonResponse parses JSON correctly', () {
    // Sample JSON data
    const jsonResponse = {
      "id": 1,
      "name": "Bitcoin",
      "symbol": "BTC",
      "slug": "bitcoin",
      "num_market_pairs": 11628,
      "date_added": "2010-07-13T00:00:00.000Z",
      "tags": [
        "mineable",
        "pow",
        "sha-256",
        "store-of-value",
        "state-channel",
        "coinbase-ventures-portfolio",
        "three-arrows-capital-portfolio",
        "polychain-capital-portfolio",
        "binance-labs-portfolio",
        "blockchain-capital-portfolio",
        "boostvc-portfolio",
        "cms-holdings-portfolio",
        "dcg-portfolio",
        "dragonfly-capital-portfolio",
        "electric-capital-portfolio",
        "fabric-ventures-portfolio",
        "framework-ventures-portfolio",
        "galaxy-digital-portfolio",
        "huobi-capital-portfolio",
        "alameda-research-portfolio",
        "a16z-portfolio",
        "1confirmation-portfolio",
        "winklevoss-capital-portfolio",
        "usv-portfolio",
        "placeholder-ventures-portfolio",
        "pantera-capital-portfolio",
        "multicoin-capital-portfolio",
        "paradigm-portfolio",
        "bitcoin-ecosystem",
        "ftx-bankruptcy-estate"
      ],
      "max_supply": 21000000,
      "circulating_supply": 19736700,
      "total_supply": 19736700,
      "is_active": 1,
      "cmc_rank": 1,
      "is_fiat": 0,
      "last_updated": "2024-08-07T08:32:00.000Z",
      "quote": {
        "1": {
          "price": 1,
          "volume_24h": 805537.2844653013,
          "percent_change_1h": 0.67339468,
          "percent_change_24h": 3.20956221,
          "percent_change_7d": -13.72784535,
          "market_cap": 19736700,
          "last_updated": "2024-08-07T08:32:00.000Z"
        },
        "2781": {
          "price": 57165.4690932454,
          "volume_24h": 46048916738.558014,
          "percent_change_1h": 0.67339468,
          "percent_change_24h": 3.20956221,
          "percent_change_7d": -13.72784535,
          "market_cap": 1128257713852.6565,
          "last_updated": "2024-08-07T08:31:58.000Z"
        }
      }
    };

    // Parse the CoinMarketCapWidgetData from the JSON data
    final widgetData = CoinMarketCapWidgetData.fromJsonResponse(jsonResponse);

    // Verify the parsed data
    expect(widgetData.id, 1);
    expect(widgetData.name, "Bitcoin");
    expect(widgetData.symbol, "BTC");

    expect(widgetData.priceUSD, 57165.4690932454);
    expect(widgetData.percentChange24H, 3.20956221);
    expect(widgetData.percentChange7D, -13.72784535);

    expect(widgetData.priceBTC, 1);
  });
}
