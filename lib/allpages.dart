import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/checkout.dart';
import 'package:hooka_app/complete-order.dart';
import 'package:hooka_app/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BodyAllPages extends StatelessWidget {
  const BodyAllPages({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        onLongPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
        },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
          },
          child: Text('Please log in' , 
          style: GoogleFonts.comfortaa(fontSize: 20),
          
               ),
        ), 
        ),
      ),
    );
  }
}

class LoadingAllpages extends StatelessWidget {
  const LoadingAllpages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LoadingAnimationWidget.hexagonDots(
        color: Colors.black,
        size: 25,
      ),
      ),
    );
  }
}
// class InvitationsPage extends StatelessWidget {
//   const InvitationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:  Center(child: Text('Invitations' ,
//          style: GoogleFonts.comfortaa(fontSize: 20), )),
//         actions: const [
//           SizedBox(
//             width: 55,
//           ),
//         ],
//         leading: IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () => ZoomDrawer.of(context)!.toggle()),
//       ),
//       body: BodyAllPages(),
//     );
//   }
// }

class CheckoutPageNoLogin extends StatelessWidget {
  const CheckoutPageNoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Center(child: Text('Checkout' ,  style: GoogleFonts.comfortaa(fontSize: 20),)),
        actions: const [
          SizedBox(
            width: 55,
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => ZoomDrawer.of(context)!.toggle()),
      ),
      body: BodyAllPages(),
    );
  }
}
class CheckoutDrawer extends StatelessWidget {
  const CheckoutDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
          appBar: AppBar(
            surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title:  Center(child: Text('Checkout' ,  style: GoogleFonts.comfortaa(fontSize: 20),)),
        actions: const [
          SizedBox(
            width: 55,
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => ZoomDrawer.of(context)!.toggle()),
      ),
      body: CheckoutBody(),
    );
  }
}


// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage ({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:  Center(child: Text('Notifications' ,  style: GoogleFonts.comfortaa(fontSize: 20),)),
//         actions: const [
//           SizedBox(
//             width: 55,
//           ),
//         ],
//         leading: IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () => ZoomDrawer.of(context)!.toggle()),
//       ),
//       body: BodyAllPages(),
//     );
//   }
// }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    _changeBodyContent();
  }

  void _changeBodyContent() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Settings', style: GoogleFonts.comfortaa(fontSize: 20)),
        ),
        actions: const [
          SizedBox(width: 55),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
        ),
      ),
      body: _showLoading ? const LoadingAllpages() : const SettingMainPage(),
    );
  }
}

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Center(child: Text('Offers' ,  style: GoogleFonts.comfortaa(fontSize: 20),)),
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
      body: LoadingAllpages(),
    );
  }
}




class SettingMainPage extends StatelessWidget {
  const SettingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          SizedBox(height: 35,),
          // Center(
          //   child: Container(
          //     width: 110,
          //     height: 37,
          //     decoration: BoxDecoration(
          //       color: Colors.yellow.shade600,
          //       borderRadius: BorderRadius.circular(10)
          //     ),
          //     child: Center(child: Text('Invite friends' , style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 14,
          //     ),)),
          // ),
          // ),
        ],
      ),
    );
  }
}