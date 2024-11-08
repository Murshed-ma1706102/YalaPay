import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import '../models/address.dart';
import '../models/contact_details.dart';
import '../models/customer.dart';

class UpdateCustomerScreen extends ConsumerWidget {
  

  final String customerId;

  

  UpdateCustomerScreen({Key? key, required this.customerId}) : super(key: key) {
    
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final customer = ref.watch(customerProvider.notifier).getCustomerById(customerId);

 final TextEditingController companyNameController = TextEditingController(text: customer.companyName);
    final TextEditingController streetController = TextEditingController(text: customer.address.street);
    final TextEditingController cityController = TextEditingController(text: customer.address.city);
    final TextEditingController countryController = TextEditingController(text: customer.address.country);
    final TextEditingController firstNameController = TextEditingController(text: customer.contactDetails.firstName);
    final TextEditingController lastNameController = TextEditingController(text: customer.contactDetails.lastName);
    final TextEditingController emailController = TextEditingController(text: customer.contactDetails.email);
    final TextEditingController mobileController = TextEditingController(text: customer.contactDetails.mobile);

    void updateCustomer() {
      var updatedCustomer = Customer(
        id: customerId, // Keep the same ID
        companyName: companyNameController.text,
        address: Address(
          street: streetController.text,
          city: cityController.text,
          country: countryController.text,
        ),
        contactDetails: ContactDetails(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          mobile: mobileController.text,
        ),
      );

      // Update the customer in the state using Riverpod
      ref.read(customerProvider.notifier).updateCustomer(customer.id, updatedCustomer);

       ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Customer updated successfully!'),
      duration: const Duration(seconds: 5), 
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          // Code to execute when the action is pressed.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );

      // Navigate back to the customer list screen
      context.goNamed('customer');
    }

    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              const Text(
                "Company Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  labelText: "Company Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: "Street Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: "Country",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.public),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                "Contact Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: "Mobile",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: updateCustomer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Update Customer",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
