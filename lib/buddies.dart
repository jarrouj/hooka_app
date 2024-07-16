import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/map.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class Buddy {
  final int id;
  final String name;
  final String about;
  final bool isAvailable;
  final int rating;
  final String imageUrl;
  final int distance;
  final bool hasPendingInvite;
  final String longitude;
  final String latitude;

  Buddy({
    required this.id,
    required this.name,
    required this.about,
    required this.isAvailable,
    required this.rating,
    required this.imageUrl,
    required this.distance,
    required this.hasPendingInvite,
    required this.longitude,
    required this.latitude,
  });

  factory Buddy.fromJson(Map<String, dynamic> json) {
    return Buddy(
      id: json['id'],
      name: json['name'],
      about: json['about'],
      isAvailable: json['isAvailable'],
      rating: json['rating'],
      imageUrl: json['image'],
      distance: json['distance'],
      hasPendingInvite: json['hasPendingInvite'],
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
    );
  }
}

class BuddiesPage extends StatefulWidget {
  @override
  _BuddiesPageState createState() => _BuddiesPageState();
}

class _BuddiesPageState extends State<BuddiesPage> {
  List<Buddy> buddies = [];
  List<Buddy> filteredBuddies = [];
  String searchQuery = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBuddies();
  }

  Future<void> fetchBuddies() async {
    final response = await http.get(Uri.parse('https://api.hookatimes.com/api/Buddies/GetAllBuddies?sortBy=0&filterBy=0'));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];

        setState(() {
          buddies = data.map((json) => Buddy.fromJson(json)).toList();
          filteredBuddies = buddies;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to parse data';
        });
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load buddies: ${response.reasonPhrase}';
      });
    }
  }

  void _filterBuddies(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredBuddies = buddies.where((buddy) {
        return buddy.name.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void _sortBuddiesByNearest() {
    setState(() {
      filteredBuddies.sort((a, b) => a.distance.compareTo(b.distance));
    });
  }

  void _sortBuddiesByRating() {
    setState(() {
      filteredBuddies.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  void _navigateToInvitePage(Buddy buddy) async {
   

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvitePage(buddy: buddy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text('Buddies', style: GoogleFonts.comfortaa(fontSize: 20)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
            child: Text('Map', style: GoogleFonts.comfortaa(color: Colors.black)),
          )
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
                          hintText: 'Find Buddies...',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: Colors.grey.shade800),
                        onChanged: _filterBuddies,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: _sortBuddiesByNearest,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade500),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text('Nearest'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _sortBuddiesByRating,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade500),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text('Rating'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 3,
                        ),
                        itemCount: filteredBuddies.length,
                        itemBuilder: (context, index) {
                          final buddy = filteredBuddies[index];
                          return GestureDetector(
                            onTap: () => _navigateToInvitePage(buddy),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/hookatimeslogo-nobg.png',
                                      image: buddy.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/hookatimeslogo-nobg.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        buddy.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
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
}
class InvitePage extends StatelessWidget {
  final Buddy buddy;

  InvitePage({required this.buddy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile', style: GoogleFonts.comfortaa(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/hookatimeslogo.png',
                  image: buddy.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/hookatimeslogo.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    buddy.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InvitePageB(buddy: buddy)));
                    },
                    child: Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text('Invite'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InvitePageB extends StatefulWidget {
  final Buddy buddy;

  const InvitePageB({required this.buddy, Key? key}) : super(key: key);

  @override
  State<InvitePageB> createState() => _InvitePageBState();
}

class _InvitePageBState extends State<InvitePageB> {
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
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black, 
              
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, 
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.grey, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.white, // Body background color
              onSurface: Colors.black, // Body text color
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Colors.black,
              dialBackgroundColor: Colors.grey[200],
              hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.black
                      : Colors.grey),
              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.grey[400]!
                      : Colors.white),
              hourMinuteShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.black
                      : Colors.grey),
              dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.grey[400]!
                      : Colors.white),
              dayPeriodShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Button text color
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
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
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
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

  Future<void> _sendInvite() async {
     var box = await Hive.openBox('myBox');
    String? token = box.get('token');
    if (_selectedPlace.isEmpty ||
        _messageController.text.isEmpty ||
        (!_isPayForHookapp && !_isPayForFood && !_isPayYourOwn)) {
      _showOverlaySnackBar(context, 'Please fill all fields');
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.hookatimes.com/api/Buddies/InviteBuddy'),
      );
      request.headers['Authorization'] = 'Bearer ${token}';
      request.fields['Date'] = _selectedDate.toIso8601String();
      request.fields['Time'] = _selectedTime.format(context);
      request.fields['OptionId'] = _getSelectedOptionId().toString();
      request.fields['Description'] = _messageController.text;
      request.fields['ToBuddyId'] = widget.buddy.id.toString();
      request.fields['PlaceId'] = _selectedPlace;

      var response = await request.send();

      if (response.statusCode == 200) {
        _showOverlaySnackBar(context, 'Invite sent');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } else {
        _showOverlaySnackBar(context, 'Failed to send invite');
      }
    } catch (e) {
      _showOverlaySnackBar(context, 'An error occurred');
    }
  }

  int _getSelectedOptionId() {
    if (_isPayForHookapp) return 1;
    if (_isPayForFood) return 2;
    if (_isPayYourOwn) return 3;
    return 0;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  'Choose a place',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => _showPlacePicker(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      // color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
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
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      Text(
                        'Choose date time',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
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
                          style: TextStyle(color: Colors.grey.shade800,),
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
                          style: TextStyle(color: Colors.grey.shade800,),
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
                    hintStyle: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _sendInvite,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade600,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Send',
                        style: GoogleFonts.comfortaa(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
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