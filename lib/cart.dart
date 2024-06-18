import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/products.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get totalAmount {
    return widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
     final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight - 270,
            child: widget.cartItems.isEmpty
                ? const Center(child: Text('No items in your cart.'))
                : ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Image.asset(item.image, height: 50),
                            title: Text(
                              item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                '\$ ${item.price.toStringAsFixed(2)} '),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.yellow),
                                    ),
                                    child: IconButton(
                                      icon: item.quantity == 1
                                          ? const Icon(Icons.delete_outline, color: Colors.black)
                                          : const Icon(Icons.remove, color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 1) {
                                            item.quantity--;
                                          } else {
                                            widget.cartItems.remove(item);
                                          }
                                        });
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
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.yellow,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          item.quantity++;
                                        });
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
            const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total:             \$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                height: 60,
               color: Colors.yellow.shade600,
              
                child: const Center(
                  child:  Text(
                      'Proceed to checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ),
            ]
              )
              ],
            ),
        
       
      );
    
  }
}
