import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/main.dart';
import 'package:hooka_app/map.dart';
import 'package:hooka_app/places-detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cuisine {
  final int id;
  final String title;

  Cuisine({
    required this.id,
    required this.title,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Place {
  final int id;
  final String imageUrl;
  final String name;
  final String cuisine;
  final String location;
  final double rating;
  final bool isInFavorite;
  final String longitude;
  final String latitude;
  final int distance;

  Place({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.cuisine,
    required this.location,
    required this.rating,
    required this.isInFavorite,
    required this.longitude,
    required this.latitude,
    required this.distance,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? 0,
      imageUrl: json['image'] ?? '',
      name: json['name'] ?? '',
      cuisine: json['cuisine'] ?? '',
      location: json['location'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isInFavorite: json['isInFavorite'] ?? false,
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      distance: json['distance'] ?? 0,
    );
  }
}

class MainPlacesPage extends StatefulWidget {
  const MainPlacesPage({super.key});

  @override
  _MainPlacesPageState createState() => _MainPlacesPageState();
}

class _MainPlacesPageState extends State<MainPlacesPage> {
  List<Cuisine> cuisines = [];
  String? selectedCuisine;
  List<Place> places = [];
  List<Place> filteredPlaces = [];
  List<int> favoriteIds = [];
  bool isLoading = false;
  bool isRatingPressed = false;
  bool showFavoritesOnly = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCuisines();
    _fetchPlaces();
    _loadFavorites();
  }

  Future<void> _fetchCuisines() async {
    final response = await http.get(Uri.parse('https://api.hookatimes.com/api/Cuisines/GetCuisines'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['data'] != null && data['data']['data'] != null) {
        setState(() {
          cuisines = (data['data']['data'] as List)
              .map((json) => Cuisine.fromJson(json))
              .toList();
          if (cuisines.isNotEmpty) {
            cuisines.insert(0, Cuisine(id: 0, title: 'Cuisines'));
            selectedCuisine = cuisines.first.title;
          } else {
            selectedCuisine = null;
          }
        });
      } else {
        throw Exception('Failed to load cuisines');
      }
    } else {
      throw Exception('Failed to load cuisines');
    }
  }

  Future<void> _fetchPlaces() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://api.hookatimes.com/api/Places/GetAllPlaces'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['data'] != null && data['data']['data'] != null) {
        setState(() {
          places = (data['data']['data'] as List)
              .map((json) => Place.fromJson(json))
              .toList();
          filteredPlaces = List.from(places);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load places');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load places');
    }
  }

  void _filterPlaces(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _loadFavorites() {
    final savedFavorites = mybox?.get('favoriteIds', defaultValue: []) as List?;
    setState(() {
      favoriteIds = savedFavorites?.cast<int>() ?? [];
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
      isRatingPressed = !isRatingPressed;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Place> tempPlaces = List.from(places);

    if (searchQuery.isNotEmpty) {
      tempPlaces = tempPlaces.where((place) {
        return place.name.toLowerCase().contains(searchQuery) ||
            place.location.toLowerCase().contains(searchQuery);
      }).toList();
    }

    if (showFavoritesOnly) {
      tempPlaces = tempPlaces.where((place) => favoriteIds.contains(place.id)).toList();
    }

    if (selectedCuisine != null && selectedCuisine != 'Cuisines') {
      tempPlaces = tempPlaces.where((place) {
        return place.cuisine.toLowerCase() == selectedCuisine!.toLowerCase();
      }).toList();
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
      selectedCuisine = cuisines.first.title;
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.grey.shade500),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.yellow.shade600),
                ),
                prefixIcon: Icon(Icons.search, size: 32, color: Colors.grey.shade500),
                hintText: 'Restaurant name...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(color: Colors.grey.shade800),
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
                  height: 35,
                  child: DropdownButtonFormField<String>(
                    value: selectedCuisine,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCuisine = newValue!;
                        _applyFilters();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    items: [
                      for (var cuisine in cuisines)
                        DropdownMenuItem<String>(
                          value: cuisine.title,
                          child: Text(
                            cuisine.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Icon(Icons.close, color: Colors.yellow.shade600),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade500),
                    )),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
                    minimumSize: MaterialStateProperty.all(Size(80, 35)),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                  ),
                  onPressed: () {
                    // Add your onPressed functionality here
                  },
                  child: const Text('Nearest', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(90, 35)),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade500),
                    )),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
                  ),
                  onPressed: _showFavorites,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showFavoritesOnly)
                        const Icon(Icons.check, color: Colors.black, size: 10),
                      if (showFavoritesOnly) const SizedBox(width: 5),
                      const Text('Favorites', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(80, 35)),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade500),
                    )),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
                  ),
                  onPressed: _sortPlacesByRating,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isRatingPressed)
                        const Icon(Icons.check, color: Colors.black, size: 10),
                      const SizedBox(width: 5),
                      const Text('Rating', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 15),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPlaces.isEmpty
                    ? const Center(
                        child: Text('No restaurants found', style: TextStyle(fontSize: 20)),
                      )
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
                                  color: Colors.grey.withOpacity(0.1),
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
                                        builder: (context) => PlacesDetailPage(
                                          placeId: place.id,
                                          onFavoriteToggle: _loadFavorites,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/hookatimeslogo.png',
                                      image: place.imageUrl,
                                      height: 200,
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, top: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            place.name,
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 13),
                                            child: Container(
                                              width: 50,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: place.rating > 4
                                                    ? Colors.green.shade700
                                                    : place.rating >= 3
                                                        ? Colors.orange
                                                        : Colors.red,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    place.rating.toString(),
                                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                                  ),
                                                  const Icon(Icons.star, color: Colors.white, size: 10),
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
                                            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => _toggleFavorite(place.id),
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 22),
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
                                      Text(
                                        place.location,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Places',
            style: GoogleFonts.comfortaa(),
          ),
        ),
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
            child: Text(
              'Map',
              style: GoogleFonts.comfortaa(fontSize: 15),
            ),
          ),
          const SizedBox(
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
