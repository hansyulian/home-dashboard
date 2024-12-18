class CoinMarketCapApiData {
  final int id;
  final String name;
  final String symbol;
  final double percentChange24H;
  final double percentChange7D;
  final double priceUSD;
  final double priceBTC;

  CoinMarketCapApiData(
    this.id,
    this.name,
    this.symbol,
    this.priceUSD,
    this.priceBTC,
    this.percentChange24H,
    this.percentChange7D,
  );

  // Factory constructor to parse JSON data with optional override
  factory CoinMarketCapApiData.fromJsonResponse(
    Map<String, dynamic> jsonResponse, {
    double? optionalBtcPriceOverride, // Optional named parameter
  }) {
    final quote = jsonResponse['quote']['USD'];
    final btcQuote = optionalBtcPriceOverride != null
        ? quote['price'] / optionalBtcPriceOverride
        : (jsonResponse['quote']['BTC']?['price'] ?? 0.0);
    return CoinMarketCapApiData(
      jsonResponse['id'],
      jsonResponse['name'],
      jsonResponse['symbol'],
      quote['price'],
      btcQuote,
      quote['percent_change_24h'] ?? 0.0,
      quote['percent_change_7d'] ?? 0.0,
    );
  }
}
