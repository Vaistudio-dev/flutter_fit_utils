/// Extension of the [Duration] class.
extension DurationUtils on Duration {
  /// Override the / operator to divide a [Duration] by an [int].
  Duration operator /(int other) =>
      Duration(microseconds: inMicroseconds ~/ other);

  /// Returns the sum of two [Duration].
  Duration operator +(Duration other) =>
      Duration(microseconds: inMicroseconds + other.inMicroseconds);

  /// Returns the difference between two [Duration].
  Duration operator -(Duration other) =>
      Duration(microseconds: inMicroseconds - other.inMicroseconds);

  /// Divides a [Duration] by another [Duration].
  int divideBy(Duration other) => inMicroseconds ~/ other.inMicroseconds;

  /// Prints a [Duration] with the format {h:mm}.
  /// Ex: 1:10, 1, 1:05.
  String prettyPrint() {
    final int minutes = inMinutes - inHours.floor() * 60;
    return "${inHours.floor()}h${minutes == 0 ? "" : minutes.toString().padLeft(2, "0")}";
  }

  /// Segments a duration by hours, minutes and seconds.
  List<int> format() {
    final int hours = (inHours / 60).floor();
    final int minutes = inMinutes - (hours * 60);
    final int seconds = inSeconds - (hours * 60 * 60) - (minutes * 60);

    return [hours, minutes, seconds];
  }

  /// Prints a [Duration] with the format {hh:mm:ss}.
  String toHMS() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(inSeconds.remainder(60));

    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Creates a [Duration] from a string.
  static Duration fromString(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    final List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}
