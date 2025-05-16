import 'package:flutter/material.dart';

import 'login_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/get_screen_1.png',
      'title': 'Plan Group Hikes with Ease - Adventure Awaits!',
      'description1': 'Discover trails, organize treks, and track progress',
      'description2': 'with fellow hikers',
    },
    {
      'image': 'assets/images/get_screen_2.png',
      'title': 'Track and Share Your Hiking Experience',
      'description1': 'Log your adventures and milestones',
      'description2': 'with your friends',
    },
    {
      'image': 'assets/images/get_screen_3.png',
      'title': 'Stay Connected On Every Trail',
      'description1': 'Real-time updates and safety alerts',
      'description2': 'keep you and your group in sync',
    },
  ];

  void _onNextPressed() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  void _onSkipPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(item['image']!, height: 300),
                      const SizedBox(height: 50),
                      Text(
                        item['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item['description1']!, textAlign: TextAlign.center),
                      Text(item['description2']!, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _onSkipPressed,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Spacer(),

                ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF89C158),
                  ),

                  child: Text(
                    _currentIndex == _onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(color: Colors.white),
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
