import 'package:flutter/material.dart';

class ChecklistView extends StatefulWidget {
  const ChecklistView({super.key});

  @override
  State<ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<ChecklistView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Check list"));
  }
}
