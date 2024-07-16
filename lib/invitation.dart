import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/buddies.dart';
import 'package:hooka_app/login.dart';
import 'package:hooka_app/main.dart';
import 'package:hooka_app/places-detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> receivedInvitations = [];
  List<Map<String, dynamic>> sentInvitations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchReceivedInvitations();
    fetchSentInvitations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchReceivedInvitations() async {
    var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Invitations/GetRecievedInvitations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data']['data'];
      setState(() {
        receivedInvitations = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load received invitations');
    }
  }

  Future<void> fetchSentInvitations() async {
    var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Invitations/GetSentInvitations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data']['data'];
      setState(() {
        sentInvitations = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load sent invitations');
    }
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
          SizedBox(width: 55),
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
          receivedInvitations.isEmpty
              ? Center(child: LoadingAllpages())
              : ListView.builder(
                  itemCount: receivedInvitations.length,
                  itemBuilder: (context, index) {
                    final invitation = receivedInvitations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecievedInvitation(invitation: invitation),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                NetworkImage(invitation['buddyImage']),
                          ),
                          title: Row(
                            children: [
                              Text(
                                invitation['buddyName'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(Icons.check),
                              const SizedBox(width: 45),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invitation['restaurantName'],
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd').format(DateTime.parse(invitation['invitationDate'])),
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                              Text(
                                invitation['invitationOption'],
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          sentInvitations.isEmpty
              ? const Center(child: LoadingAllpages())
              : ListView.builder(
                  itemCount: sentInvitations.length,
                  itemBuilder: (context, index) {
                    final invitation = sentInvitations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InvitationDetailsPage(placeId: invitation['placeId']),
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(invitation['image'],
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Text(invitation['placeName'],
                                            style: const TextStyle(fontSize: 20)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetailsPage(
                                                  placeId: invitation['placeId'],

                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Details',
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration: TextDecoration.underline,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${invitation['buddiesCount']} Buddies',
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(height: 20),
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

class RecievedInvitation extends StatelessWidget {
  final Map<String, dynamic> invitation;

  const RecievedInvitation({required this.invitation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Received Invitation',
            style: GoogleFonts.comfortaa(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(invitation['buddyImage'],
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              invitation['buddyName'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            const Row(
              children: [
                Text('Invitation Option',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer(invitation['invitationOption'], Icons.info),
            const Row(
              children: [
                Text('Place',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer(invitation['restaurantName'], Icons.place),
            const Row(
              children: [
                Text('Date & Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Row(
              children: [
                buildDateContainer(
                    DateFormat('yyyy-MM-dd').format(DateTime.parse(invitation['invitationDate']))),
                SizedBox(width: 20,),
                buildTimeContainer(
                    DateFormat('HH:mm').format(DateTime.parse(invitation['invitationDate']))),
              ],
            ),
            const Row(
              children: [
                Text('Notes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer(invitation['description'], Icons.description),
          ],
        ),
      ),
    );
  }

  Widget buildInfoContainer(String value, IconData icon) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    padding: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(width: 10),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget buildDateContainer(String date) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.black),
          SizedBox(width: 10),
          Text(
            date,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeContainer(String time) {
    return Container(
      width: 173,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: Colors.black),
          SizedBox(width: 10),
          Text(
            time,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class SentInvitationDetails extends StatefulWidget {
  final int placeId;

  const SentInvitationDetails({required this.placeId, Key? key})
      : super(key: key);

  @override
  State<SentInvitationDetails> createState() => _SentInvitationDetailsState();
}

class _SentInvitationDetailsState extends State<SentInvitationDetails> {
  late bool isFavorite;
  late Map<String, dynamic> placeDetails;

  @override
  void initState() {
    super.initState();
    fetchPlaceDetails();
  }

  Future<void> fetchPlaceDetails() async {
    var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Places/GetPlace/${widget.placeId}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data']['data'];
      setState(() {
        placeDetails = data;
        isFavorite = placeDetails['isFavorite'];
      });
    } else {
      throw Exception('Failed to load place details');
    }
  }

  void _toggleFavorite() async {
    var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    final response = await http.post(
      Uri.parse('https://api.hookatimes.com/api/Places/ToggleFavorite/${widget.placeId}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      throw Exception('Failed to toggle favorite');
    }
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
    if (placeDetails == null) {
      return Scaffold(
        body: Center(child: LoadingAllpages()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Sent Invitation Details',
            style: GoogleFonts.comfortaa(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(placeDetails['image'],
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              placeDetails['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            const Row(
              children: [
                Text('Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer('Rating: ${placeDetails['rating']}', Icons.star),
            buildInfoContainer(placeDetails['location'], Icons.place),
            buildInfoContainer(placeDetails['description'], Icons.info),
            const Row(
              children: [
                Text('Opening Hours',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer(
                '${placeDetails['openingFrom']} - ${placeDetails['openingTo']}',
                Icons.access_time),
            const Row(
              children: [
                Text('Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer(placeDetails['phoneNumber'], Icons.phone),
            const Row(
              children: [
                Text('Notes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            buildInfoContainer('', Icons.description),
          ],
        ),
      ),
    );
  }

  Widget buildInfoContainer(String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final int placeId;

  const DetailsPage({required this.placeId, Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Map<String, dynamic>> placeDetails;

  @override
  void initState() {
    super.initState();
    placeDetails = fetchPlaceDetails(widget.placeId);
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(int placeId) async {
     var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Invitations/GetPlaceInvtations/$placeId'),
       headers: {
      'Authorization': 'Bearer $token',
    },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['data'];
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text('Sent Invitation Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: placeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingAllpages());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var data = snapshot.data!;
            var buddies = data['buddies'] as List<dynamic>;
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        data['placeImage'],
                        width: 200,
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['placeName'],
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
                            color: data['placeRating'] > 4
                                ? Colors.green.shade700
                                : data['placeRating'] >= 3
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                data['placeRating'].toString(),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: buddies.length,
                      itemBuilder: (context, index) {
                        var buddy = buddies[index];
                        return Card(
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
                                    child: Image.network(
                                      buddy['buddyImage'] ?? 'http://www.hookatimes.com/Images/Buddies/user-placeholder.png',
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
                                        buddy['buddyName'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        buddy['invitationStatus'],
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class InvitationDetailsPage extends StatefulWidget {
  final int placeId;

  InvitationDetailsPage({
    Key? key,
    required this.placeId,
  }) : super(key: key);

  @override
  _InvitationDetailsPageState createState() => _InvitationDetailsPageState();
}

class _InvitationDetailsPageState extends State<InvitationDetailsPage> {
  bool isFavorite = false;
  PlaceDetail? placeDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaceDetails();
  }

  Future<void> _fetchPlaceDetails() async {
    final response = await http.get(Uri.parse(
        'https://api.hookatimes.com/api/Places/GetPlace/${widget.placeId}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['data'];
      setState(() {
        placeDetail = PlaceDetail.fromJson(data);
        isLoading = false;
      });
      _checkFavoriteStatus();
    } else {
      throw Exception('Failed to load place details');
    }
  }

  void _checkFavoriteStatus() {
    final savedFavorites = mybox?.get('favoriteIds', defaultValue: []) as List;
    setState(() {
      isFavorite = savedFavorites.contains(widget.placeId);
    });
  }

  void _toggleFavorite() {
    final savedFavorites = mybox?.get('favoriteIds', defaultValue: []) as List;
    setState(() {
      if (isFavorite) {
        savedFavorites.remove(widget.placeId);
      } else {
        savedFavorites.add(widget.placeId);
      }
      mybox?.put('favoriteIds', savedFavorites);
      isFavorite = !isFavorite;
    });

    // Call the callback to refresh the main page
    // widget.onFavoriteToggle();
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
    return  isLoading
          ? const Center(child: LoadingAllpages())
          :Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0, 
  leading: Padding(
    padding: const EdgeInsets.all(8.0), 
    child: SizedBox(
      width: 32, 
      height: 32, 
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20), 
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.only(left: 8), 
            constraints: BoxConstraints(),
          ),
        ),
      ),
    ),
  ),
),
      body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/hookatimeslogo.png',
                      image: placeDetail!.imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/hookatimeslogo.png',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                placeDetail!.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: placeDetail!.rating > 4
                                    ? Colors.green.shade700
                                    : placeDetail!.rating >= 3
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  Text(
                                    placeDetail!.rating.toString(),
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
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: _toggleFavorite,
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(placeDetail!.cuisine),
                            const Spacer(),
                            const Icon(
                              Icons.fastfood,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _openMap(placeDetail!.location),
                              child: Text(
                                placeDetail!.location,
                                style: const TextStyle(
                                  // decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => _openMap(placeDetail!.location),
                              child: const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                placeDetail!.description,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.info_outline,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),

                          const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _openPhoneDialer(placeDetail!.phoneNumber),
                              child: Text(
                                placeDetail!.phoneNumber,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  _openPhoneDialer(placeDetail!.phoneNumber),
                              child: const Icon(
                                Icons.phone,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 5),
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
                        ' Opening hours [ ${placeDetail!.openingFrom} - ${placeDetail!.openingTo} ]',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Row(
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
                                  builder: (context) => BuddiesPage(),
                                ));
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
                        const SizedBox(height: 15),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                         Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                               Icon(
                              Icons.add_circle,
                              color: Colors.yellow.shade600,
                              size: 25,
                            ),
                            const SizedBox(width: 5),
                               GestureDetector(
                              onTap: () {
                             
                              },
                              child: const Text(
                                'Add review',
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
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: const Border(
                              left: BorderSide(color: Colors.grey, width: 0.6),
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.6),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
