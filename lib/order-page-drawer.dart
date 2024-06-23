import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';


class OrderPageDrawer extends StatelessWidget {
  const OrderPageDrawer({super.key});

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
                backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'My Order',
            style: GoogleFonts.comfortaa(fontSize: 20),
          ),
        ),
        actions: const [
          SizedBox(
            width: 55,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
        ),
                bottom: TabBar(
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

class OrderListView extends StatelessWidget {
  final List<MapEntry<dynamic, dynamic>> orders;

  const OrderListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index].value;
        return Card(
          child: ListTile(
            title: Text('Order ID: ${orders[index].key}'),
            subtitle: Text(
              'Total: \$${order['totalAmount'].toStringAsFixed(2)}\nStatus: ${order['status']}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(orderId: orders[index].key),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('orderBox3'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var orderBox = Hive.box('orderBox3');
          var order = orderBox.get(orderId);

          if (order == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Order Details'),
              ),
              body: Center(
                child: Text('Order not found'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Order Details'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: $orderId', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Date: ${order['date']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Status: ${order['status']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Total Amount: \$${order['totalAmount'].toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Address:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Title: ${order['address']['title']}', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 5),
                  Text('City: ${order['address']['city']}', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 5),
                  Text('Street: ${order['address']['street']}', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 5),
                  Text('Building: ${order['address']['building']}', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 20),
                  Text('Products:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: order['products'].length,
                      itemBuilder: (context, index) {
                        var product = order['products'][index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(product['image'], width: 50, height: 50),
                            title: Text(product['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price: \$${product['price'].toStringAsFixed(2)}'),
                                Text('Quantity: ${product['quantity']}'),
                                Text('Total: \$${(product['price'] * product['quantity']).toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
