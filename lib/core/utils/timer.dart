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
