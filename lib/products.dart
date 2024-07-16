import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
        // Product(
        //   name: "Margerita Pizza",
        //   image: "assets/images/pizza.jpg",
        //   price: 5,
        //   quantity: 0,
        // ),
        // Product(
        //   name: "Margerita Pizza 2",
        //   image: "assets/images/pizza.jpg",
        //   price: 20,
        //   quantity: 0,
        // ),
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
   

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(productIds: [],),
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
            updateProducts: _updateProducts,
          ),
          if (isLoading) LoadingAllpages(),
        ],
      ),
    );
  }
}

class ProductsContent extends StatefulWidget {
  final Function(List<Product>) updateProducts;

  const ProductsContent({
    Key? key,
    required this.updateProducts,
  }) : super(key: key);

  @override
  _ProductsContentState createState() => _ProductsContentState();
}

class _ProductsContentState extends State<ProductsContent> {
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://api.hookatimes.com/api/Products/GetAllCategories'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['data'] as List;
      setState(() {
        categories = data.map((item) => Category.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: isLoading
            ? const Center(child: LoadingAllpages())
            : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsDetails(categoryId: category.id),
                        ),
                      );
                      if (result != null) {
                        widget.updateProducts(result);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 32, 
                          height: MediaQuery.of(context).size.height * 0.17,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Image.network(
                              category.image,
                              width: 200,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), 
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}


class Category {
  final int id;
  final String image;
  final String title;
  final String description;

  Category({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['decription'] ?? '',
    );
  }
}

class Product {
  final int id;
  final String? name;
  final String category;
  final int categoryId;
  final String title;
  final String description;
  final String image;
  final double customerInitialPrice;
  bool? isInWishlist;
  bool? isInCart;
  int quantityInCart;
  int? orderId;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.image,
    required this.customerInitialPrice,
    this.isInWishlist,
    this.isInCart,
    this.quantityInCart = 0,
    this.orderId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      categoryId: json['categoryId'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      customerInitialPrice: json['customerInitialPrice'],
      isInWishlist: json['isInWishlist'],
      isInCart: json['isInCart'],
      quantityInCart: json['quantityInCart'] ?? 0,
      orderId: json['orderId'],
    );
  }
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final typeId = 0;

  @override
  Product read(BinaryReader reader) {
    try {
      return Product(
        id: reader.readInt(),
        name: reader.readString(),
        category: reader.readString(),
        categoryId: reader.readInt(),
        title: reader.readString(),
        description: reader.readString(),
        image: reader.readString(),
        customerInitialPrice: reader.readDouble(),
        isInWishlist: reader.readBool(),
        isInCart: reader.readBool(),
        quantityInCart: reader.readInt(),
        orderId: reader.readInt(),
      );
    } catch (e) {
      // Handle the case where the data does not match the expected format
      return Product(
        id: 0,
        name: '',
        category: '',
        categoryId: 0,
        title: '',
        description: '',
        image: '',
        customerInitialPrice: 0.0,
        isInWishlist: false,
        isInCart: false,
        quantityInCart: 0,
        orderId: 0,
      );
    }
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name ?? '');
    writer.writeString(obj.category);
    writer.writeInt(obj.categoryId);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.image);
    writer.writeDouble(obj.customerInitialPrice);
    writer.writeBool(obj.isInWishlist ?? false);
    writer.writeBool(obj.isInCart ?? false);
    writer.writeInt(obj.quantityInCart);
    writer.writeInt(obj.orderId ?? 0);
  }
}

class ProductsDetails extends StatelessWidget {
  final int categoryId;

  const ProductsDetails({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(categoryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: const Center(child: LoadingAllpages()),
          );
        } else if (snapshot.hasError) {
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
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: const Center(
              child: Text('No products found.'),
            ),
          );
        } else {
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
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Details(products: snapshot.data!),
          );
        }
      },
    );
  }

  Future<List<Product>> fetchProducts(int categoryId) async {
    final response = await http.get(Uri.parse('https://api.hookatimes.com/api/Products/GetCategoryProducts/$categoryId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      List<Product> products = (data['data'] as List).map((item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
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
    _counters = List.generate(widget.products.length, (index) => widget.products[index].quantityInCart ?? 0);
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
        widget.products[index].quantityInCart = _counters[index];
      }
    });
  }

  void _updateQuantity(int index, int quantity) {
    setState(() {
      _counters[index] = quantity;
      widget.products[index].quantityInCart = quantity;
    });
  }

  Future<void> _addToCart(int productId, int quantity) async {
    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    final response = await http.post(
      Uri.parse('https://api.hookatimes.com/api/Cart/AddToCart/$productId/$quantity'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      print('Product added to cart');
    } else {
      print('Failed to add product to cart');
    }
  }

  void _goToCart() async {
    for (int i = 0; i < widget.products.length; i++) {
      if (_counters[i] > 0) {
        await _addToCart(widget.products[i].id, _counters[i]);
      }
    }

    List<int> productIds = [];
    for (int i = 0; i < widget.products.length; i++) {
      if (_counters[i] > 0) {
        productIds.add(widget.products[i].id);
      }
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(productIds: productIds)),
    );

    if (result != null) {
      setState(() {
        for (int i = 0; i < widget.products.length; i++) {
          _counters[i] = widget.products[i].quantityInCart ?? 0;
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
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
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
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.network(
                                  product.image,
                                  width: 100,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text('USD ${product.customerInitialPrice?.toStringAsFixed(2) ?? '0.00'}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(product.title ?? 'Unknown', textAlign: TextAlign.center, style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
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