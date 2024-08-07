import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/cart.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isLoading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final box = await Hive.openBox<Product>('productsBox');
    if (box.isEmpty) {
      products = [
        Product(
          name: "Margerita Pizza",
          image: "assets/images/pizza.jpg",
          price: 5,
          quantity: 0,
        ),
        Product(
          name: "Margerita Pizza 2",
          image: "assets/images/pizza.jpg",
          price: 20,
          quantity: 0,
        ),
      ];
      for (var product in products) {
        await box.put(product.name, product);
      }
    } else {
      products = box.values.toList();
    }
    setState(() {
      isLoading = false;
    });
  }

  void _updateProducts(List<Product> updatedProducts) async {
    final box = await Hive.openBox<Product>('productsBox');
    setState(() {
      products = updatedProducts;
    });
    await box.clear();
    for (var product in updatedProducts) {
      await box.put(product.name, product);
    }
  }

  void _goToCart(BuildContext context) async {
    final box = await Hive.openBox<Product>('cartBox2');
    List<Product> cartItems = box.values.toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: cartItems),
      ),
    );
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
        actions: [
          GestureDetector(
            onTap: () {
              _goToCart(context);
            },
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(
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
                        builder: (context) => ProductsDetails(products: products),
                      ),
                    );
                    if (result != null) {
                      updateProducts(result);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32, // Adjust width for padding
                    height: MediaQuery.of(context).size.height * 0.17,
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

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final typeId = 0;

  @override
  Product read(BinaryReader reader) {
    return Product(
      name: reader.readString(),
      image: reader.readString(),
      price: reader.readDouble(),
      quantity: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.image);
    writer.writeDouble(obj.price);
    writer.writeInt(obj.quantity);
  }
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
          ),
        ),
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
  late List<int> _counters;

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
    if (_counters[index] == 0) {
      _updateQuantity(index, 1);
    }
    if (controller.isCompleted) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }

  void _setQuantityToOne(int index) {
    setState(() {
      if (_counters[index] == 0) {
        _counters[index] = 1;
        widget.products[index].quantity = _counters[index];
        _saveProduct(widget.products[index]);
      }
    });
  }

  void _updateQuantity(int index, int quantity) {
    setState(() {
      _counters[index] = quantity;
      widget.products[index].quantity = quantity;
      _saveProduct(widget.products[index]);
    });
  }

  Future<void> _saveProduct(Product product) async {
    final box = await Hive.openBox<Product>('productsBox');
    await box.put(product.name, product);
  }

  void _goToCart() async {
    List<Product> cartItems = [];
    for (int i = 0; i < widget.products.length; i++) {
      if (_counters[i] > 0) {
        widget.products[i].quantity = _counters[i];
        cartItems.add(widget.products[i]);
      }
    }
    // Save to Hive
    var box = Hive.box<Product>('cartBox2');
    await box.clear();
    for (var item in cartItems) {
      await box.put(item.name, item);
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

  void _handleTap(int index) {
    if (_controllers[index].isCompleted) {
      _controllers[index].reverse();
    } else {
      _setQuantityToOne(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Close all open buttons when tapping outside
          for (int i = 0; i < _controllers.length; i++) {
            if (_controllers[i].isCompleted) {
              _controllers[i].reverse();
            }
          }
        },
        child: Column(
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
              height: screenHeight - 223,
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
                    onTap: () => _handleTap(index),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                ),
                                child: Image.asset(product.image),
                              ),
                              const SizedBox(height: 10),
                              Text('USD ${product.price.toStringAsFixed(0)}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(product.name, textAlign: TextAlign.center, style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        if (!_controllers[index].isCompleted && !_controllers[index].isAnimating)
                          Positioned(
                            right: 1,
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
                          right: 3,
                          top: 18,
                          child: AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth / 2 - 30,
                                ),
                                child: GestureDetector(
                                  onTap: () => _toggle(index),
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
                                              _updateQuantity(index, _counters[index] - 1);
                                              if (_counters[index] == 0) {
                                                _controllers[index].reverse();
                                              }
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
                                              _updateQuantity(index, _counters[index] + 1);
                                            },
                                          ),
                                        if (_controllers[index].isCompleted && _counters[index] > 0)
                                          IconButton(
                                            icon: Icon(Icons.add, color: Colors.yellow.shade700),
                                            onPressed: () {
                                              _updateQuantity(index, _counters[index] + 1);
                                            },
                                          ),
                                      ],
                                    ),
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
      ),
    );
  }
}
