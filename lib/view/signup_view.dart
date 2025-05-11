import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final myKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit:  StackFit.expand,
        children: [
         Image.asset('assets/images/login_page.png' ,
         fit: BoxFit.cover,) ,

          Container(
            color: Colors.black.withOpacity(0.7),

          ) ,

          SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Form(
              key: myKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: const Text(
                        "Create an account" ,
                        style: TextStyle(
                          fontSize: 32 ,
                          fontWeight: FontWeight.bold ,
                          color: Colors.white
                        ),


                      ),
                    ) ,
                    SizedBox(
                      height: 20,
                    ) ,

                    TextFormField(
                      controller: fullNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black38,
                        prefixIcon: Icon(Icons.person , color: Colors.white,),
                        labelStyle: const TextStyle(color: Colors.white),

                        labelText: 'Fullname' ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8) ,
                          borderSide: BorderSide.none
                        )
                      ),


                    ) ,
                    SizedBox(height: 18) ,
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black38,
                        prefixIcon: Icon(Icons.email , color: Colors.white,),
                        
                        labelText: 'Email address' ,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8) ,
                          borderSide:  BorderSide.none
                        )
                      ),
                    ) ,
                    SizedBox(height: 18,) ,
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled:  true,
                        fillColor: Colors.black38,
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.lock , color: Colors.white,),
                        suffixIcon: Icon(Icons.visibility , color: Colors.white,),
                        labelText: 'Password' ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8) ,
                          borderSide: BorderSide.none
                        )
                      ),
                    ) ,
                    SizedBox(
                      height: 18,
                    ) ,
                    TextFormField(
                      controller: confirmPasswordController ,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black38,
                        prefixIcon: Icon(Icons.lock , color: Colors.white,),
                          suffixIcon: Icon(Icons.visibility , color: Colors.white,),
                        labelText: 'Confirm password' ,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(8) ,
                          borderSide: BorderSide.none
                        )
                      ),
                    ) ,

                    SizedBox(
                      height: 18,
                    ) ,

                    TextFormField(
                      controller: phoneNumberController,
                      style: const TextStyle(color: Colors.white),
                      
                      
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black38 ,
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.phone , color: Colors.white,),
                        labelText: "Contact no" ,
                        border:  OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(8) ,
                          borderSide: BorderSide.none
                        )

                      ),
                    ) ,

                    SizedBox(
                      height: 25,
                    ) ,

                    Container(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0x8889C158),
                          padding: const EdgeInsets.all(16) ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)

                          )
                        )

                          ,onPressed: (){

                      }, child: Text("Sign in" ,
                      style: TextStyle(
                        fontWeight: FontWeight.bold ,
                        letterSpacing: 1.2 ,
                        fontSize: 16 ,
                        color:  Colors.white
                      ),)),
                    ),

                    SizedBox(
                      height: 16,
                    ) ,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account ?' ,
                        style: const TextStyle(color: Colors.white),) ,
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView())) ;

                        }, child: Text('Sign in' ,
                          style: TextStyle(color: Color(0x8889C158)),))
                      ],
                    ) ,

                    SizedBox(height: 16,
                    ) ,
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.g_mobiledata, size: 28), // Alternative Google-like icon
                        label: Text("Sign Up With Google" ,
                        style: const TextStyle(color: Colors.black38),),
                        style: ElevatedButton.styleFrom(

                          padding: const EdgeInsets.all(13),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    )



                  ],
                )),
          )

        ]
      ),
    ) ;
  }
}