import 'package:flutter/material.dart';

class Dashboard1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Welcome to your dashboard!')),
    );
  }
}
