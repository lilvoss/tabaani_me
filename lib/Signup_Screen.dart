import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tabaani/signin_Screen.dart';

import 'firebase_auth_implementation/firebase_auth_services.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'signup_screen';
  const SignUpScreen({super.key});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isSigningUp = false;

  // Variables to track password strength criteria
  bool _hasNumber = false;
  bool _hasLetter = false;
  bool _hasUppercase = false;
  bool _hasSymbol = false;

  // Focus nodes for each text field
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow.shade700,
                Colors.white,
                Colors.white,
                Colors.white
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Logo
                Container(
                  padding: const EdgeInsets.only(top: 120),
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/tabaani.jpg', // Replace with your logo's asset path
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow.shade700),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow.shade700),
                    ),
                  ),
                  obscureText: true,
                  onChanged: _updatePasswordStrength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0), // Space for password strength indicator
                _buildPasswordStrengthIndicator(), // Display password strength indicator
                SizedBox(height: 8.0), // Additional space for layout
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow.shade700),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signUp(); // Call the _signUp method here
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                    child: Text('Sign Up'),
                  ),
                ),
                SizedBox(height: 16.0), // Space below the sign-up button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SigninScreen.id);
                  },
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(height: 16.0), // Space below the sign-in text button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Sign up with Facebook logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.facebook, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text(
                              'Facebook',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Colors.white), // Text color set to white
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Sign up with Google logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.android, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text(
                              'Google',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Colors.white), // Text color set to white
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0), // Space below the social buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Copyright © Tabaani 2024',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _signUp() async {

    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happend");
    }
  }
  void showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  // Method to update password strength indicators
  void _updatePasswordStrength(String value) {
    setState(() {
      _hasNumber = value.contains(RegExp(r'\d'));
      _hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasSymbol = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Widget to build the password strength indicator
  Widget _buildPasswordStrengthIndicator() {
    double strength = 0.0;
    if (_hasNumber) strength += 0.25;
    if (_hasLetter) strength += 0.3;
    if (_hasUppercase) strength += 0.25;
    if (_hasSymbol) strength += 0.2;

    Color indicatorColor;
    if (strength < 0.5) {
      indicatorColor = Colors.red;
    } else if (strength < 0.75) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.green;
    }

    return Container(
      height: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }
}
