import 'package:flutter/material.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/main.dart';
import 'package:hooka_app/map.dart';
import 'package:hooka_app/places-detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cuisine {
  final String name;

  Cuisine({required this.name});

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(name: json['strArea']);
  }
}

class Place {
  final int id;
  final String imageUrl;
  final String title;
  final String cuisine;
  final String location;
  final double rating;
  final String description;
  final String phoneNumber;
  final String openingHours;

  Place({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.cuisine,
    required this.location,
    required this.rating,
    required this.description,
    required this.phoneNumber,
    required this.openingHours,
  });
}

class MainPlacesPage extends StatefulWidget {
  const MainPlacesPage({super.key});

  @override
  _MainPlacesPageState createState() => _MainPlacesPageState();
}

class _MainPlacesPageState extends State<MainPlacesPage> {
  List<Cuisine> cuisines = [];
  String? selectedCuisine;

  List<Place> places = [
    Place(
        id: 1,
        imageUrl: 'assets/images/resta.avif',
        title: 'Place 1',
        cuisine: 'Italian',
        location: 'New York, NY',
        rating: 2,
        description: 'The Place Where you Can Chill and Relax',
        phoneNumber: '76974972',
        openingHours: '12:00am - 12:00pm'),
    Place(
        id: 2,
        imageUrl: 'assets/images/hookatimeslogo.png',
        title: 'Place 2',
        cuisine: 'Mexican',
        location: 'Los Angeles, CA',
        rating: 4.0,
        description: 'The Place Where you Can Chill and Relax',
        phoneNumber: '76974972',
        openingHours: '12:00am - 12:00pm'),
    Place(
        id: 3,
        imageUrl: 'assets/images/hookatimeslogo.png',
        title: 'Place 3',
        cuisine: 'Chinese',
        location: 'San Francisco, CA',
        rating: 2.9,
        description: 'The Place Where you Can Chill and Relax',
        phoneNumber: '76974972',
        openingHours: '12:00am - 12:00pm'),
  ];

  List<Place> filteredPlaces = [];
  List<int> favoriteIds = [];
  bool isLoading = false;
  bool isRatingPressed = false;
  bool showFavoritesOnly = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredPlaces = List.from(places);
    _fetchCuisines();
    _loadFavorites();
  }

  Future<void> _fetchCuisines() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        cuisines = (data['meals'] as List)
            .map((json) => Cuisine.fromJson(json))
            .toList();
        if (cuisines.isNotEmpty) {
          cuisines.insert(0, Cuisine(name: 'Cuisines'));
          selectedCuisine = cuisines.first.name;
        } else {
          selectedCuisine = null;
        }
      });
    } else {
      throw Exception('Failed to load cuisines');
    }
  }

  void _filterPlaces(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _loadFavorites() {
    final savedFavorites = mybox?.get('favoriteIds', defaultValue: []) as List;
    setState(() {
      favoriteIds = savedFavorites.cast<int>();
    });
  }

  void _toggleFavorite(int placeId) {
    setState(() {
      if (favoriteIds.contains(placeId)) {
        favoriteIds.remove(placeId);
      } else {
        favoriteIds.add(placeId);
      }
      mybox?.put('favoriteIds', favoriteIds);
      _applyFilters();
    });
  }

  void _sortPlacesByRating() {
    setState(() {
      isLoading = true;
      isRatingPressed = !isRatingPressed;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _applyFilters();
        isLoading = false;
      });
    });
  }

  void _applyFilters() {
    List<Place> tempPlaces = List.from(places);

    if (searchQuery.isNotEmpty) {
      tempPlaces = tempPlaces.where((place) {
        return place.title.toLowerCase().contains(searchQuery) ||
            place.location.toLowerCase().contains(searchQuery);
      }).toList();
    }

    if (showFavoritesOnly) {
      tempPlaces =
          tempPlaces.where((place) => favoriteIds.contains(place.id)).toList();
    }

    if (isRatingPressed) {
      tempPlaces.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() {
      filteredPlaces = tempPlaces;
    });
  }

  void _resetFilters() {
    setState(() {
      selectedCuisine = cuisines.first.name;
      isRatingPressed = false;
      showFavoritesOnly = false;
      searchQuery = '';
      filteredPlaces = List.from(places);
    });
  }

  void _showFavorites() {
    setState(() {
      showFavoritesOnly = !showFavoritesOnly;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.yellow.shade600,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 32,
                  color: Colors.grey.shade500,
                ),
                hintText: 'Restaurant name...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
              onChanged: _filterPlaces,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  height: 40,
                  child: DropdownButtonFormField<String>(
                    value: selectedCuisine,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCuisine = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                      ),
                    ),
                    items: [
                      for (var cuisine in cuisines)
                        DropdownMenuItem<String>(
                          value: cuisine.name,
                          child: Text(cuisine.name),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Icon(Icons.cancel, color: Colors.yellow.shade600),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade500),
                    )),
                    textStyle: WidgetStateProperty.all(const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
                    minimumSize: WidgetStateProperty.all(Size(80, 35)), 
                    padding: WidgetStateProperty.all(
                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                  ),
                  onPressed: () {
                    // Add your onPressed functionality here
                  },
                  child: const Text(
                    'Newest',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    // maximumSize:WidgetStateProperty.all(Size(120, 40)), 
                    minimumSize: WidgetStateProperty.all(Size(80, 35)), 
                      padding: WidgetStateProperty.all(
                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade500),
                    )),
                    textStyle: WidgetStateProperty.all(const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                  ),
                  onPressed: _showFavorites,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showFavoritesOnly)
                        const Icon(Icons.check, color: Colors.black, size: 15),
                      const SizedBox(width: 5),
                      const Text(
                        'Favorites',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(80, 35)), 
                      padding: WidgetStateProperty.all(
                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade500),
                    )),
                    textStyle: WidgetStateProperty.all(const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                  ),
                  onPressed: _sortPlacesByRating,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isRatingPressed)
                        const Icon(Icons.check, color: Colors.black, size: 15),
                      const SizedBox(width: 5),
                      const Text(
                        'Rating',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  'Popular restaurant around you',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlacesDetailPage(place: place),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Image.asset(
                                  place.imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        place.title,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 13),
                                        child: Container(
                                          width: 50,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: place.rating > 4
                                                ? Colors.green.shade700
                                                : place.rating >= 3
                                                    ? Colors.orange
                                                    : Colors.red,
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 5),
                                              Text(
                                                place.rating.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(width: 5),
                                              const Icon(Icons.star,
                                                  color: Colors.white,
                                                  size: 13),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        place.cuisine,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade800),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => _toggleFavorite(place.id),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 22),
                                          child: Icon(
                                            favoriteIds.contains(place.id)
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: Colors.yellow.shade700,
                                            size: 27,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    place.location,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PlacesStartPage extends StatefulWidget {
  const PlacesStartPage({super.key});

  @override
  _PlacesStartPageState createState() => _PlacesStartPageState();
}

class _PlacesStartPageState extends State<PlacesStartPage> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    _changeBodyContent();
  }

  void _changeBodyContent() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('Places')),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapPage(),
                  ),
                );
              },
              child: Text('Map')),
          SizedBox(
            width: 20,
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
      body: _showLoading ? const LoadingAllpages() : const MainPlacesPage(),
    );
  }
}
