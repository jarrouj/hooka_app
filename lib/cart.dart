import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/checkout.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/products.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<Product> cartBox;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<Product>('cartBox2');
    _initializeCartItems();
  }

  void _initializeCartItems() {
    for (var item in widget.cartItems) {
      cartBox.put(item.name, item);
    }
  }

  double get totalAmount {
    return widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _updateCartItemQuantity(Product product, int quantity) {
    setState(() {
      product.quantity = quantity;
      if (quantity == 0) {
        _removeCartItem(product);
      } else {
        cartBox.put(product.name, product); 
      }
    });
  }

  void _removeCartItem(Product product) {
    setState(() {
      product.quantity = 0;
      widget.cartItems.remove(product);
      cartBox.delete(product.name); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.cartItems);
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
              Navigator.pop(context, widget.cartItems);
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: screenHeight - 280,
              child: widget.cartItems.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(child: Text('Your Cart is empty' , style: TextStyle(
                         
                          fontSize: 16,
                        ),)),
                      ],
                    )
                  : ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Container(
                            width: double.infinity,
                            height: 105,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                              leading: Image.asset(item.image, height: 50),
                              title: Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('\$ ${item.price.toStringAsFixed(0)} '),
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
                                              _updateCartItemQuantity(item, item.quantity - 1);
                                            } else {
                                              _removeCartItem(item);
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
                                            _updateCartItemQuantity(item, item.quantity + 1);
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
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total:             \$${totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10,)
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(),
                      ),
                    );
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}