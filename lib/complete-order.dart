import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooka_app/main.dart';
import 'package:hooka_app/order-page-drawer.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:hooka_app/address.dart';
import 'package:hooka_app/products.dart';

class CompleteOrder extends StatefulWidget {
  const CompleteOrder({super.key});

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  List<Map<String, dynamic>> addresses = [];
  Map<String, dynamic>? selectedAddress;
  int selectedIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    var box = await Hive.openBox('userBox');
    setState(() {
      addresses = [];
      for (int i = 0; i < box.length ~/ 4; i++) {
        final address = {
          'title': box.get('addressTi$i'),
          'city': box.get('addressCi$i'),
          'street': box.get('addressSt$i'),
          'building': box.get('addressBu$i'),
        };
        if (address['title'] != null && address['title']!.isNotEmpty) {
          addresses.add(address);
        }
      }

      if (addresses.isNotEmpty && selectedAddress == null) {
        selectedAddress = addresses.first;
        selectedIndex = 0;
      }
    });
  }

  void _addAddress(Map<String, dynamic> newAddress) async {
    var box = await Hive.openBox('userBox');
    int index = addresses.length;
    await box.put('addressTi$index', newAddress['title']);
    await box.put('addressCi$index', newAddress['city']);
    await box.put('addressSt$index', newAddress['street']);
    await box.put('addressBu$index', newAddress['building']);
    setState(() {
      addresses.add(newAddress);
      if (addresses.length == 1) {
        selectedAddress = addresses.first;
      }
    });
  }

  void _selectAddress(int index) {
    setState(() {
      selectedIndex = index;
      selectedAddress = addresses[index];
    });
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) {
        return Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              _selectAddress(index);
            },
            children: addresses.map((address) {
              return Center(child: Text(address['title']!));
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _confirmOrder() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));

    // Check if the cart box is already open
    var cartBox = Hive.isBoxOpen('cartBox2')
        ? Hive.box<Product>('cartBox2')
        : await Hive.openBox<Product>('cartBox2');

    // Calculate total amount from cart
    double totalAmount = 0;
    List<Map<String, dynamic>> products = [];
    for (var i = 0; i < cartBox.length; i++) {
      var product = cartBox.getAt(i) as Product;
      totalAmount += product.price * product.quantity;
      products.add({
        'name': product.name,
        'price': product.price,
        'quantity': product.quantity,
        'image': product.image,
      });
    }

    // Save total amount and order details to a separate box
    var orderBox = await Hive.openBox('orderBox3');
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    await orderBox.put(orderId, {
      'totalAmount': totalAmount,
      'date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
      'status': 'Pending',
      'address': selectedAddress,
      'products': products,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPageLogged(),
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Delivery Address',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('Your Addresses:'),
                ),
                GestureDetector(
                  onTap: _showPicker,
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      selectedAddress != null
                          ? '${selectedAddress!['title']}'
                          : '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAddressPage(),
                        ),
                      );
                      if (result != null) {
                        _addAddress(result);
                      }
                    },
                    child: const Text(
                      'Add New',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Spacer(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              child: GestureDetector(
                onTap: _confirmOrder,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade600,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      isLoading ? 'Loading...' : 'Confirm Order',
                      style: GoogleFonts.comfortaa(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPageLogged extends StatelessWidget {
  Future<void> _clearAllData(BuildContext context) async {
    var cartBox = await Hive.openBox<Product>('cartBox2');
    await cartBox.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('orderBox3'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var orderBox = Hive.box('orderBox3');
          var orders = orderBox.toMap().entries.toList();
          var todayDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

          var currentOrders = orders.where((order) {
            return order.value['date'] == todayDate;
          }).toList();

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Order Summary'),
                leading: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => _clearAllData(context),
                ),
                bottom: TabBar(
                      unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab ,
          indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: "Current"),
                    Tab(text: "All"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  OrderListView(orders: currentOrders),
                  OrderListView(orders: orders),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

