class Cheque {
  int chequeNo;
  double amount;
  String drawer;
  String bankName;
  String status; // e.g., "Awaiting", "Deposited", "Cashed", "Returned"
  DateTime receivedDate;
  DateTime dueDate;
  String chequeImageUri;

  Cheque({
    required this.chequeNo,
    required this.amount,
    required this.drawer,
    required this.bankName,
    required this.status,
    required this.receivedDate,
    required this.dueDate,
    required this.chequeImageUri,
  });

  // Create a Cheque object from JSON
  factory Cheque.fromJson(Map<String, dynamic> json) {
    return Cheque(
      chequeNo: json['chequeNo'],
      amount: json['amount'].toDouble(),
      drawer: json['drawer'],
      bankName: json['bankName'],
      status: json['status'],
      receivedDate: DateTime.parse(json['receivedDate']),
      dueDate: DateTime.parse(json['dueDate']),
      chequeImageUri: json['chequeImageUri'],
    );
  }

  // Convert a Cheque object to JSON
  Map<String, dynamic> toJson() {
    return {
      'chequeNo': chequeNo,
      'amount': amount,
      'drawer': drawer,
      'bankName': bankName,
      'status': status,
      'receivedDate': receivedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'chequeImageUri': chequeImageUri,
    };
  }
}
