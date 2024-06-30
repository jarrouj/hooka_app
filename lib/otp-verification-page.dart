import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;

  OTPVerificationPage({required this.email});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late List<String> _otpValues;
  late List<bool> _hasFocus;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (index) => FocusNode());
    _controllers = List.generate(4, (index) => TextEditingController());
    _otpValues = List.generate(4, (index) => '');
    _hasFocus = List.generate(4, (index) => false);

    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          _hasFocus[i] = _focusNodes[i].hasFocus;
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlaySnackBar(context, 'Your code has been sent');
    });
  }

  @override
  void dispose() {
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _nextField(int index) {
    if (index < _focusNodes.length - 1) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _previousField(int index) {
    if (index > 0) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _handleChange(String value, int index) {
    if (value.isNotEmpty) {
      setState(() {
        _otpValues[index] = value;
      });

      Timer(Duration(milliseconds: 500), () {
        if (_otpValues[index] == value) {
          setState(() {
            _controllers[index].text = '#';
          });
        }
      });

      if (index < _focusNodes.length - 1) {
        _nextField(index);
      }
    } else {
      setState(() {
        _otpValues[index] = '';
      });
      if (index > 0) {
        _previousField(index);
      }
    }

    if (_otpValues.every((element) => element.isEmpty)) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  void _verifyOTP() {
    if (_otpValues.any((element) => element.isEmpty)) {
      setState(() {
        _showError = true;
      });
    } else {
      setState(() {
        _showError = false;
      });
      // Add navigation to the new page here
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      ));
    }
  }

  void _showOverlaySnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: MediaQuery.of(context).size.width * 0.25,
        right: MediaQuery.of(context).size.width * 0.25,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Otp Verification', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/hookatimeslogo-nobg.png',
              height: 170,
              width: 250,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Enter the code sent to ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _otpTextField(index)),
            ),
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 35),
                child: Row(
                  children: [
                    Text(
                      'Please enter OTP',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 60),
            TextButton(
              onPressed: () {
                // Resend OTP logic
                _showOverlaySnackBar(context, 'Your code has been sent');
              },
              child: RichText(
                text: TextSpan(
                  text: 'Didn\'t receive the code?  ',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'RESEND',
                      style: TextStyle(
                          color: Colors.yellow.shade700,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'VERIFY',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Clear OTP fields logic
                _controllers.forEach((controller) => controller.clear());
                _otpValues = List.generate(4, (index) => '');
                FocusScope.of(context).requestFocus(_focusNodes[0]);
                setState(() {
                  _showError = false;
                });
              },
              child: Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpTextField(int index) {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: _hasFocus[index] || _otpValues[index].isNotEmpty
            ? Colors.white
            : Colors.black,
        border: Border.all(
          width: 2,
          color: _hasFocus[index] || _otpValues[index].isNotEmpty
              ? Colors.black
              : Colors.yellow.shade300,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Focus(
        onKey: (node, event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty) {
              _previousField(index);
            } else {
              _controllers[index].clear();
              _handleChange('', index);
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorColor: Colors.yellow,
          cursorHeight: 26,
          style: TextStyle(
            fontSize: 24,
            height: 4,
            color: _hasFocus[index] || _otpValues[index].isNotEmpty
                ? Colors.black
                : Colors.yellow.shade600,
          ),
          maxLength: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          readOnly: _otpValues[index].isNotEmpty && !_hasFocus[index],
          onChanged: (value) {
            if (RegExp(r'^[0-9]$').hasMatch(value)) {
              _handleChange(value, index);
            } else {
              _controllers[index].clear();
            }
          },
          onTap: () {
            if (_otpValues.every((element) => element.isEmpty) && index != 0) {
              FocusScope.of(context).requestFocus(_focusNodes[0]);
            }
          },
          onSubmitted: (value) {
            if (value.isEmpty && index > 0) {
              _previousField(index);
            }
          },
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 242),
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Enter Your New Password',
                  style: GoogleFonts.comfortaa(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                filled: true, // Set the fill color
                fillColor: Colors.white, // Set the fill color to white
                labelText: 'New Password',
                labelStyle: GoogleFonts.comfortaa(fontSize: 13 , color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(12), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide.none, // Remove the border when not focused
                  borderRadius: BorderRadius.circular(12), 
                ),
              ),
              // obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                filled: true, // Set the fill color
                fillColor: Colors.white, // Set the fill color to white
                labelText: 'Confirm Password',
                labelStyle: GoogleFonts.comfortaa(fontSize: 13 , color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(12), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide.none, // Remove the border when not focused
                  borderRadius: BorderRadius.circular(12), 
                ),
              ),
              // obscureText: true,
            ),
            SizedBox(height: 60),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10),
             child: Container(
              width: double.infinity,
               decoration: BoxDecoration(
                 color: Colors.yellow.shade600,
                 borderRadius: BorderRadius.circular(10),
               ),
               child: InkWell(
                 onTap: () {
                   // Save password logic
                 },
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 15),
                   child: Center(
                     child: Text(
                       'Save Password',
                       style: GoogleFonts.comfortaa(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18
                       ),
                     ),
                   ),
                 ),
               ),
             ),
           ),
          ],
        ),
      ),
    );
  }
}
