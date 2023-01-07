import 'package:flutter/material.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home screen'),
      ),
    );
  }
}
