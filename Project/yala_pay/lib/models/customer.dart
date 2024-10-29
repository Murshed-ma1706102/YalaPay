import 'address.dart';
import 'contact_details.dart';

class Customer {
  final String id;
  final String companyName;
  final Address address;
  final ContactDetails contactDetails;

  Customer(
      {required this.id,
      required this.companyName,
      required this.address,
      required this.contactDetails});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json['id'],
      companyName: json['companyName'],
      address: Address.fromJson(json['address']),
      contactDetails: ContactDetails.fromJson(json['contactDetails']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyName': companyName,
        'address': address.toJson(),
        'contactDetails': contactDetails.toJson(),
      };
}
