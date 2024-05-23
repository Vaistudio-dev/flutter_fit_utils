import 'package:intl/intl.dart';

/// Extension of the [DateTime] class.
extension FitDateTimeExtension on DateTime {
  /// Returns [true] if two [DateTime] are on the same exact day (Day, month and year).
  bool isSameDate(DateTime other) =>
      day == other.day && month == other.month && year == other.year;

  /// Returns the week number of the current week. from 1 to 52.
  int getWeekNumber() {
    final DateTime lastMonday = subtract(Duration(days: getTodayIndex()));
    return (lastMonday.difference(DateTime(year)).inDays / 7).ceil() + 1;
  }

  /// Returns [true] if [DateTime.now()] is on the same exact day as [this].
  /// See [isSameDate].
  bool isToday() => isSameDate(DateTime.now());

  /// Returns [true] if a [DateTime] corresponds to yesterday (Same year and day - 1).
  bool isYesterday() {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  /// Returns [true] if a [DateTime] corresponds to tomorrow (Same year and day + 1).
  bool isTomorrow() {
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  /// Prints a [DateTime] with the format {hh}h{mm}.
  /// Ex: 13h50, 2h10, 10h05.
  String printTime() => "${hour}h${minute.toString().padLeft(2, "0")}";

  /// Prints a [DateTime] with the format {yyyy/mm/dd}.
  String prettyPrint() => "$year/$month/$day";

  /// Retourns the weekday of a [DateTime].
  /// Ex: monday, tuesday, wednesday, etc.
  String getDate() => DateFormat("EEEE").format(this);

  /// Returns the ordinal day number.
  /// Ex. 11th, 1st, 2nd, etc.
  String getOrdinal() {
    if (day >= 11 && day <= 13) {
      return "${day}th";
    }

    switch (day % 10) {
      case 1:
        return "${day}st";
      case 2:
        return "${day}nd";
      case 3:
        return "${day}rd";
      default:
        return "${day}th";
    }
  }
}

/// Retourns the day numbers of the current week, from monday to sunday.
/// Ex: 26, 27, 28, 29, 30, 31, 1.
List<int> getWeekDates() {
  final List<int> dates = [];
  DateTime temp = DateTime.now();

  final int todayDate = temp.day;
  dates.add(todayDate);

  final int todayIndex = getDayIndex(getToday());

  for (int i = 0; i < todayIndex; i++) {
    temp = temp.subtract(const Duration(hours: 24));
    dates.insert(0, temp.day);
  }

  temp = DateTime.now();
  for (int i = todayIndex + 1; i < 7; i++) {
    temp = temp.add(const Duration(hours: 24));
    dates.add(temp.day);
  }

  return dates;
}

/// Returns the weekday of [DateTime.now()].
/// See [FitDateTimeExtension.getDate()].
String getToday() => DateTime.now().getDate();

/// Returns the index of a day throughout the week.
/// The [day] input is expected to be from [FitDateTimeExtension.getDate()].
/// The index 0 is considered to be monday.
int getDayIndex(String day) {
  int index = 0;

  switch (day.toLowerCase()) {
    case "tuesday":
      {
        index = 1;
        break;
      }
    case "wednesday":
      {
        index = 2;
        break;
      }
    case "thursday":
      {
        index = 3;
        break;
      }
    case "friday":
      {
        index = 4;
        break;
      }
    case "saturday":
      {
        index = 5;
        break;
      }
    case "sunday":
      {
        index = 6;
      }
  }

  return index;
}

/// Retourns the day index throughout the week of the current day.
/// See [getDayIndex()].
int getTodayIndex() => getDayIndex(getToday());
