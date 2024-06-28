import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooka_app/main.dart';
import 'package:hooka_app/order-page-drawer.dart';
import 'package:intl/intl.dart';
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
  bool showAddAddressOverlay = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    var box = await Hive.openBox('userBox');
    setState(() {
      addresses = [];
      for (int i = 0; i < box.length ~/ 5; i++) {
        final address = {
          'title': box.get('addressTitle$i'),
          'city': box.get('addressCity$i'),
          'street': box.get('addressStreet$i'),
          'building': box.get('addressBuilding$i'),
          'apartment': box.get('addressApartment$i'),
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
    await box.put('addressTitle$index', newAddress['title']);
    await box.put('addressCity$index', newAddress['city']);
    await box.put('addressStreet$index', newAddress['street']);
    await box.put('addressBuilding$index', newAddress['building']);
    await box.put('addressApartment$index', newAddress['apartment']);

    setState(() {
      addresses.add(newAddress);
      if (addresses.length == 1) {
        selectedAddress = addresses.first;
      }
      showAddAddressOverlay = false;
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
      shape: const RoundedRectangleBorder(
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

  void _toggleAddAddressOverlay() {
    setState(() {
      showAddAddressOverlay = !showAddAddressOverlay;
    });
  }

  Future<void> _confirmOrder() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));

    var cartBox = Hive.isBoxOpen('cartBox2')
        ? Hive.box<Product>('cartBox2')
        : await Hive.openBox<Product>('cartBox2');

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
        child: Stack(
          children: [
            if (!showAddAddressOverlay)
              Column(
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
                          onTap: _toggleAddAddressOverlay,
                          child: Text(
                            'Add New',
                            style: GoogleFonts.comfortaa(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
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
            if (showAddAddressOverlay)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleAddAddressOverlay,
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AddNewAddressForm(onAddAddress: _addAddress),
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

class AddNewAddressForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddAddress;

  const AddNewAddressForm({required this.onAddAddress, super.key});

  @override
  _AddNewAddressFormState createState() => _AddNewAddressFormState();
}

class _AddNewAddressFormState extends State<AddNewAddressForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _appartmentController = TextEditingController();
  String? location;

  List<String> cities = ['Zahle', 'Beirut', 'Byblos'];

  Future<void> _selectFromList(
    BuildContext context,
    TextEditingController controller,
    List<String> items,
    String selectedItem,
  ) async {
    await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context, selectedItem);
          },
          child: Container(
            height: 250,
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        selectedItem = items[index];
                      });
                    },
                    children: items.map((item) {
                      return Center(child: Text(item));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((pickedItem) {
      if (pickedItem != null) {
        setState(() {
          controller.text = pickedItem;
        });
      }
    });
  }

  void _getLocation() {
    setState(() {
      location = 'Location: ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
            ],
            controller: _titleController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                _selectFromList(context, _cityController, cities, cities[0]),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select city';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
            ],
            controller: _streetController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Street',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter street';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
            ],
            controller: _buildingController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Building',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter building';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
            ],
            controller: _appartmentController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Appartment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter appartment';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          if (location != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  location!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.check, color: Colors.black),
              ],
            ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: _getLocation,
            child: Container(
              width: 150,
              padding: EdgeInsets.all(13.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Center(
                child: Text(
                  'Get Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                final newAddress = {
                  'title': _titleController.text,
                  'city': _cityController.text,
                  'street': _streetController.text,
                  'building': _buildingController.text,
                  'appartment': _appartmentController.text,
                };
                widget.onAddAddress(newAddress);
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(13.0),
              decoration: BoxDecoration(
                color: Colors.yellow.shade600,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderPageLogged extends StatelessWidget {
  Future<void> _clearAllData(BuildContext context) async {
    var cartBox = await Hive.openBox<Product>('cartBox2');
    var productsBox = await Hive.openBox<Product>('productsBox');

    // Clear cartBox2
    await cartBox.clear();

    // Reset the quantity in productsBox
    for (var key in productsBox.keys) {
      var product = productsBox.get(key) as Product;
      product.quantity = 0;
      await productsBox.put(key, product);
    }

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
                  padding: EdgeInsets.only(top: 15),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      child: Text(
                        'Current',
                        style:
                            GoogleFonts.comfortaa(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'All',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
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
