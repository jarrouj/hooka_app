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
      body: FutureBuilder(
        future: Hive.openBox<Product>('cartBox2'),
        builder: (context, AsyncSnapshot<Box<Product>> snapshot) {
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
                return ListView.builder(
                  itemCount: cartBox.length,
                  itemBuilder: (context, index) {
                    final product = cartBox.getAt(index);
                    return ListTile(
                      leading: Image.asset(product!.image),
                      title: Text(product.name),
                      subtitle: Text('USD ${product.price.toStringAsFixed(2)}'),
                      trailing: Text('Qty: ${product.quantity}'),
                    );
                  },
                );
              }
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.yellow.shade600,
        child: Center(
          child: Text(
            'Proceed to Payment',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
