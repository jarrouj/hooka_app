import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/complete-order.dart';
import 'package:hooka_app/products.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Center(
          child: Text(
            'Checkout',
            style: GoogleFonts.comfortaa(fontSize: 20),
          ),
        ),
        actions: [
          SizedBox(width: 45,),
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
  late Future<Box<Product>> _cartBoxFuture;

  @override
  void initState() {
    super.initState();
    _cartBoxFuture = Hive.openBox<Product>('cartBox2');
  }

  double getTotalAmount(Box<Product> cartBox) {
    if (cartBox.isEmpty) return 0;
    return cartBox.values
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<Product>>(
      future: _cartBoxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var cartBox = snapshot.data;
            if (cartBox!.isEmpty) {
              return const Center(
                child: Text('No items in the cart.'),
              );
            } else {
              double totalAmount = getTotalAmount(cartBox);
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Your Basket',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...cartBox.values.map((product) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.name} x ${product.quantity}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${(product.price * product.quantity).toStringAsFixed(2)} \$',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  // Divider(thickness: 2, height: 40),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery fees', style: TextStyle(fontSize: 16)),
                      Text('0.00 \$', style: TextStyle(fontSize: 16)),
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
                    height: 40,
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
                      Text('Cash On Delivery', style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700)),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${totalAmount.toStringAsFixed(2)} \$',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        onTap: (){
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
            }
          }
        } else {
          return const Center(
            child: LoadingAllpages(),
          );
        }
      },
    );
  }
}
