import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Notifications',
            style: GoogleFonts.comfortaa(fontSize: 20),
          ),
        ),
        actions: const [
          SizedBox(
            width: 55,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.shade600,
                  blurRadius: 0.1,
                  offset: Offset(0, 0.8),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow.shade600,
                backgroundImage: AssetImage('assets/images/hookanobg.png'), // Replace with actual image
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Salim Salim reacted to\nyour invite!'),
                            Spacer(),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow.shade600,
                              ),
                            ),
                            SizedBox(width: size.width * 0.06,)
                          ],
                        ),
                        // const Text('your invite!'),
                        const Row(
                children: [
                  Text('Invite has been accepted', style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),),
                  Spacer(),
                  Text('2023-10-25', style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),),
                ],
              ),
              SizedBox(height: 10,),
                      ],

                    ),
                  ),
                ],
              ),
              // subtitle: const Row(
              //   children: [
              //     Text('Invite has been accepted', style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //     ),),
              //     Spacer(),
              //     Text('2023-10-25', style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 10,
              //     ),),
              //   ],
              // ),
            ),
          );
        },
      ),
    );
  }
}
