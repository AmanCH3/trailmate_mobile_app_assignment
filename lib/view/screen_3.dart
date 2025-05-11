import 'package:flutter/material.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/get_screen_1.png',
            fit: BoxFit.cover,
          ),

          // Optional overlay for better text visibility
          Container(color: Colors.black.withOpacity(0.3)),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Welcome to App",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "Track your goals easily",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Normal text
                  ),
                ),
                SizedBox(height: 5),

                Text(
                  "Get started in just a few taps",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
