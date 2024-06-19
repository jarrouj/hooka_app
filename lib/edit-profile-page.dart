import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child:
              Text('Edit Account', style: GoogleFonts.comfortaa(fontSize: 20)),
        ),
        actions: [
          const SizedBox(width: 40),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile-img.png',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ],
              ),            
            ],
          ),
            Positioned(
                 top: 170,
                 right: 100,
                 child: 
                 Container(
                   width: 60,
                   height: 60,
                   decoration: BoxDecoration(
                     color: Colors.black,
                     borderRadius: BorderRadius.circular(50),
                   ),
                   child: Center(
                    child: Icon(Icons.camera_alt_outlined , color: Colors.yellow.shade600,),
                   ),
                 ),
                 
                 ),
        ],
      ),
    );
  }
}
