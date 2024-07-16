import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/checkout.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  final List<int> productIds;

  const CartPage({super.key, required this.productIds});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<CartSummary> _cartSummaryFuture;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _cartSummaryFuture = _fetchCartSummary();
  }

  Future<CartSummary> _fetchCartSummary() async {
    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Cart/GetCartSummary'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['data'];
      final cartSummary = CartSummary.fromJson(data);
      setState(() {
        totalPrice = cartSummary.totalPrice;
      });
      return cartSummary;
    } else {
      throw Exception('Failed to load cart summary');
    }
  }

  Future<void> _updateCartItemQuantity(int itemId, int newQuantity) async {
    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    var uri =
        Uri.parse('https://api.hookatimes.com/api/Cart/UpdateCartItemQuantity');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['itemId'] = itemId.toString();
    request.fields['quantity'] = newQuantity.toString();

    print('Request Fields: ${request.fields}');
    print('Request Headers: ${request.headers}');

    var response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Update successful');
    } else {
      var responseData = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseData);
      print('Error: ${decodedResponse['errorMessage']}');
      throw Exception(
          'Failed to update cart item quantity: ${decodedResponse['errorMessage']}');
    }
  }

  Future<void> _removeCartItem(int itemId) async {
    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    var uri =
        Uri.parse('https://api.hookatimes.com/api/Cart/RemoveItemFromCart');
    var request = http.MultipartRequest('DELETE', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['productId'] = itemId.toString();

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      print('Item removed from cart');
      setState(() {
        _cartSummaryFuture =
            _fetchCartSummary(); 
      });
    } else {
      try {
        var responseData = json.decode(responseBody);
        print('Error: ${responseData['errorMessage']}');
        throw Exception(
            'Failed to remove item from cart: ${responseData['errorMessage']}');
      } catch (e) {
        print('Error decoding response: $e');
        throw Exception(
            'Failed to remove item from cart. Unexpected response format: $responseBody');
      }
    }
  }

  void _changeQuantity(CartItem item, int change) async {
    try {
      final newQuantity = item.quantity + change;
      if (newQuantity < 1) {
        await _removeCartItem(item.itemId);
      } else {
        await _updateCartItemQuantity(item.itemId, newQuantity);
      }
      setState(() {
        if (newQuantity < 1) {
          _cartSummaryFuture =
              _fetchCartSummary();
        } else {
          item.quantity = newQuantity;
          totalPrice += change * item.productPrice;
        }
      });
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            'Hooka Basket',
            style: GoogleFonts.comfortaa(),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<CartSummary>(
          future: _cartSummaryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingAllpages());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final cartSummary =
                snapshot.data ?? CartSummary(totalPrice: 0, items: []);

            return Column(
              children: [
                Expanded(
                  child: cartSummary.items.isEmpty
                      ? const Center(
                          child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Your Cart is empty'),
                        ))
                      : ListView.builder(
                          itemCount: cartSummary.items.length,
                          itemBuilder: (context, index) {
                            final item = cartSummary.items[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: Container(
                                width: double.infinity,
                                height: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Image.network(item.productImage,
                                      height: 50),
                                  title: Text(
                                    item.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      '\$${item.productPrice.toStringAsFixed(2)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.yellow),
                                          ),
                                          child: IconButton(
                                            icon: item.quantity == 1
                                                ? const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.black)
                                                : const Icon(Icons.remove,
                                                    color: Colors.black),
                                            onPressed: () async {
                                              _changeQuantity(item, -1);
                                            },
                                            iconSize: 15,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.yellow,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.black,
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              _changeQuantity(item, 1);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Column(
                  children: [
                    const Divider(thickness: 2, color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Total:      ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        if (cartSummary.items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Your Cart is Empty')),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.yellow.shade600,
                        child: const Center(
                          child: Text(
                            'Proceed to checkout',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CartSummary {
  final double totalPrice;
  final List<CartItem> items;

  CartSummary({required this.totalPrice, required this.items});

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> items = itemsList.map((i) => CartItem.fromJson(i)).toList();

    return CartSummary(
      totalPrice: json['totalPrice'].toDouble(),
      items: items,
    );
  }
}

class CartItem {
  final int itemId;
  int quantity; // Make quantity mutable
  final String productName;
  final String productImage;
  final double productPrice;

  CartItem({
    required this.itemId,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.productPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['itemId'],
      quantity: json['quantity'],
      productName: json['productName'],
      productImage: json['productImage'],
      productPrice: json['productPrice'].toDouble(),
    );
  }
}
