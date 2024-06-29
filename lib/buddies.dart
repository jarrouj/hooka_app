import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/map.dart';

class Buddy {
  final String name;
  final String imageUrl;

  Buddy({required this.name, required this.imageUrl});
}

class BuddiesPage extends StatefulWidget {
  @override
  _BuddiesPageState createState() => _BuddiesPageState();
}

class _BuddiesPageState extends State<BuddiesPage> {
  List<Buddy> buddies = [
    Buddy(name: 'Jacob', imageUrl: 'assets/images/profile-img.png'),
    Buddy(name: 'Jacop', imageUrl: 'assets/images/profile-img.png'),
    Buddy(name: 'Jakob', imageUrl: 'assets/images/profile-img.png'),
    Buddy(name: 'Jakop', imageUrl: 'assets/images/profile-img.png'),
    Buddy(name: 'Yaakoub', imageUrl: 'assets/images/profile-img.png'),
    Buddy(name: 'Jaykcop', imageUrl: 'assets/images/profile-img.png'),
  ];

  List<Buddy> filteredBuddies = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredBuddies = buddies;
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
  }

  void _sortBuddiesByRating() {
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
      body: Column(
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
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
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
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
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
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.asset(
                            buddy.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          buddy.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
