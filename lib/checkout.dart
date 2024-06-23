import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/products.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Checkout',
            style: GoogleFonts.comfortaa(fontSize: 20),
          ),
        ),
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
      body: CheckoutBody(),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          // Handle proceed to payment
        },
        child: Container(
          height: 60,
          color: Colors.yellow.shade600,
          child: const Center(
            child: Text(
              'Proceed to Payment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
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
    return cartBox.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
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
              return Center(
                child: Text('No items in the cart.'),
              );
            } else {
              double totalAmount = getTotalAmount(cartBox);
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Your Basket',
                    style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.bold),
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
                            style: GoogleFonts.comfortaa(fontSize: 16),
                          ),
                          Text(
                            '${(product.price * product.quantity).toStringAsFixed(2)} \$',
                            style: GoogleFonts.comfortaa(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  Divider(thickness: 2, height: 40),
                  Text(
                    'Order Summary',
                    style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order amount', style: GoogleFonts.comfortaa(fontSize: 16)),
                      Text('${totalAmount.toStringAsFixed(2)} \$', style: GoogleFonts.comfortaa(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery fees', style: GoogleFonts.comfortaa(fontSize: 16)),
                      Text('0.00 \$', style: GoogleFonts.comfortaa(fontSize: 16)),
                    ],
                  ),
                  Divider(thickness: 2, height: 40),
                  Text(
                    'Payment Method',
                    style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                      Text('Cash On Delivery', style: GoogleFonts.comfortaa(fontSize: 16)),
                    ],
                  ),
                  Divider(thickness: 2, height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total amount',
                        style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${totalAmount.toStringAsFixed(2)} \$',
                        style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}