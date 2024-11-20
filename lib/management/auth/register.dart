import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanner/scanned_images_folder/Maincolor.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        Navigator.pop(context);
      } catch (e) {
        print(e);
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
          'Register',
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
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'First Name',
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
              SizedBox(height: 16.0),
              TextFormField(
                controller: _lastnameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Last Name',
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 50.0),
              Container(
                height: 45,
                // margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.ThirdColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: register,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
