import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/buddies.dart';
import 'package:hooka_app/login.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> sentInvitations = [
    {
      'image': 'assets/images/resta.avif',
      'title': 'Test',
      'buddies': '15 Buddies',
      'details': 'Sent Details',
      'rating': 4,
      'openingHours': '12 am - 12 pm',
      'phoneNumber': '76974972',
      'description': 'restaurant description',
      'location': 'Zahle',
      'cuisine': 'italian'
    },
    {
      'image': 'assets/images/rest1.jpg',
      'title': 'Aroma',
      'buddies': '1 Buddies',
      'details': 'Sent Details',
      'rating': 2,
      'openingHours': '12 am - 12 pm',
      'phoneNumber': '76974972',
      'description': 'restaurant description',
      'location': 'Zahle',
      'cuisine': 'italian'
    },
    {
      'image': 'assets/images/rest1.jpg',
      'title': 'Burger House',
      'buddies': '1 Buddies',
      'details': 'Sent Details',
      'rating': 1,
      'openingHours': '12 am - 12 pm',
      'phoneNumber': '76974972',
      'description': 'restaurant description',
      'location': 'Zahle',
      'cuisine': 'italian'
    },
  ];

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
              labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 17),
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvProfile()),
                  );
                },
                child: Container(
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
                      backgroundImage:
                          const AssetImage('assets/images/profile-img.png'),
                    ),
                    title: const Row(
                      children: [
                        Text(
                          'Salim Salim',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.check),
                        SizedBox(
                          width: 45,
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                        Text(
                          '2023-10-25',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                        Text(
                          'You Will Pay For Your Own Hooka & Food',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            itemCount: sentInvitations.length,
            itemBuilder: (context, index) {
              final invitation = sentInvitations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvitationDetailsPage(
                        invitation: invitation,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(invitation['image'],
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Text(invitation['title'],
                                      style: TextStyle(fontSize: 20)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPage(
                                            imagePath: invitation['image'],
                                            title: invitation['title'],
                                            rating: invitation['rating'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      invitation['details'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              invitation['buddies'],
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
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

class InvProfile extends StatelessWidget {
  const InvProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Image.asset('assets/images/profile-img.png'),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Salim Salim',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvitePage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(color: Colors.yellow.shade600),
                    child: Center(
                      child: Text('invite'),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final int rating;

  const DetailsPage(
      {required this.imagePath,
      required this.title,
      required this.rating,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text('Sent Invitation Details')),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 200,
                )
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: Container(
                    width: 50,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: rating > 4
                          ? Colors.green.shade700
                          : rating >= 3
                              ? Colors.orange
                              : Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        const Icon(Icons.star, color: Colors.white, size: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text('See Who are going',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey.shade300,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/images/profile-img.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Salim Salim',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Accepted',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey.shade300,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/images/profile-img.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Georges Jarrouj',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Rejected',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvitationDetailsPage extends StatefulWidget {
  final Map<String, dynamic> invitation;

  const InvitationDetailsPage({required this.invitation, Key? key})
      : super(key: key);

  @override
  State<InvitationDetailsPage> createState() => _InvitationDetailsPageState();
}

class _InvitationDetailsPageState extends State<InvitationDetailsPage> {
  late bool isFavorite;
  final Box favoritesBox = Hive.box('InvitationFavorites');

  @override
  void initState() {
    super.initState();
    isFavorite =
        favoritesBox.get(widget.invitation['title'], defaultValue: false);
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      favoritesBox.put(widget.invitation['title'], isFavorite);
    });
  }

  void _openPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      print('Could not launch $phoneUri');
    }
  }

  void _openMap(String location) async {
    final Uri mapUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'api': '1', 'query': location},
    );
    if (await canLaunch(mapUri.toString())) {
      await launch(mapUri.toString());
    } else {
      throw 'Could not launch ${mapUri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text('Details', style: GoogleFonts.comfortaa()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.invitation['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: widget.invitation['rating'] > 4
                                ? Colors.green.shade700
                                : widget.invitation['rating'] >= 3
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                widget.invitation['rating'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: _toggleFavorite,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('${widget.invitation['cuisine']}'),
                      const Spacer(),
                      const Icon(
                        Icons.fastfood,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _openMap(widget.invitation['location']),
                        child: Text(
                          '${widget.invitation['location']}',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _openMap(widget.invitation['location']),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${widget.invitation['description']}',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.info_outline,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _openPhoneDialer(widget.invitation['phoneNumber']),
                        child: Text(
                          '${widget.invitation['phoneNumber']}',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            _openPhoneDialer(widget.invitation['phoneNumber']),
                        child: const Icon(
                          Icons.phone,
                          size: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                Text(
                  ' Opening hours [ ${widget.invitation['openingHours']} ]',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15, left: 15, top: 10),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Album',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Image.asset(
                    widget.invitation['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                content: Container(
                                  height: 85,
                                  width: 850,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Please log in first',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.login),
                                            SizedBox(width: 5),
                                            Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Colors.yellow.shade600,
                          size: 25,
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BuddiesPage()));
                          },
                          child: const Text(
                            'Invite buddy',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationThickness: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'Menus',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 200),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.add_circle,
                          color: Colors.yellow.shade600,
                          size: 25,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Add review',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationThickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: const Border(
                        left: BorderSide(color: Colors.grey, width: 0.6),
                        bottom: BorderSide(color: Colors.grey, width: 0.6),
                        right: BorderSide(color: Colors.grey, width: 0.2),
                        top: BorderSide(color: Colors.grey, width: 0.2),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 50,
                              ),
                              Positioned(
                                top: 12,
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Maroun',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Love it !!',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '2024-05-22',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  bool _isPayForHookapp = false;
  bool _isPayForFood = false;
  bool _isPayYourOwn = false;

  String _selectedPlace = 'Elysee Palace Cafe';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _messageController = TextEditingController();

  List<String> _places = [
    'Elysee Palace Cafe',
    'Mazaj Restaurant',
    'Chillax Cafe',
    'Shisha & Grill',
    'Aroma',
    'Hollywood Cafe Zahle',
    'Elie\'s Yard',
    'Cafe Najjar',
  ];

  void _selectCheckbox(int index) {
    setState(() {
      _isPayForHookapp = index == 0;
      _isPayForFood = index == 1;
      _isPayYourOwn = index == 2;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showPlacePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PlacePicker(
          places: _places,
          onPlaceSelected: (String place) {
            setState(() {
              _selectedPlace = place;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'invite',
          style: GoogleFonts.comfortaa(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'I Will Pay For Hookapp',
                  style: TextStyle(fontSize: 17),
                ),
                const Spacer(),
                Checkbox(
                  activeColor: Colors.black,
                  value: _isPayForHookapp,
                  onChanged: (bool? value) {
                    _selectCheckbox(0);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'I Will Pay For Food',
                  style: TextStyle(fontSize: 17),
                ),
                Spacer(),
                Checkbox(
                  activeColor: Colors.black,
                  value: _isPayForFood,
                  onChanged: (bool? value) {
                    _selectCheckbox(1);
                  },
                ),
              ],
            ),
            Row(
              children: [
               const Text(
                  'You Will Pay For Your Own Hooka &\nFood',
                  style: TextStyle(fontSize: 17),
                ),
                Spacer(),
                Checkbox(
                  activeColor: Colors.black,
                  value: _isPayYourOwn,
                  onChanged: (bool? value) {
                    _selectCheckbox(2);
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text('Choose a place' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15),),
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () => _showPlacePicker(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade600),
                ),
                child: Row(
                  children: [
                    Text(
                      '$_selectedPlace',
                      style: TextStyle(color: Colors.black),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
           const SizedBox(height: 30),
             const Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text('Choose date time' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15),),
                ],
              ),
            ),
           const SizedBox(height: 20),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.black),
                    SizedBox(width: 20),
                    Text(
                      '${_selectedDate.toLocal()}'.split(' ')[0],
                      style: TextStyle(color: Colors.black),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.black),
                    SizedBox(width: 20),
                    Text(
                      '${_selectedTime.format(context)}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'write message',
                hintStyle: TextStyle(color: Colors.black , fontSize: 13),
                filled: true,
                fillColor: Colors.grey.shade300,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
           GestureDetector(
              onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BuddiesPage()));
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade600,
                  borderRadius: BorderRadius.circular(10)
                ),
             
                child: Center(
                  child: Text(
                    'Send',
                    style: GoogleFonts.comfortaa(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18
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

class PlacePicker extends StatefulWidget {
  final List<String> places;
  final ValueChanged<String> onPlaceSelected;

  const PlacePicker(
      {required this.places, required this.onPlaceSelected, Key? key})
      : super(key: key);

  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  List<String> _filteredPlaces = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPlaces = widget.places;
    _searchController.addListener(_filterPlaces);
  }

  void _filterPlaces() {
    setState(() {
      _filteredPlaces = widget.places
          .where((place) => place
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Search places',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredPlaces.isEmpty
              ? Center(child: Text('No data found'))
              : ListView.builder(
                  itemCount: _filteredPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredPlaces[index]),
                      onTap: () {
                        widget.onPlaceSelected(_filteredPlaces[index]);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}