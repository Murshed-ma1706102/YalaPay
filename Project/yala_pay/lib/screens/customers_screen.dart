import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import '../models/customer.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Customer> _filteredCustomers = []; // List to hold filtered customers

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCustomers);
    _filteredCustomers = ref.read(customerProvider); // Initialize with all customers
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
    _searchController.dispose();
    super.dispose();
  } // to clean up after the widget is removed from the widget tree

  void _filterCustomers() {
    final query = _searchController.text;
    setState(() {
      _filteredCustomers = ref.read(customerProvider.notifier).searchCustomers(query);
    });
  }

  @override
  Widget build(BuildContext context) {
   final customers = ref.watch(customerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => {context.goNamed('addCustomer')}, // Navigate to add screen
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "Add Customer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController, 
                  decoration: InputDecoration(
                    hintText: "Search Customers...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: customers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchController.text.isEmpty
                        ? customers.length
                        : _filteredCustomers.length, // Show filtered or all customers
                    itemBuilder: (context, index) {
                      final customer = _searchController.text.isEmpty
                          ? customers[index]
                          : _filteredCustomers[index];
                      return CustomerCard(
                        companyName: customer.companyName,
                        street: customer.address.street,
                        city: customer.address.city,
                        country: customer.address.country,
                        firstName: customer.contactDetails.firstName,
                        lastName: customer.contactDetails.lastName,
                        email: customer.contactDetails.email,
                        mobile: customer.contactDetails.mobile,
                        onDelete: () {
                          ref.read(customerProvider.notifier).deleteCustomer(customer.id);
                        },
                        onUpdate: () {
                          context.goNamed('updateCustomer', pathParameters: {'customerId': customer.id });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                        onPressed: () => onUpdate(), // navigate to update screen
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 207, 252, 72)),
                        child: const Text(
                          "Update Customer",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                          ),
                      ),
                      ElevatedButton(
                        onPressed: () => onDelete(), // navigate to update screen
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