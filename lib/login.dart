// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hooka_app/signup.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _isObscure = true;
//    final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             ),
//             onPressed: () {
//              Navigator.of(context).pop();
//             },
//           ),
//         ),
//         body: SafeArea(
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     height: 200,
//                     color: Colors.black,
//                     child: const Padding(
//                       padding:  EdgeInsets.only(left: 20, top: 0),
//                       child: Column(
//                         children: [
//                           // SizedBox(
//                           //   height: 30,
//                           // ),
//                            Row(
//                             children: [
//                               Text(
//                                 'Welcome',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Row(
//                             children: [
//                               Text(
//                                   'Please enter your email and password to\nlogin to HookaApp.',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 17))
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//                 Positioned(
//             top: 130,
//             left: 20,
//             child: Container(
//               width: 350,
//               height: 550,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.6),
//                     spreadRadius: 3,
//                     blurRadius: 14,
//                     offset: const Offset(0, 15),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(top: 20, left: 30, right: 20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const Row(
//                         children: [
//                           Text(
//                             'Login',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                               letterSpacing: 2
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       const Row(
//                         children: [
//                           SizedBox(
//                               width: 40,
//                               child: Divider(
//                                 thickness: 5,
//                                 color: Colors.black,
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                     TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           labelStyle: const TextStyle(color: Colors.black  , fontSize: 15),
//                           hintText: 'Email',
//                           // hintStyle: TextStyle(fontSize: 12),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                               color: Color.fromARGB(255, 244, 240, 240),
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.black),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Color.fromARGB(255, 172, 32, 22)),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Color.fromARGB(255, 172, 32, 22), width: 2),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           // Add more validation logic for email if needed
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       TextFormField(
//                         obscureText: _isObscure,
//                         decoration: InputDecoration(
//                             errorBorder: OutlineInputBorder(
//                             borderSide:  BorderSide(color :Color.fromARGB(255, 172, 32, 22)),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Color.fromARGB(255, 172, 32, 22) , width: 2),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           labelText: 'Password',
//                           labelStyle: const TextStyle(color: Colors.black , fontSize: 15),
//                           hintText: 'Password',
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(
//                               color: Color.fromARGB(255, 244, 240, 240),
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.black),
//                             borderRadius: BorderRadius.circular(5),
//                           ),

//                           suffixIcon: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _isObscure = !_isObscure;
//                               });
//                             },
//                             child: Icon(
//                               !_isObscure
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                               color: Colors.black,
//                             ),
//                           ),

//                         ),

//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Required *';
//                           }
//                           // Add more validation logic for password if needed
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.only(right: 13),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               'Forgot Password?',
//                               style: TextStyle(
//                                 color: Color.fromARGB(255, 170, 165, 165),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (_formKey.currentState!.validate()) {
//                             // Process the login
//                           }
//                         },
//                         child: Container(
//                           width: 295,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.yellow.shade600,
//                             borderRadius: BorderRadius.circular(13),

//                           ),
//                           child: const Center(
//                             child: Text(
//                               'Login',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 70,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Don\'t have an account?' , style: TextStyle(color: Colors.grey),),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => const SignUp()));
//                             },
//                             child:const  Padding(
//                               padding:  EdgeInsets.only(left: 10),
//                               child:  Text(
//                                 'SIGN UP ',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                   decoration: TextDecoration.underline,

//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//             ],
//           ),
//         ));
//   }
// }

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
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.27,
              width: double.infinity,
              color: Colors.black,
              child:  Padding(
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
                          // style: TextStyle(
                          //   color: Colors.white,
                          //   fontSize: 40,
                          // ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
                    Row(
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
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
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
                        // Add more validation logic for password if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 170, 165, 165),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
                        minimumSize: const Size(double.infinity, 50),
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
                    // SizedBox(height: 60,),
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
