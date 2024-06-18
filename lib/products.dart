import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/cart.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Hooka Products',
            style: GoogleFonts.comfortaa(fontSize: 20),
          ),
        ),
        actions: const [
          Icon(Icons.shopping_cart),
          SizedBox(
            width: 15,
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
      body: Stack(
        children: [
          ProductsContent(),
          if (isLoading) LoadingAllpages(),
        ],
      ),
    );
  }
}

class ProductsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsDetails(),
                        ),
                      );
                    },
                    child: Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/pizza.jpeg',
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class ProductsDetails extends StatelessWidget {
  const ProductsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'Details',
          style: GoogleFonts.comfortaa(fontSize: 20),
        )),
        actions: const [
          SizedBox(
            width: 55,
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
      body: const Details(),
    );
  }
}

class Product {
  final String name;
  final String image;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 0,
  });
}

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _widthAnimations;
  List<Product> products = [
    Product(name: "Margarita Pizza", image: "assets/images/pizza.jpeg", price: 5.00),
    // Product(name: "Margarita Pizza", image: "assets/images/pizza.jpeg", price: 5.00),
  ];
  List<int> _counters = [];

  void _goToCart() {
    List<Product> cartItems = [];
    for (int i = 0; i < products.length; i++) {
      if (_counters[i] > 0) {
        products[i].quantity = _counters[i];
        cartItems.add(products[i]);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)));
  }

  @override
  void initState() {
    super.initState();
    _counters = List.generate(products.length, (index) => 0);
    _controllers = List.generate(products.length, (index) =>
        AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        ));
    _widthAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 0.0, end: 71.0).animate(controller)..addListener(() {
          setState(() {});
        })).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggle(int index) {
    final controller = _controllers[index];
    if (controller.isCompleted) {
      controller.reverse();
    } else {
      setState(() {
        if (_counters[index] == 0) {
          _counters[index] = 1;
        }
      });
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text('Choose Your Flavor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight - 222,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final animation = _widthAnimations[index];
                return GestureDetector(
                  onTap: () => _toggle(index),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Image.asset(product.image),
                            const SizedBox(height: 10),
                            Text('USD ${product.price.toStringAsFixed(2)}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(product.name, textAlign: TextAlign.center, style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 11,
                        top: 15,
                        child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Container(
                              width: animation.value + 40,
                              height: 38.0,
                              decoration: BoxDecoration(
                                color: (!_controllers[index].isAnimating && !_controllers[index].isCompleted && _counters[index] > 0) ? Colors.yellow : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  if (_controllers[index].isCompleted)
                                    IconButton(
                                      icon:  Icon(Icons.remove, color: Colors.yellow.shade700),
                                      onPressed: () {
                                        setState(() {
                                          if (_counters[index] > 0) _counters[index]--;
                                          if (_counters[index] == 0) {
                                            _controllers[index].reverse();
                                          }
                                        });
                                      },
                                    ),
                                  if (_controllers[index].isCompleted && _counters[index] > 0)
                                    Text('${_counters[index]}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                  if (!_controllers[index].isCompleted && _counters[index] > 0)
                                    Text('${_counters[index]}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                  if (!_controllers[index].isCompleted && _counters[index] == 0)
                                     Icon(Icons.add, color: Colors.yellow.shade700),
                                  if (_controllers[index].isCompleted && _counters[index] == 0)
                                    IconButton(
                                      icon: const Icon(Icons.add, color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          _counters[index]++;
                                        });
                                      },
                                    ),
                                  if (_controllers[index].isCompleted && _counters[index] > 0)
                                    IconButton(
                                      icon:  Icon(Icons.add, color: Colors.yellow.shade700),
                                      onPressed: () {
                                        setState(() {
                                          _counters[index]++;
                                        });
                                      },
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
              },
            ),
          ),
          GestureDetector(
            onTap: _goToCart,
            child: Container(
              width: double.infinity,
              height: 65,
              color: Colors.yellow.shade600,
              child: const Center(
                child: Text('Go to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


