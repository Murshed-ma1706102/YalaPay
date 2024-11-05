import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import '../models/address.dart';
import '../models/contact_details.dart';
import '../models/customer.dart';


class AddCustomerScreen extends ConsumerWidget {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addCustomer() {
      var newCustomer = Customer(
        id: UniqueKey().toString(), // Generate a unique ID
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

      // Add the customer to the state using Riverpod
      ref.read(customerProvider.notifier).addCustomer(newCustomer);

      // Navigate back to the customer list screen
      context.goNamed('customer');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Customer"),
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
                validator: (value) =>
                    value!.isEmpty ? "Enter company name" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: "Street Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter street address" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) => value!.isEmpty ? "Enter city" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: "Country",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.public),
                ),
                validator: (value) => value!.isEmpty ? "Enter country" : null,
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
                validator: (value) =>
                    value!.isEmpty ? "Enter first name" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value!.isEmpty ? "Enter last name" : null,
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
                validator: (value) => value!.isEmpty ? "Enter email" : null,
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
                validator: (value) =>
                    value!.isEmpty ? "Enter mobile number" : null,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: addCustomer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Add Customer",
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

