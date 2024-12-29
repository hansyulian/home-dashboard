class CoinTrackerData {
  final int id;
  final String name;
  final String symbol;
  final double percentChange24H;
  final double percentChange7D;
  final double priceUSD;
  final double priceBTC;

  CoinTrackerData(
    this.id,
    this.name,
    this.symbol,
    this.priceUSD,
    this.priceBTC,
    this.percentChange24H,
    this.percentChange7D,
  );
}
