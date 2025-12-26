import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_dashboard/models/coin_market_cap_widget_data.dart';
import 'package:home_dashboard/models/coin_tracker_data.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/modules/coin_tracker_driver.dart';
import 'package:home_dashboard/utils/number_value_display.dart';

const headerScale = 1.2;
const baseSize = 24;

class CoinTrackerWidget extends StatefulWidget {
  final CoinTrackerWidgetSetting setting;
  const CoinTrackerWidget(this.setting, {super.key});

  @override
  State<CoinTrackerWidget> createState() => CoinTrackerState();
}

class CoinTrackerState extends State<CoinTrackerWidget> {
  late Timer _timer;
  late CoinTrackerDriver _coinTrackerDriver;
  List<CoinTrackerData> _coinTrackerData = [];
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _coinTrackerDriver = CoinTrackerDriver(widget.setting);
    setState(() {
      _isTimerRunning = false;
    });
    _startFetcher();
  }

  void _startFetcher() {
    _fetchCoinData();
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: widget.setting.refreshInSecond),
        (timer) async {
      if (!_isTimerRunning) {
        return;
      }
      _fetchCoinData();
    });
  }

  void _fetchCoinData() async {
    var responseData = await _coinTrackerDriver.getAll();
    setState(() {
      _coinTrackerData = responseData;
    });
  }

  @override
  void dispose() {
    setState(() {
      _isTimerRunning = false;
    });
    super.dispose();
    _timer.cancel();
  }

  static Color calculateColor(double value) {
    if (value < 0) {
      return Colors.red;
    }
    return Colors.green;
  }

  double get scaledSize {
    return baseSize * widget.setting.size;
  }

  double get headerSize {
    return scaledSize * headerScale;
  }

  renderTableHeader() {
    return TableRow(children: [
      CoinTableHeader(text: 'Coin', size: headerSize),
      CoinTableHeader(text: 'USD', size: headerSize),
      CoinTableHeader(text: 'Satoshi', size: headerSize),
      CoinTableHeader(text: '24H', size: headerSize),
      CoinTableHeader(text: '7D', size: headerSize),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            border: TableBorder.all(color: Colors.grey, width: 0.5),
            children: [
              renderTableHeader(),
              ..._coinTrackerData.map((coinData) {
                return TableRow(children: [
                  CoinTableCell(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://s2.coinmarketcap.com/static/img/coins/64x64/${coinData.id}.png',
                            height: scaledSize,
                            width: scaledSize,
                          ),
                          const SizedBox(width: 8),
                          CoinText(coinData.symbol, scaledSize),
                        ]),
                  ),
                  CoinTableCell(
                    child: CoinText(
                      numberValueDisplay(coinData.priceUSD,
                          targetLength: 5, minimumDecimal: 0),
                      scaledSize,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  CoinTableCell(
                    child: SatoshiText(coinData, scaledSize),
                  ),
                  CoinTableCell(
                    child: CoinText(
                      '${numberValueDisplay(coinData.percentChange24H.abs(), minimumDecimal: 1, targetLength: 1)}%',
                      scaledSize,
                      textAlign: TextAlign.right,
                      color: calculateColor(coinData.percentChange24H),
                    ),
                  ),
                  CoinTableCell(
                    child: CoinText(
                      '${numberValueDisplay(coinData.percentChange7D.abs(), minimumDecimal: 1, targetLength: 1)}%',
                      scaledSize,
                      textAlign: TextAlign.right,
                      color: calculateColor(coinData.percentChange7D),
                    ),
                  ),
                ]);
              }),
            ],
          ),
        ));
  }
}

class SatoshiText extends StatelessWidget {
  final CoinTrackerData coinData;
  final double size;
  const SatoshiText(this.coinData, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    if (coinData.id == btcCoinId) {
      return Container();
    }
    var satoshi = coinData.priceBTC * 100000000;
    return CoinText(
        textAlign: TextAlign.right,
        numberValueDisplay(satoshi, minimumDecimal: 0, targetLength: 1),
        size);
  }
}

class CoinTableHeaderText extends StatelessWidget {
  final String text;
  final double size;

  const CoinTableHeaderText(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return CoinText(text, size,
        fontWeight: FontWeight.bold, textAlign: TextAlign.center);
  }
}

class CoinText extends StatelessWidget {
  final String text;
  final double size;
  final Color? _color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  const CoinText(this.text, this.size,
      {super.key, Color? color, this.textAlign, this.fontWeight})
      : _color = color;

  Color get color {
    if (_color != null) {
      return _color;
    }
    return const Color(0xEEEEEEFF);
  }

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
            color: color,
            fontSize: size,
            height: 1.0,
            decoration: TextDecoration.none,
            fontWeight: fontWeight ?? FontWeight.normal));
  }
}

class CoinTableHeader extends StatelessWidget {
  final String text;
  final double size;

  const CoinTableHeader({
    required this.text,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: CoinTableHeaderText(text, size),
      ),
    );
  }
}

class CoinTableCell extends StatelessWidget {
  final Widget child;

  const CoinTableCell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(12.0), // Add padding if needed
        child: child,
      ),
    );
  }
}
