class Invoice {
  final String id;
  final String customerId;
  final String customerName;
  final double amount;
  final DateTime invoiceDate;
  final DateTime dueDate;
  String status; // Make status mutable

  Invoice({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.invoiceDate,
    required this.dueDate,
    this.status = "Unpaid", // Default status
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      amount: (json['amount'] as num).toDouble(),
      invoiceDate: DateTime.parse(json['invoiceDate']),
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'] ?? "Unpaid", // Default to "Unpaid" if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'amount': amount,
      'invoiceDate': invoiceDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }
}
