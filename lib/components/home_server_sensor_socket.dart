import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_dashboard/components/grid.dart';
import 'package:home_dashboard/components/space.dart';
import 'package:home_dashboard/models/home_server_sensor.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/utils/decimal_aligner.dart';
import 'package:home_dashboard/utils/log_scaler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart'; // Specifically for non-web platforms (desktop, mobile)

// Define a constant for maximum network speed for scaling purposes.
// This value can be adjusted based on your expected network capabilities.
const double maxNetworkSpeed = 12 * 1024 * 1024; // 12 MB/s in bytes
const int pingHistoryLength = 100;

class HomeServerSensorSocketWidget extends StatefulWidget {
  final HomeServerSensorSocketWidgetSetting setting;

  const HomeServerSensorSocketWidget(this.setting, {super.key});

  @override
  State<StatefulWidget> createState() => HomeServerSensorSocketWidgetState();
}

class HomeServerSensorSocketWidgetState
    extends State<HomeServerSensorSocketWidget> {
  // Holds the latest sensor information received from the WebSocket.
  HomeServerSensor? _sensorInfo;
  // Timer for scheduling reconnection attempts.
  Timer? _reconnectTimer;
  // Flag to prevent multiple simultaneous WebSocket connection attempts.
  bool _isConnecting = false;
  // The WebSocket channel for communication with the server. Made nullable for safe initialization.
  IOWebSocketChannel? _channel;
  final List<List<HomeServerPingInfo>> _pingHistories = [];

  @override
  void initState() {
    super.initState();
    // Establish the WebSocket connection when the widget is initialized.
    _connectSocket();
  }

  @override
  void dispose() {
    // Cancel any active reconnection timer to prevent memory leaks.
    _reconnectTimer?.cancel();
    // Close the WebSocket connection gracefully.
    // Using null-safe operator ?. to prevent errors if _channel was never initialized.
    _channel?.sink.close();
    print('WebSocket connection closed by client.');
    super.dispose();
  }

  /// Establishes or re-establishes the WebSocket connection.
  void _connectSocket() {
    // If already attempting to connect, or if the widget is no longer mounted, do nothing.
    if (_isConnecting || !mounted) {
      return;
    }

    _isConnecting =
        true; // Set flag to indicate connection attempt is in progress.
    print(
        'Attempting to connect to WebSocket: ${widget.setting.socketEndpoint}');

    try {
      _channel =
          IOWebSocketChannel.connect(Uri.parse(widget.setting.socketEndpoint));

      _channel!.stream.listen(
        (message) {
          // Update UI with new data.
          // setState is crucial to trigger a rebuild of the widget with new data.
          setState(() {
            try {
              final jsonMessage = json.decode(message);
              _sensorInfo = HomeServerSensor.fromJson(jsonMessage);
              _pingHistories.insert(0, _sensorInfo!.pings);
              if (_pingHistories.length > pingHistoryLength) {
                _pingHistories.removeRange(
                    pingHistoryLength, _pingHistories.length);
              }
            } catch (e) {
              print('Error parsing WebSocket message: $e, Message: $message');
              // Optionally, display an error message to the user or log it.
            }
          });
          _isConnecting = false; // Connection successful, reset flag.
          _reconnectTimer?.cancel(); // Cancel any pending reconnect timers.
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _isConnecting = false; // Connection failed, reset flag.
          _scheduleReconnect(); // Schedule a reconnection attempt.
        },
        onDone: () {
          print('WebSocket connection done/disconnected.');
          _isConnecting = false; // Connection closed, reset flag.
          _scheduleReconnect(); // Schedule a reconnection attempt.
        },
      );
    } catch (e) {
      print('Failed to establish WebSocket connection: $e');
      _isConnecting = false;
      _scheduleReconnect(); // Schedule a reconnection attempt if initial connection fails.
    }
  }

  /// Schedules a reconnection attempt after a delay.
  void _scheduleReconnect() {
    // Ensure only one reconnect timer is active at a time.
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        // Only attempt to reconnect if the widget is still in the tree.
        _connectSocket();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading indicator if sensor data hasn't been received yet.
    if (_sensorInfo == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue), // Customizable color
            SizedBox(height: 16), // Use SizedBox for consistent spacing
            Text(
              'Connecting to server...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                decoration:
                    TextDecoration.none, // Ensure no default text decoration
              ),
            ),
          ],
        ),
      );
    }

    // Once data is available, render the dashboard content.
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _renderSystem(),
          _renderPings(),
          _renderHdds(),
          // _renderZpool() // Keep commented out as per original request
        ],
      ),
    );
  }

  /// Renders the system usage (CPU, Memory, Network) as a bar chart.
  Widget _renderSystem() {
    // Ensure _sensorInfo and its properties are not null before accessing.
    if (_sensorInfo == null || _sensorInfo!.system == null) {
      return const SizedBox.shrink(); // Return an empty widget if no data
    }
    final system = _sensorInfo!.system;

    // Calculate network rates, applying a square root for non-linear scaling.
    // Ensure null safety for network properties.
    final num uploadRate =
        pow(1.0 * (system.network?.upload ?? 0) / maxNetworkSpeed, 0.5);
    final num downloadRate =
        pow(1.0 * (system.network?.download ?? 0) / maxNetworkSpeed, 0.5);

    // Prepare data for the bar chart.
    final List<UsageData> usageData = [
      UsageData('CPU',
          logScaler(system.cpu?.total ?? 0)), // Ensure cpu.total is null-safe
      UsageData(
          'Memory',
          (system.memory?.usageRatio ??
              0)), // Ensure memory.usageRatio is null-safe
      UsageData('Upload', uploadRate),
      UsageData('Download', downloadRate),
    ];

    return SizedBox(
      height: 150,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          maximum: 1,
          interval: 0.1,
          labelStyle:
              TextStyle(color: Colors.transparent), // Hide Y-axis labels
        ),
        series: [
          BarSeries<UsageData, String>(
            dataSource: usageData,
            xValueMapper: (UsageData data, _) => data.category,
            yValueMapper: (UsageData data, _) => data.usagePercentage,
            dataLabelSettings:
                const DataLabelSettings(isVisible: false), // Hide data labels
            animationDuration: 0, // Disable animation for faster updates
            animationDelay: 0,
          ),
        ],
      ),
    );
  }

  /// Renders the HDD status as a grid of cards.
  Widget _renderHdds() {
    // Ensure _sensorInfo and its properties are not null.
    if (_sensorInfo == null || _sensorInfo!.hdds == null) {
      return const SizedBox.shrink();
    }

    final hdds = _sensorInfo!.hdds;
    // Optimized check: return Container if no HDD is active (not 'standby').
    final bool shouldVisible = hdds.any((hdd) => hdd.status != 'standby');

    if (!shouldVisible) {
      return const SizedBox.shrink(); // Use SizedBox.shrink() for empty space
    }

    return Column(
      children: [
        Space(), // Use const for performance
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_renderText("Drive Status")],
        ),
        Space(),
        Grid<HomeServerHddInfo>(
          // Specify generic type for Grid for clarity
          hdds,
          (item, index) => Card(
            color: item
                .indicatorColor, // Assumes indicatorColor is defined in Hdd model
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _renderText(
                      item.name ?? 'Unknown'), // Add null check for name
                  _renderText(item.status ?? 'N/A') // Add null check for status
                ],
              ),
            ),
          ),
          columns: 2,
          horizontalGap: 8,
          verticalGap: 8,
        ),
      ],
    );
  }

  /// Renders ping status and a graph of ping history.
  Widget _renderPings() {
    // Ensure _sensorInfo and its properties are not null.
    if (_sensorInfo == null ||
        _sensorInfo!.pings == null ||
        _sensorInfo!.pings.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> children = [
      Space(),
      _renderText("Ping Status"),
      Space(),
    ];

    for (int i = 0; i < _sensorInfo!.pings.length; i++) {
      final record = _sensorInfo!.pings[i];
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _renderText(record.target ?? 'Unknown'), // Null check for target
            _renderText(
              '${decimalAligner(record.lastValue ?? 0, left: 3, right: 3)} ms',
            ),
          ],
        ),
      );
      children.add(Space());
    }
    children.add(_renderPingGraph());
    return Column(
      children: children,
    );
  }

  List<PingDataHolder> _getPingHistoryGraphValues() {
    List<PingDataHolder> pingDataHolders = [];
    if (_pingHistories.isEmpty) {
      return [];
    }
    int pingTargetCounts = _pingHistories.first.length;
    int length = _pingHistories.length;
    for (int i = 0; i < pingTargetCounts; i++) {
      double min = double.infinity;
      double max = 0;
      double average = 0;
      int total = 0;
      List<double> scaledValues = [];
      for (int j = 0; j < length; j++) {
        final record = _pingHistories[j][i];
        final value = record.lastValue;
        if (value != 0 && value != null) {
          min = min < value ? min : value;
          max = max > value ? max : value;
          total += 1;
          scaledValues.add(value);
        } else {
          scaledValues.add(-1);
        }
      }

      if (total > 0) {
        average = average / total;
      }

      for (var i = 0; i < scaledValues.length; i++) {
        if (scaledValues[i] >= 0) {
          var valueScale = (scaledValues[i] - min) / (max - min);
          scaledValues[i] = valueScale;
        }
      }
      while (scaledValues.length < pingHistoryLength) {
        scaledValues.add(0);
      }
      pingDataHolders.add(PingDataHolder(scaledValues, min, max, average));
    }
    return pingDataHolders;
  }

  /// Renders a line graph of ping history for multiple targets.
  Widget _renderPingGraph() {
    if (_sensorInfo == null ||
        _sensorInfo!.pings == null ||
        _sensorInfo!.pings.isEmpty) {
      return const SizedBox.shrink();
    }

    // Process ping data to create PingDataHolder objects for charting.

    final pingDataHolders = _getPingHistoryGraphValues();

    // Sort ping data holders by average ping for consistent graph ordering.
    pingDataHolders.sort((a, b) => a.average.compareTo(b.average));

    // Calculate the maximum Y-axis value needed for stacking the lines.
    // Each line is scaled 0-1, and then an offset (4.0) is added per series.
    final double maxYAxis = pingDataHolders.isEmpty
        ? 1.0
        : (1.0 +
            (pingDataHolders.length - 1) * 4.0 +
            1.0); // 1.0 for max scaled value, 4.0 for offset, plus a little buffer

    return SizedBox(
      height: 100,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          isVisible: false, // Hide X-axis
        ),
        primaryYAxis: NumericAxis(
          isVisible: false, // Hide Y-axis
          minimum: 0,
          maximum: maxYAxis, // Dynamic maximum based on stacked series
        ),
        series: pingDataHolders.asMap().entries.map((entry) {
          final int index = entry.key;
          final PingDataHolder data = entry.value;

          // Map scaled values to ChartData objects, adding the vertical offset for stacking.
          final List<ChartData> pingSeriesData =
              data.scaledValues.asMap().entries.map((svEntry) {
            final int svIndex = svEntry.key;
            final double? svValue = svEntry.value;
            // Add vertical offset: +1.0 ensures lines start above 0, index * 4.0 separates them.
            return ChartData(
                svIndex, svValue == null ? null : svValue + index * 4.0 + 1.0);
          }).toList();

          return LineSeries<ChartData, int>(
            dataSource: pingSeriesData,
            xValueMapper: (ChartData chartData, _) => chartData.x,
            yValueMapper: (ChartData chartData, _) => chartData.y,
            animationDuration: 0, // Disable animation for real-time updates
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: false, // Tooltips can be enabled if desired
          );
        }).toList(),
      ),
    );
  }

  /// Helper widget to render text with consistent styling.
  Widget _renderText(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 16,
        height: 1.0, // Line height
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.none, // Explicitly no text decoration
      ),
    );
  }
}

/// Data model for system usage statistics in the bar chart.
class UsageData {
  const UsageData(this.category, this.usagePercentage);
  final String category;
  final num usagePercentage;
}

/// Data model to hold processed ping history for charting.
class PingDataHolder {
  final double min;
  final double max;
  final double average;
  final List<double?> scaledValues; // Nullable to represent missing data points

  const PingDataHolder(this.scaledValues, this.min, this.max, this.average);
}

/// A simple data class for Syncfusion Chart series.
class ChartData {
  final int x;
  final double?
      y; // Y-value is nullable to handle missing data points in charts

  const ChartData(this.x, this.y);
}
