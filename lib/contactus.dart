import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/login.dart';
import 'package:hooka_app/main.dart';

class MyContactPage extends StatelessWidget {
  const MyContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZoomDrawer(
        menuScreen: MenuScreen(),
        mainScreen: ContactMainScreen(),
        borderRadius: 24.0,
        showShadow: true,
        drawerShadowsBackgroundColor: Color.fromARGB(255, 57, 55, 55),
        menuBackgroundColor: Colors.black,
        mainScreenTapClose: true);
  }
}

class ContactMainScreen extends StatelessWidget {
  const ContactMainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final drawerController = ZoomDrawer.of(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text('ContactUs', style: GoogleFonts.comfortaa(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (drawerController?.isOpen == true) {
              drawerController?.close();
            } else {
              drawerController?.open();
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (drawerController?.isOpen == true) {
            drawerController?.close();
          }
        },
        onHorizontalDragUpdate: (details) {
          if (drawerController?.isOpen == true && details.delta.dx > 0) {
            drawerController?.close();
          }
        },
        child: const ContactUsPage(),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _navigateToPage(BuildContext context, String pageName) {
    ZoomDrawer.of(context)?.open();

    if (pageName == 'MainScreen') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else if (pageName == 'ContactUs') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactUsPage()),
      );
    } else if (pageName == 'Login') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
    // Add more cases for other pages as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(
            height: 100,
          ),
          ListTile(
            leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                )),
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.yellow.shade600,
            ),
            title: GestureDetector(
              onTap: () => _navigateToPage(context, 'MainScreen'),
              child: const Text(
                'MainScreen',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.check,
              color: Colors.yellow.shade600,
            ),
            title: Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.star_border_outlined,
              color: Colors.yellow.shade600,
            ),
            title: Text(
              'My Orders',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month_outlined,
              color: Colors.yellow.shade600,
            ),
            title: Text(
              'Invitations',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.yellow.shade600,
            ),
            title: Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.yellow.shade600,
            child: GestureDetector(
              onTap: () => ZoomDrawer.of(context)!.close(),
              child: const ListTile(
                leading: Icon(
                  Icons.contact_phone,
                  color: Colors.black,
                ),
                title: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.yellow.shade600,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () => _navigateToPage(context, 'Login'),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.yellow.shade600,
              ),
              title: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

   bool isLoading = false;

  void _handleSend() {
    setState(() {
      isLoading = true;
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double baseFontSize = 17;
    double smallFontSize = 12;
    double largeFontSize = 18;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 249, 247, 247),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Image.asset('assets/images/hookatimeslogo.png'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'We are committed to your experience',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: largeFontSize * (width / 400),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Recognizing   the   value   of   memorable experiences, we are deeply committed to delivering consistent and reliable service across   our   business  to   guarantee the highest level of satisfaction. ',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: baseFontSize * (width / 400),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Our talented team understands the needs and      expectations      of     hosts     and customers, and we take immense pride in the quality of the products we use.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: baseFontSize * (width / 400),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Whether you are interested in becoming\na host\nor learning more about the experience, we\'d love to hear from you.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: baseFontSize * (width / 400),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Please         send        an        email        to info@hookatimes.com\nfor further information about our brand.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: baseFontSize * (width / 400),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                     TextField(
                       inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                ],
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                 TextField(
                  
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
                  hintText: 'Mobile',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                ),
              ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                     inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                ],
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                     inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                ],
                    decoration: InputDecoration(
                      labelText: 'Your Message...',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      hintText: 'Your Message...',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
               Container(
      width: 331,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.yellow.shade600,
      ),
      child: TextButton(
        onPressed: _handleSend,
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    SizedBox(width: 10),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    ),
                  SizedBox(
                    height: 45,
                  ),
                ],
              ))
        ])));
  }
}