import 'package:home_dashboard/models/coin_tracker_data.dart';

abstract class CoinTrackerDriverBase {
  Future<List<CoinTrackerData>> getAll();
}
