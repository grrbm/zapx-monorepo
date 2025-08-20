import 'package:flutter/material.dart';

class ServicesAndScedule extends StatefulWidget {
  const ServicesAndScedule({super.key});

  @override
  State<ServicesAndScedule> createState() => _ServicesAndSceduleState();
}

class _ServicesAndSceduleState extends State<ServicesAndScedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.950),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Services and Schedule'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
