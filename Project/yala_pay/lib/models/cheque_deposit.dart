class ChequeDeposit {
  final String id;
  final String depositDate;
  final String bankAccountNo;
  final String status;
  final List<int> chequeNos;

  ChequeDeposit(
      {required this.id,
      required this.depositDate,
      required this.bankAccountNo,
      required this.status,
      required this.chequeNos});

  factory ChequeDeposit.fromJson(Map<String, dynamic> json) => ChequeDeposit(
      id: json['id'],
      depositDate: json['depositDate'],
      bankAccountNo: json['bankAccountNo'],
      status: json['status'],
      chequeNos: List<int>.from(json['chequeNos']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'depositDate': depositDate,
        'bankAccountNo': bankAccountNo,
        'status': status,
        'chequeNos': chequeNos,
      };
}
