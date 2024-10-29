class Bank {
  final String name;

  Bank({required this.name});

  factory Bank.fromJson(String name) => Bank(name: name);

  String toJson() => name;
}
