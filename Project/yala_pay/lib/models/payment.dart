class Payment {
  final String id;
  final String invoiceNo;
  final double amount;
  final String paymentDate;
  final String paymentMode;
  final int? chequeNo; // Optional, only relevant if payment mode is cheque

  Payment(
      {required this.id,
      required this.invoiceNo,
      required this.amount,
      required this.paymentDate,
      required this.paymentMode,
      this.chequeNo});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
      id: json['id'],
      invoiceNo: json['invoiceNo'],
      amount: json['amount'],
      paymentDate: json['paymentDate'],
      paymentMode: json['paymentMode'],
      chequeNo: json['chequeNo']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoiceNo': invoiceNo,
        'amount': amount,
        'paymentDate': paymentDate,
        'paymentMode': paymentMode,
        if (chequeNo != null) 'chequeNo': chequeNo,
      };
}
