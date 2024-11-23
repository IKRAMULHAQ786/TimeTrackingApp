import 'package:intl/intl.dart';

extension CapitalizeString on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension DurationFormatter on int {
  /// Converts total minutes into a formatted duration (e.g., 2:15 for 135 minutes).
  String toFormattedDuration() {
    if (this <= 0) return "0:00";
    final hours = this ~/ 60;
    final minutes = this % 60;
    return "$hours:${minutes.toString().padLeft(2, '0')}";
  }
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('hh:mm a dd/MM/yyyy').format(dateTime);
}

class TimerInMinutes {
  DateTime? _startTime;

  void start() {
    _startTime = DateTime.now();
    print("Timer started.");
  }

  int stop() {
    if (_startTime == null) {
      throw Exception("Timer was not started!");
    }

    final elapsedMinutes = DateTime.now().difference(_startTime!).inMinutes;
    print("Timer stopped. Elapsed time: $elapsedMinutes minutes.");
    _startTime = null; // Reset the timer
    return elapsedMinutes;
  }
}
