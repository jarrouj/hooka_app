import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/products.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title:  Text('Hooka Basket' , style: GoogleFonts.comfortaa(),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('No items in your cart.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10 , right: 10 , top: 10),
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
                    offset: Offset(0, 8),
                  ),
                ],
                    ),
                    child: ListTile(
                      leading: Image.asset(item.image,
                          height: 50), 
                      title: Text(item.name , style: const TextStyle(fontWeight: FontWeight.bold),), 
                      subtitle: Text(
                          'USD ${item.price.toStringAsFixed(2)} x ${item.quantity}'), // Display the product price and quantity
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Container(
                          //   width: 15,
                          //   height: 15,
                          //   color: Colors.yellow,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5)
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.yellow
                                )
                                
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.remove, color: Colors.black , size: 15, weight: 60,),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                    (context as Element)
                                        .markNeedsBuild(); 
                                  }
                                },
                              ),
                            ),
                          ),
                          Text('${item.quantity}' , style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),), 
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
                                icon: const Icon(Icons.add, color: Colors.black , size: 15, ),
                                onPressed: () {
                                  item.quantity++;
                                  (context as Element)
                                      .markNeedsBuild(); 
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
    );
  }
}
