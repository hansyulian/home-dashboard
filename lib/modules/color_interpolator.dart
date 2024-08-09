import 'dart:ui';

class ColorInterpolator {
  final Color from;
  final Color to;

  ColorInterpolator(this.from, this.to);

  Color interpolate(num ratio) {
    // Ensure the ratio is between 0.0 and 1.0
    ratio = ratio.clamp(0.0, 1.0);

    // Interpolate each color component separately
    int red = (from.red + (to.red - from.red) * ratio).toInt();
    int green = (from.green + (to.green - from.green) * ratio).toInt();
    int blue = (from.blue + (to.blue - from.blue) * ratio).toInt();
    int alpha = (from.alpha + (to.alpha - from.alpha) * ratio).toInt();

    return Color.fromARGB(alpha, red, green, blue);
  }
}
