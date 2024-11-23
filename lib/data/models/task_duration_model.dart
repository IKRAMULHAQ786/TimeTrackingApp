class TaskDuration {
  final int? amount;
  final String? unit;

  TaskDuration({this.amount, this.unit});

  factory TaskDuration.fromJson(Map<String, dynamic> json) {
    return TaskDuration(
      amount: json['amount'] ?? 0,
      unit: json['unit'] ?? 'minute',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}
