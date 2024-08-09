enum WeatherType {
  clear,
  rainy,
}

class WeatherForecast {
  final WeatherType type;
  final String dateTime;
  final double rainIntensity;
  final double temperature;

  WeatherForecast(
      this.type, this.dateTime, this.rainIntensity, this.temperature);
}
