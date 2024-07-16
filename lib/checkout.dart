import 'dart:convert';
import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/complete-order.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Checkout',
            style: GoogleFonts.comfortaa(fontSize: 20),
          ),
        ),
        actions: [
          SizedBox(
            width: 45,
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
      body: const CheckoutBody(),
    );
  }
}

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({super.key});

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  late Future<CartSummary> _cartSummaryFuture;

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
      return CartSummary.fromJson(data);
    } else {
      throw Exception('Failed to load cart summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CartSummary>(
      future: _cartSummaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingAllpages());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final cartSummary = snapshot.data ?? CartSummary(totalPrice: 0, items: [], deliveryFees: '0.00', orderAmount: '0.00');

        if (cartSummary.items.isEmpty) {
          return const Center(
            child: Text('No items in the cart.'),
          );
        }

        double totalAmount = cartSummary.totalPrice;
        double deliveryFee = double.parse(cartSummary.deliveryFees.replaceAll('\$', ''));
        double orderAmount = double.parse(cartSummary.orderAmount.replaceAll('\$', ''));

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Your Basket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            ...cartSummary.items.map((product) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.productName} x ${product.quantity}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${(product.productPrice * product.quantity).toStringAsFixed(2)} \$',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order amount', style: TextStyle(fontSize: 16)),
                Text('${totalAmount.toStringAsFixed(2)} \$',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery fees', style: TextStyle(fontSize: 16)),
                Text('${deliveryFee.toStringAsFixed(2)} \$', style: const TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Divider(
              thickness: 0.5,
              height: 40,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.black,
                  checkColor: Colors.yellow.shade600,
                  value: true,
                  onChanged: (value) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                Text('Cash On Delivery', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            CustomPaint(
              size: Size(200, 1),
              painter: DottedLinePainter(
                dashWidth: 4,
                dashGap: 7,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total amount',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${orderAmount.toStringAsFixed(2)} \$',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CompleteOrder()),
                    );
                  },
                  child: Container(
                    width: 220,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade600,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Complete Order',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}

class CartSummary {
  final double totalPrice;
  final List<CartItem> items;
  final String deliveryFees;
  final String orderAmount;

  CartSummary({
    required this.totalPrice,
    required this.items,
    required this.deliveryFees,
    required this.orderAmount,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> items = itemsList.map((i) => CartItem.fromJson(i)).toList();

    return CartSummary(
      totalPrice: json['totalPrice'].toDouble(),
      items: items,
      deliveryFees: json['deliveryFees'],
      orderAmount: json['orderAmount'],
    );
  }
}

class CartItem {
  final int itemId;
  int quantity;
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
