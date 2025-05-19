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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height * 0.05),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: height * 0.02,
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          child: Image.asset(
                            item['image']!,
                            height: height * 0.35,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width > 600 ? 24 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          item['description1']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: width > 600 ? 18 : 14),
                        ),
                        Text(
                          item['description2']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: width > 600 ? 18 : 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.08,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onSkipPressed,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF89C158),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.015,
                      ),
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
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }
}
