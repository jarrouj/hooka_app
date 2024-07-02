import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/buddies.dart';
import 'package:hooka_app/login.dart';
import 'package:hooka_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class PlaceDetail {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final String longitude;
  final String latitude;
  final String cuisine;
  final String openingFrom;
  final String openingTo;
  final String description;
  final String phoneNumber;

  PlaceDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.longitude,
    required this.latitude,
    required this.cuisine,
    required this.openingFrom,
    required this.openingTo,
    required this.description,
    required this.phoneNumber,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'],
      rating: (json['rating'] ?? 0).toDouble(),
      location: json['location'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      cuisine: json['cuisine'],
      openingFrom: json['openingFrom'],
      openingTo: json['openingTo'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class PlacesDetailPage extends StatefulWidget {
  final int placeId;
  final VoidCallback onFavoriteToggle;

  PlacesDetailPage({
    Key? key,
    required this.placeId,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  _PlacesDetailPageState createState() => _PlacesDetailPageState();
}

class _PlacesDetailPageState extends State<PlacesDetailPage> {
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
    widget.onFavoriteToggle();
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
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
