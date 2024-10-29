class BankAccount {
  final String accountNo;
  final String bank;

  BankAccount({required this.accountNo, required this.bank});

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      BankAccount(accountNo: json['accountNo'], bank: json['bank']);

  Map<String, dynamic> toJson() => {
        'accountNo': accountNo,
        'bank': bank,
      };
}
