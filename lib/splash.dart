import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooka_app/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  _startDelay(){
    _timer = Timer(Duration(seconds: 2), _goNext);
  }
  _goNext(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>   MyHomePage()));
    
  }
  @override
  void initState(){
    _startDelay();
    super.initState();
  }
  @override
  void dispose(){
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: 
      Image.asset('assets/images/hookatimeslogo.png'),
      ),
    );
  }
}