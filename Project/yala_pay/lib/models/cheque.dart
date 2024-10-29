class Cheque {
  final int chequeNo;
  final double amount;
  final String drawer;
  final String bankName;
  final String status;
  final String receivedDate;
  final String dueDate;
  final String chequeImageUri;

  Cheque(
      {required this.chequeNo,
      required this.amount,
      required this.drawer,
      required this.bankName,
      required this.status,
      required this.receivedDate,
      required this.dueDate,
      required this.chequeImageUri});

  factory Cheque.fromJson(Map<String, dynamic> json) => Cheque(
      chequeNo: json['chequeNo'],
      amount: json['amount'],
      drawer: json['drawer'],
      bankName: json['bankName'],
      status: json['status'],
      receivedDate: json['receivedDate'],
      dueDate: json['dueDate'],
      chequeImageUri: json['chequeImageUri']);

  Map<String, dynamic> toJson() => {
        'chequeNo': chequeNo,
        'amount': amount,
        'drawer': drawer,
        'bankName': bankName,
        'status': status,
        'receivedDate': receivedDate,
        'dueDate': dueDate,
        'chequeImageUri': chequeImageUri,
      };
}
