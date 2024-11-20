import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanner/management/auth/register.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void signin() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.ThirdColor,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 10, left: 10),
                  filled:
                      true, // This will fill the background with the specified color
                  fillColor: Color(0xffEFF2F9),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffEFF2F9),
                    ), // Adjust border color if needed
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust border radius as needed
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffEFF2F9),
                    ), // Adjust border color if needed
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust border radius as needed
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 10, left: 10),
                  filled:
                      true, // This will fill the background with the specified color
                  fillColor: Color(0xffEFF2F9),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffEFF2F9),
                    ), // Adjust border color if needed
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust border radius as needed
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffEFF2F9),
                    ), // Adjust border color if needed
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust border radius as needed
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                height: 45,
                width: double.infinity,
                // margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.ThirdColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: signin,
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   height: 50,
              //   // margin: EdgeInsets.all(20),
              //   width: double.infinity,
              //   padding: EdgeInsets.only(left: 20),
              //   decoration: BoxDecoration(
              //     color: Colors.black,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: TextButton(
              //       child: Text(
              //         'Sign Up with Email',
              //         style: TextStyle(
              //           fontWeight: FontWeight.w400,
              //           fontSize: 18,
              //           color: Colors.white,
              //         ),
              //       ),
              //       onPressed: () async {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => RegisterScreen()));
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 18),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 2, // Adjust the height as needed
              //       width: 80, // Adjust the width as needed
              //       color: Colors.black,
              //     ),
              //     SizedBox(width: 5), // Adjust the width as needed

              //     Text(
              //       'or use sign Up',
              //       style: TextStyle(color: Colors.black, fontSize: 20),
              //     ),
              //     SizedBox(width: 5), // Adjust the width as needed
              //     Container(
              //       height: 2, // Adjust the height as needed
              //       width: 80, // Adjust the width as needed
              //       color: Colors.black,
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 18),
              // SocialLoginButton(
              //   borderRadius: 10,
              //   buttonType: SocialLoginButtonType.apple,
              //   onPressed: () {},
              // ),
              // const SizedBox(height: 18),
              // SocialLoginButton(
              //   borderRadius: 10,
              //   buttonType: SocialLoginButtonType.google,
              //   onPressed: () {},
              // ),
              // const SizedBox(height: 18),
              // SocialLoginButton(
              //   borderRadius: 10,
              //   buttonType: SocialLoginButtonType.facebook,
              //   onPressed: () {},
              // ),
              // SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Already have an Account?',
              //       style: TextStyle(color: Colors.white, fontSize: 20),
              //     ),
              //     SizedBox(width: 5), // Adjust the width as needed
              //     Text(
              //       'Login',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         decoration: TextDecoration.underline,
              //         decorationColor: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
