import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/main.dart';
import 'package:hooka_app/order-page-drawer.dart';
import 'package:hooka_app/order_request.dart';
import 'package:hooka_app/products.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Define a global variable for the selected address
Map<String, dynamic>? selectedGlobalAddress;

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
    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Accounts/GetAdderesses'),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['data'];
      setState(() {
        addresses = List<Map<String, dynamic>>.from(data);

        if (addresses.isNotEmpty && selectedAddress == null) {
          selectedAddress = addresses.first;
          selectedIndex = 0;
          _setSelectedAddressData();
        }
      });
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  void _setSelectedAddressData() {
    setState(() {
      selectedGlobalAddress = {
        'City': selectedAddress?['city'],
        'Title': selectedAddress?['title'],
        'Appartment': selectedAddress?['appartment'],
        'Street': selectedAddress?['street'],
        'Building': selectedAddress?['building'],
        'Longitude': selectedAddress?['longitude'],
        'Latitude': selectedAddress?['latitude'],
        'Id': selectedAddress?['id'],
      };
      if (selectedGlobalAddress != null) {
        print("Selected Address City: ${selectedGlobalAddress!['City']}");
      }
    });
  }

  Future<void> _addAddress(Map<String, dynamic> newAddress) async {
    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    var uri = Uri.parse('https://api.hookatimes.com/api/Accounts/AddAddress');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    newAddress.forEach((key, value) {
      request.fields[key] = value ?? '';
    });

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await _loadAddresses();
      setState(() {
        selectedAddress = addresses.last;
        selectedIndex = addresses.length - 1;
        showAddAddressOverlay = false;
        _setSelectedAddressData();
      });
    } else {
      try {
        var responseData = json.decode(responseBody);
        print('Error: ${responseData['errorMessage']}');
        throw Exception('Failed to add address: ${responseData['errorMessage']}');
      } catch (e) {
        print('Error decoding response: $e');
        throw Exception('Failed to add address. Unexpected response format: $responseBody');
      }
    }
  }

  Future<void> _confirmOrder() async {
      final Dio dio = Dio();
  var box = await Hive.openBox('myBox');
  String? token = box.get('token');

  if (token == null) {
    throw Exception('Token is null');
  }

  OrderRequest orderRequest = OrderRequest(city: 'sa', street: 's', title: 'p');

  try {
    var response = await dio.post(
      'https://api.hookatimes.com/api/Orders/PlaceOrder',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
          // 'accept': '*/*',
        },
      ),
      data: FormData.fromMap(orderRequest.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Placed order: ${response.data}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPageLogged(),
        ),
      );
    } else {
      // Handle error
      print('Failed to place order: ${response.data}');
    }
  } catch (e) {
    print('Exception: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
  }

  void _selectAddress(int index) {
    setState(() {
      selectedIndex = index;
      selectedAddress = addresses[index];
      _setSelectedAddressData();
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
              return Center(
                child: Text(
                  address['title'] ?? '',
                  softWrap: true,
                ),
              );
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
                      if (addresses.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No Addresses yet..',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      else ...[
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
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
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
                  if (addresses.isNotEmpty)
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
            if (showAddAddressOverlay)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                      child: AddNewAddressForm(onAddAddress: (newAddress) {
                        _addAddress(newAddress);
                      }),
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
  final TextEditingController _apartmentController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newAddress = {
        'Appartment': _apartmentController.text,
        'Street': _streetController.text,
        'CityId': '',
        'City': _cityController.text,
        'Latitude': '',
        'Longitude': '',
        'IsDeleted': 'false',
        'Building': _buildingController.text,
        'Title': _titleController.text,
        'Id': '0', // Default value, will be ignored by server
      };
      widget.onAddAddress(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
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
          TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter city';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _streetController,
            decoration: InputDecoration(
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
            controller: _buildingController,
            decoration: InputDecoration(
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
            controller: _apartmentController,
            decoration: InputDecoration(
              labelText: 'Apartment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter apartment';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}

class OrderPageLogged extends StatefulWidget {
  @override
  _OrderPageLoggedState createState() => _OrderPageLoggedState();
}

class _OrderPageLoggedState extends State<OrderPageLogged> {
  List<Map<String, dynamic>> currentOrders = [];
  List<Map<String, dynamic>> allOrders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    final box = await Hive.openBox('myBox');
    final token = box.get('token');

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Orders/GetOrders'),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['data'];
      final allOrdersData = List<Map<String, dynamic>>.from(data['allOrders']);
      final today = DateFormat('d MMMM, yyyy').format(DateTime.now());

      final filteredCurrentOrders = allOrdersData.where((order) {
        return order['status'] == 'Pending' && order['date'] == today;
      }).toList();

      setState(() {
        currentOrders = filteredCurrentOrders;
        allOrders = allOrdersData;
      });
    } else {
      throw Exception('Failed to load orders');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _clearAllData(BuildContext context) async {
    var cartBox = await Hive.openBox<Product>('cartBox2');
    var productsBox = await Hive.openBox<Product>('productsBox');

    // Clear cartBox2
    await cartBox.clear();

    // Reset the quantity in productsBox
    for (var key in productsBox.keys) {
      var product = productsBox.get(key) as Product;
      product.quantityInCart = 0;
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
    return isLoading
        ? Scaffold(body: Center(child: LoadingAllpages()))
        : DefaultTabController(
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
                        style: GoogleFonts.comfortaa(fontWeight: FontWeight.w800),
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
                  OrderListView(orders: allOrders),
                ],
              ),
            ),
          );
  }
}

class OrderListView extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  OrderListView({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(top: 0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderDetailsPage(orderId: order['id'].toString()),
                ),
              );
            },
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: Center(
                          child: Text(
                            '${order['id']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${order['status']}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Total: \$${order['total'].toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      order['date'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  Future<Map<String, dynamic>> fetchOrderDetails() async {
    var box = await Hive.openBox('myBox');
    String? token = box.get('token');
    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Orders/GetOrder/$orderId'),
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchOrderDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Order Details'),
              ),
              body: const Center(
                child: Text('Error loading order details'),
              ),
            );
          }

          var order = snapshot.data?['data']['data'];

          if (order == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Order Details'),
              ),
              body: const Center(
                child: Text('Order not found'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Order Details'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Order',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.fastfood,
                                  size: 12,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Id: $orderId',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Status: ${order['status']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Total Price: ${order['total'].toStringAsFixed(2)} \$',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Date : ${order['date']}',
                                        style: const TextStyle(
                                          fontSize: 10,
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
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.place_outlined,
                                  size: 12,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Name: ${order['address']['title']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'City: ${order['address']['city']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Street: ${order['address']['street']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Building : ${order['address']['building']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Appartment : ${order['address']['appartment']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 0.5,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Items',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 17,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order['items'].length,
                      itemBuilder: (context, index) {
                        var product = order['items'][index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Image.network(product['productImage'],
                                  width: 50, height: 50),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['productName'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '(${product['productPrice'].toStringAsFixed(2)}\$/Per Item)',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                'Price: \$${(product['productPrice'] * product['quantity']).toStringAsFixed(2)}',
                                overflow: TextOverflow.visible,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: ${product['quantity']}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: LoadingAllpages()),
          );
        }
      },
    );
  }
}