import 'package:flutter/material.dart';

class TrailView extends StatefulWidget {
  const TrailView({super.key});

  @override
  State<TrailView> createState() => _TrailViewState();
}

class _TrailViewState extends State<TrailView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: const Text("Trails "));
  }
}
