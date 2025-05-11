import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/get_screen_1.png'),
                SizedBox(height: 50,),
                Text("Plan Group Hikes with Ease-Adventures Awaits!",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("Discover trails, organize treks, and track progress"),
                Text("with fellow hikers"),
                SizedBox(height: 10,),
                TabPageSelectorIndicator(backgroundColor: Colors.black, borderColor: Colors.black, size: 5),
                SizedBox(height: 100,),
                Row(
                  children: [
                    SizedBox(
                      width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){},
                          child: Text("Skip"),)),
                    Spacer(),
                    ElevatedButton(onPressed: (){}, child: Text("Next")),
                  ],
                )
              ],
            ),
          ),
        ),

      ),
    );
  }
}
