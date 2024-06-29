import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to detect when the keyboard is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.hasClients) {
          if (_scrollController.offset > 0) {
            setState(() {
              _isKeyboardVisible = true;
            });
          } else {
            setState(() {
              _isKeyboardVisible = false;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: _isKeyboardVisible ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.27,
              width: double.infinity,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Welcome',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Please enter your email and password to\nlogin to HookaApp.',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              transform: Matrix4.translationValues(0, -screenHeight * 0.1, 0),
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8 ),
                      child: Row(
                        children: [
                          Text(
                            'Login',
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 10 , top: 2),
                      child: Divider(
                        thickness: 5,
                        color: Colors.black,
                        endIndent: 260,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email Required *';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 17.0, horizontal: 10.0),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 172, 32, 22)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 32, 22),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 15),
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 244, 240, 240),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 17.0, horizontal: 10.0),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 32, 22)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 32, 22),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Password',
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 244, 240, 240),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(
                            !_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required *';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please Fill the email  you forget it\'s password in the email section'),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 170, 165, 165),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(350, 50),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUp()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'SIGN UP ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.065,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
