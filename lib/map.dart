import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Center(child: Text('Hooka Map' ,  style: GoogleFonts.comfortaa(fontSize: 20),)),
        actions: const [
          SizedBox(
            width: 55,
          ),
        ],
         leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
             Navigator.of(context).pop();
            },
          ),
      ),
      body: Center(child: Text('Hooka Map'),),
    );
  }
}