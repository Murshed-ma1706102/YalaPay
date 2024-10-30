import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationShell extends StatefulWidget {
  final Widget child;

  const BottomNavigationShell({Key? key, required this.child})
      : super(key: key);

  @override
  _BottomNavigationShellState createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate route based on the selected tab
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/payments');
        break;
      case 2:
        context.go('/cheques');
        break;
      case 3:
        context.go('/invoices');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Cheques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Invoices',
          ),
        ],
      ),
    );
  }
}
