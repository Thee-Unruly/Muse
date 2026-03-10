import 'package:flutter/material.dart';

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection'),
      ),
      body: const Center(
        child: Text('Your AI-generated reflection will appear here.'),
      ),
    );
  }
}
