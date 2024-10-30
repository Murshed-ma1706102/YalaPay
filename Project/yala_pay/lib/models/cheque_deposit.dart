class ChequeDeposit {
  final String id;
  final DateTime depositDate;
  final String bankAccountNo;
  final String status;
  final List<int> chequeNos;

  ChequeDeposit({
    required this.id,
    required this.depositDate,
    required this.bankAccountNo,
    required this.status,
    required this.chequeNos,
  });

  factory ChequeDeposit.fromJson(Map<String, dynamic> json) {
    return ChequeDeposit(
      id: json['id'],
      depositDate: DateTime.parse(json['depositDate']),
      bankAccountNo: json['bankAccountNo'],
      status: json['status'],
      chequeNos: List<int>.from(json['chequeNos']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'depositDate': depositDate.toIso8601String(),
        'bankAccountNo': bankAccountNo,
        'status': status,
        'chequeNos': chequeNos,
      };
}
