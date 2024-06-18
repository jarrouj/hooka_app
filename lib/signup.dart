import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: 240,
                height: screenHeight * 0.27,
                width: double.infinity,
                color: Colors.black,
                child:  Padding(
                  padding: EdgeInsets.only(left: 5, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Let\'s Get Started',
                        style: GoogleFonts.comfortaa(
                               color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),
                        // style: TextStyle(
                        //   color: Colors.white,
                        //   fontSize: 40,
                        // ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Please enter your email and password to\nsignup to HookaApp.',
                          style: GoogleFonts.openSans(
                               color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        // style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // width: 330,
                width: screenWidth*0.852,
                transform: Matrix4.translationValues(0, -80, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                       Row(
                        children: [
                           Text(
                            'Sign up',
                            style: GoogleFonts.lato(
                              color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              
                                ),
                            // style: TextStyle(
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 25,
                            //     letterSpacing: 1.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        thickness: 5,
                        color: Colors.black,
                        endIndent: 250,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name Required *';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'First Name',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          hintText: 'First Name',
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
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Last Name',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          hintText: 'Last Name',
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
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name Required *';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
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
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 172, 32, 22)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black),
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required *';
                          }
                          // Add more validation logic for password if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child:  Text(
                          'SIGN UP',
                          style: GoogleFonts.poppins(color: Colors.black , fontSize: 18),
                          // style: TextStyle(
                          //   color: Colors.black,
                          //   fontSize: 18,
                          
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'SIGN IN ',
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
                      SizedBox(height: screenHeight *0.05,)
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
