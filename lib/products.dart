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
  List<Product> products = [
    Product(
        name: "Margerita Pizza",
        image: "assets/images/pizza.jpg",
        price: 5.00),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _updateProducts(List<Product> updatedProducts) {
    setState(() {
      products = updatedProducts;
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
          ProductsContent(
            products: products,
            updateProducts: _updateProducts,
          ),
          if (isLoading) LoadingAllpages(),
        ],
      ),
    );
  }
}

class ProductsContent extends StatelessWidget {
  final List<Product> products;
  final Function(List<Product>) updateProducts;

  const ProductsContent({
    Key? key,
    required this.products,
    required this.updateProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductsDetails(products: products),
                      ),
                    );
                    if (result != null) {
                      updateProducts(result);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        32, // Adjust width for padding
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Image.asset(
                        'assets/images/pizza.jpg',
                        
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pizza',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Comfortaa',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

class ProductsDetails extends StatelessWidget {
  final List<Product> products;

  const ProductsDetails({Key? key, required this.products}) : super(key: key);

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
            Navigator.of(context).pop(products);
          },
        ),
      ),
      body: Details(products: products),
    );
  }
}

class Details extends StatefulWidget {
  final List<Product> products;

  const Details({Key? key, required this.products}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _widthAnimations;
  List<int> _counters = [];

  void _goToCart() async {
    List<Product> cartItems = [];
    for (int i = 0; i < widget.products.length; i++) {
      if (_counters[i] > 0) {
        widget.products[i].quantity = _counters[i];
        cartItems.add(widget.products[i]);
      }
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
    );
    if (result != null) {
      setState(() {
        for (int i = 0; i < widget.products.length; i++) {
          _counters[i] = widget.products[i].quantity;
          if (_counters[i] == 0 && _controllers[i].isCompleted) {
            _controllers[i].reverse();
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _counters = List.generate(widget.products.length, (index) => widget.products[index].quantity);
    _controllers = List.generate(widget.products.length, (index) =>
        AnimationController(
          duration: const Duration(milliseconds: 100),
          vsync: this,
        ));
    _widthAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 40.0, end: 130.0).animate(controller)..addListener(() {
          setState(() {});
        })).toList();
    for (int i = 0; i < widget.products.length; i++) {
      if (_counters[i] > 0) {
        _controllers[i].forward();
      }
    }
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
    final double screenWidth = MediaQuery.of(context).size.width;

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
            height: screenHeight - 230,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
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
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.asset(product.image),
                            ),
                            const SizedBox(height: 10),
                            Text('USD ${product.price.toStringAsFixed(2)}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(product.name, textAlign: TextAlign.center, style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      if (!_controllers[index].isCompleted && !_controllers[index].isAnimating)
                        Positioned(
                          right: 11,
                          top: 15,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Positioned(
                        right: 13,
                        top: 18,
                        child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: screenWidth / 2 - 30,
                              ),
                              child: Container(
                                width: animation.value,
                                height: 38.0,
                                decoration: BoxDecoration(
                                  color: (!_controllers[index].isAnimating && !_controllers[index].isCompleted && _counters[index] > 0) ? Colors.yellow : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    if (_controllers[index].isCompleted)
                                      IconButton(
                                        icon: _counters[index] == 1
                                            ? Icon(Icons.delete_outline, color: Colors.yellow.shade700)
                                            : Icon(Icons.remove, color: Colors.yellow.shade700),
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
                                        icon: Icon(Icons.add, color: Colors.yellow.shade700),
                                        onPressed: () {
                                          setState(() {
                                            _counters[index]++;
                                          });
                                        },
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