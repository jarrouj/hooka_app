import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/buddies.dart';
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      onLongPress: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Please log in',
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
        title: Center(
            child: Text(
          'Checkout',
          style: GoogleFonts.comfortaa(fontSize: 20),
        )),
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
        title: Center(
            child: Text(
          'Checkout',
          style: GoogleFonts.comfortaa(fontSize: 20),
        )),
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


class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'Offers',
          style: GoogleFonts.comfortaa(fontSize: 20),
        )),
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
                style: const TextStyle(color: Colors.white , fontWeight: FontWeight.w600 , fontSize: 15),
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
      body: _showLoading
          ? const LoadingAllpages()
          : SettingMainPage(showSnackBar: _showOverlaySnackBar),
    );
  }
}

class SettingMainPage extends StatefulWidget {
  final void Function(BuildContext context, String message) showSnackBar;

  const SettingMainPage({super.key, required this.showSnackBar});

  @override
  _SettingMainPageState createState() => _SettingMainPageState();
}

class _SettingMainPageState extends State<SettingMainPage> {
  bool _isAvailable = false;

  void _handleSwitchChange(bool value) {
    setState(() {
      _isAvailable = value;
    });

    String message = _isAvailable ? 'Available' : 'Not Available';
    widget.showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Preferences',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.settings,
                color: _isAvailable ? Colors.yellow.shade600 : Colors.grey,
                size: 25,
              ),
              const SizedBox(width: 20),
              const Text(
                'Available',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              CupertinoSwitch(
                value: _isAvailable,
                onChanged: _handleSwitchChange,
                activeColor: Colors.yellow.shade600,
                trackColor: Colors.grey,
                thumbColor: Colors.white,
              )
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuddiesPage()));
            },
            child: Container(
                height: 37,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow.shade600,
                ),
                child: const Center(
                  child: Text('Invite friends'),
                )),
          ),
          const SizedBox(height: 20),
          Container(
              height: 37,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellow.shade600,
              ),
              child: const Center(
                child: Text('Delete account'),
              )),
        ],
      ),
    );
  }
}