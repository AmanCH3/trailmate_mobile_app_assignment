import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/view/screen_2.dart';

import 'login_view.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/get_screen_1.png'),
                  const SizedBox(height: 50),
                  const Text(
                    "Plan Group Hikes with Ease - Adventure Awaits!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Discover trails, organize treks, and track progress",
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "with fellow hikers",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Replacing TabPageSelectorIndicator with dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.black : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(


                          ),
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView())) ;

                            }, child: Text("Skip" , style: const TextStyle(color: Colors.black),))
                        ),

                      ),
                      Spacer() ,
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0x8889C158)

                        ),
                        child: TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen2())) ;

                        }, child: Text("Next" , style: const TextStyle(color: Colors.white),)),
                        ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
