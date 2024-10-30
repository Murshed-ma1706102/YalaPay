import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: Column(children: [
        CustomerCard(
          companyName: 'Amana Qatar Contracting',
          street: '55 Al-Salam St',
          city: 'Doha',
          country: 'Qatar',
          firstName: 'Ali',
          lastName: 'Al-Omari',
          email: 'ali@aqc.com.qa',
          mobile: '7780-7800',
          onDelete: () {
            // Handle delete action
            print('Delete');
          },
          onUpdate: () {
            print('update');
          },
        ),
      ]),
    );
  }
}
      




class CustomerCard extends StatelessWidget {
  final String companyName;
  final String street;
  final String city;
  final String country;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

const CustomerCard({
    Key? key,
    required this.companyName,
    required this.street,
    required this.city,
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.onDelete,
    required this.onUpdate
  }) : super(key: key);



@override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text("Address: $street, $city, $country"),
                SizedBox(height: 8.0),
                Text("Contact: $firstName $lastName"),
                Text("Email: $email"),
                Text("Mobile: $mobile"),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}