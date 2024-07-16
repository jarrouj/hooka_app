import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OTPVerificationSignupPage extends StatefulWidget {
  final String email;

  OTPVerificationSignupPage({required this.email});

  @override
  _OTPVerificationSignupPageState createState() => _OTPVerificationSignupPageState();
}

class _OTPVerificationSignupPageState extends State<OTPVerificationSignupPage> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late List<String> _otpValues;
  late List<bool> _hasFocus;
  bool _showError = false;
  bool _isLoading = false;

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

  Future<void> _confirmOtp(String otp, String email) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.hookatimes.com/api/Accounts/ConfirmOtp'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'Email=$email&Otp=$otp',
    );

    setState(() {
      _isLoading = false;
    });

    final responseData = jsonDecode(response.body);

    // Debugging information
    print('Otp: $otp');
    print('Email: $email');
    print('Response: ${response.body}');

    if (responseData['statusCode'] == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()), // Replace with your desired page
      );
    } else {
      final String errorMessage = responseData['data']['message'] ?? 'OTP verification failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
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
      String otp = _otpValues.join('');
      _confirmOtp(otp, widget.email);
    }
  }

  Future<void> _resendOtp(String email) async {
    final response = await http.post(
      Uri.parse('https://api.hookatimes.com/api/Accounts/ResendOtp'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'Email=$email',
    );

    final responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 200) {
      _showOverlaySnackBar(context, 'Your code has been resent');
    } else {
      final String errorMessage = responseData['data']['message'] ?? 'Failed to resend OTP';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
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
                    fontSize: 13),
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
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.black)
                  : Text(
                      'VERIFY',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
            ),
            SizedBox(height: 20),
       Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Didn\'t receive the code?  ',
      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
    ),
    GestureDetector(
      onTap: () {
        _resendOtp(widget.email);
      },
      child: Text(
        'RESEND',
        style: TextStyle(
            color: Colors.yellow.shade700,
            decoration: TextDecoration.underline,
            decorationColor: Colors.yellow.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 17),
      ),
    ),
  ],
),

            SizedBox(height: 30),
            TextButton(
              onPressed: () {
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


