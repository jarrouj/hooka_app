import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Invitations',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Material(
            color: Colors.grey.shade100,
            child: TabBar(
              padding: const EdgeInsets.only(top: 15),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.black,
              labelStyle: GoogleFonts.comfortaa(fontWeight: FontWeight.w800),
              controller: _tabController,
              tabs: const [
                Tab(text: 'Received'),
                Tab(text: 'Sent'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: AssetImage(
                        'assets/images/profile-img.png'), // Replace with actual image
                  ),
                  title: const Row(
                    children: [
                      const Text('Salim Salim'),
                      Spacer(),
                      Icon(Icons.check),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        '2023-10-25',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        'You Will Pay For Your Own Hooka & Food',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            itemCount: 1, // Replace with the actual count of sent invitations
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: const AssetImage(
                        'assets/images/profile-img.png'), // Replace with actual image
                  ),
                  title: const Row(
                    children: [
                      const Text('Salim Salim'),
                      Spacer(),
                      Icon(Icons.check),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        '2023-10-25',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        'You Will Pay For Your Own Hooka & Food',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
