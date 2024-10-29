class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  User(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json['email'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName']);

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };
}
