import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/contactus.dart';
import 'package:hooka_app/login.dart';
import 'package:hooka_app/places.dart';
import 'package:hooka_app/products.dart';
import 'package:hooka_app/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Box? mybox;

Future<Box> openHiveBox(String boxname) async {
  if(!Hive.isBoxOpen(boxname)){
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  return await Hive.openBox(boxname);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  mybox = await openHiveBox("Favorite");
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget page = MainScreen();
  final _zoomDrawerController = ZoomDrawerController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _zoomDrawerController,
      menuScreen: Builder(
        builder: (context) {
          return MenuScreen(
            onPageChange: (a, index) {
              setState(() {
                page = a;
                selectedIndex = index;
              });
              
              ZoomDrawer.of(context)!.close();
            },
            selectedIndex: selectedIndex,
          );
        },
      ),
      mainScreen: page,
      borderRadius: 24.0,
      showShadow: true,
      drawerShadowsBackgroundColor: const Color.fromARGB(255, 57, 55, 55),
      menuBackgroundColor: Colors.black,
      mainScreenTapClose: true,
      angle: -13,
      slideWidth: 290,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentPage();
  }
}

class ListItems {
  final Icon icon;
  final Text title;
  final Widget page;

  ListItems(this.icon, this.title, this.page);
}

class MenuScreen extends StatefulWidget {
  final Function(Widget, int) onPageChange;
  final int selectedIndex;

  MenuScreen({Key? key, required this.onPageChange, required this.selectedIndex}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late int selectedIndex;

  final List<ListItems> drawerItems = [
    ListItems(
      Icon(Icons.home, color: Colors.yellow.shade600),
      const Text('MainScreen'),
      const MainScreen(),
    ),
    ListItems(
      Icon(Icons.check, color: Colors.yellow.shade600),
      const Text('Checkout'),
      const CheckoutPage(),
    ),
    ListItems(
      Icon(Icons.star_border_outlined, color: Colors.yellow.shade600),
      const Text('My Orders'),
      const OrderPage(),
    ),
    ListItems(
      Icon(Icons.calendar_month_outlined, color: Colors.yellow.shade600),
      const Text('Invitations'),
      const InvitationsPage(),
    ),
    ListItems(
      Icon(Icons.notifications, color: Colors.yellow.shade600),
      const Text('Notifications'),
      const NotificationsPage(),
    ),
    ListItems(
      Icon(Icons.contact_phone, color: Colors.yellow.shade600),
      const Text('Contact Us'),
      const ContactMainScreen(), // Replace with actual Contact Us screen
    ),
    ListItems(
      Icon(Icons.settings, color: Colors.yellow.shade600),
      const Text('Settings'),
      const SettingsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                       showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
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
                              SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                
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
                                            const LoginPage()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.login),
                                    const SizedBox(width: 5),
                                    const Text(
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
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '',
                    style: TextStyle(color: Colors.yellow.shade600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ...drawerItems.asMap().entries.map((entry) {
              int idx = entry.key;
              ListItems item = entry.value;
              bool isSelected = selectedIndex == idx;

              return Container(
                color: isSelected ? Colors.yellow.shade600 : Colors.transparent,
                child: ListTile(
                  onTap: () {
                    setState(() {
                      selectedIndex = idx;
                    });
                    widget.onPageChange(item.page, idx);
                  },
                  title: Text(
                    item.title.data!,
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white),
                  ),
                  leading: Icon(
                    item.icon.icon,
                    color: isSelected ? Colors.black : Colors.yellow.shade600,
                  ),
                ),
              );
            }).toList(),

            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.yellow.shade600,
                ),
                title: Text(
                  'Log in',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title:  Center(
          child: Text(
            'Hookapp',
            style: GoogleFonts.comfortaa(), 
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
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
                              SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                
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
                                            const LoginPage()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.login),
                                    const SizedBox(width: 5),
                                    const Text(
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
          ),
          const SizedBox(width: 3),
        ],
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => ZoomDrawer.of(context)!.toggle()),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.grey.shade300,
              Colors.grey.shade300,
            ],
          ),
        ),
        child: ListView(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.transparent],
                  stops: [
                    0.8,
                    0.95
                  ], // Adjust the stops to make the fade effect smaller
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/shops.jpeg',
                fit: BoxFit.cover,
                height: screenHeight * 0.22,
                width: double.infinity,
              ),
            ),
            Center(
              child: Column(
                children: [
                  // const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/hookatimeslogo.png',
                    // height: screenHeight * 0.2,
                    // width: screenWidth * 0.7,
                    // fit: BoxFit.cover,
                  ),
                  // const SizedBox(height: 40),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PlacesStartPage()));
                            },
                            child: _buildCard1(
                              context,
                              'assets/images/location.png',
                              'Places',
                              screenWidth,
                              screenHeight,
                            ),
                          ),
                          SizedBox(width: isLargeScreen ? 20 : 5),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const SizedBox(
                        height: 30,
                      ),
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
                             const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                
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
                                            const LoginPage()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.login),
                                    const SizedBox(width: 5),
                                    const Text(
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
                            child: _buildCard1(
                              context,
                              'assets/images/friends.png',
                              
                              'BUDDIES',
                              screenWidth,
                              screenHeight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const OffersPage(),
                                ),
                              );
                            },
                            child: _buildCard2(
                              context,
                              'assets/images/offers.png',
                              'OFFERS',
                              screenWidth,
                              screenHeight,
                            ),
                          ),
                          SizedBox(width: isLargeScreen ? 20 : 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ProductsPage(),
                                ),
                              );
                            },
                            child: _buildCard2(
                              context,
                              'assets/images/products.png',
                              'PRODUCTS',
                              screenWidth,
                              screenHeight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildCard1(BuildContext context, String imagePath, String label,
      double screenWidth, double screenHeight) {
    final cardSize = screenWidth * 0.4;
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        color: Colors.yellow.shade700,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: screenHeight * 0.05),
          Image.asset(
            imagePath,
            width: cardSize * 0.6,
            height: cardSize * 0.35,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildCard2(BuildContext context, String imagePath, String label,
      double screenWidth, double screenHeight) {
    final cardSize = screenWidth * 0.4;
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        color: Colors.yellow.shade700,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: screenHeight * 0.05),
          Image.asset(
            imagePath,
            width: cardSize * 0.6,
            height: cardSize * 0.5,
          ),
          SizedBox(height: screenHeight * 0.002),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
