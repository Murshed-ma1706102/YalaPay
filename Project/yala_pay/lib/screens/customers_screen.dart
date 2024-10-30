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
        title: const Text("Customers"),
      ),
      body: Column(children: [
        
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => print("Go to add screen"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Add Customer",
                      style: TextStyle(color: Colors.white)
                      ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Customers...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.grey[200]
                    ),
                  ),
                ),
              ],
            )
        ,
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
          },
          onUpdate: () {
            // update
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
    super.key,
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
  });



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
                const SizedBox(height: 8.0),
                Text("Address: $street, $city, $country"),
                const SizedBox(height: 8.0),
                Text("Contact: $firstName $lastName"),
                Text("Email: $email"),
                Text("Mobile: $mobile"),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => onUpdate, // navigate to update screen
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 207, 252, 72)),
                        child: const Text(
                          "Update Customer",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                          ),
                      ),
                      ElevatedButton(
                        onPressed: () => onDelete, // navigate to update screen
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 170, 11, 0)),
                        child: const Text(
                          "Delete Customer",
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))
                          ),
                      ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}