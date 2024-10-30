import 'cheque.dart';

class ChequeDeposit {
  String id;
  DateTime depositDate;
  String bankAccountNo;
  String status; // e.g., "Deposited", "Cashed"
  List<int> chequeNos;

  ChequeDeposit({
    required this.id,
    required this.depositDate,
    required this.bankAccountNo,
    required this.status,
    required this.chequeNos,
  });

  // Calculate total amount by summing amounts from cheques
  double calculateTotalAmount(List<Cheque> cheques) {
    return cheques
        .where((cheque) => chequeNos.contains(cheque.chequeNo))
        .fold(0.0, (sum, cheque) => sum + cheque.amount);
  }

  // Create a ChequeDeposit object from JSON
  factory ChequeDeposit.fromJson(Map<String, dynamic> json) {
    return ChequeDeposit(
      id: json['id'],
      depositDate: DateTime.parse(json['depositDate']),
      bankAccountNo: json['bankAccountNo'],
      status: json['status'],
      chequeNos: List<int>.from(json['chequeNos']),
    );
  }

  // Convert a ChequeDeposit object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'depositDate': depositDate.toIso8601String(),
      'bankAccountNo': bankAccountNo,
      'status': status,
      'chequeNos': chequeNos,
    };
  }
}
