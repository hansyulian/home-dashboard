import 'package:home_dashboard/models/coin_tracker_data.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/modules/coin_market_cap_api_driver.dart';
import 'package:home_dashboard/modules/coin_market_cap_widget_driver.dart';
import 'package:home_dashboard/modules/coin_tracker_driver_base.dart';

class CoinTrackerDriver {
  final CoinTrackerWidgetSetting setting;
  late final CoinTrackerDriverBase _driver;

  CoinTrackerDriver(this.setting) {
    switch (setting.driver) {
      case 'coinMarketCapApi':
        if (setting.apiKey == null || setting.apiKey!.isEmpty) {
          throw Exception("Missing apiKey for Coin Market Cap API");
        }
        _driver = CoinMarketCapApiDriver(setting.apiKey!, setting.coinSymbols);
        break;
      default:
        _driver = CoinMarketCapWidgetDriver(setting.coinSymbols);
    }
  }

  Future<List<CoinTrackerData>> getAll() async {
    return _driver.getAll();
  }
}
