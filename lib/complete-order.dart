import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooka_app/address.dart';

class CompleteOrder extends StatefulWidget {
  const CompleteOrder({super.key});

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  List<Map<String, dynamic>> addresses = [];
  Map<String, dynamic>? selectedAddress;
  int selectedIndex = 0;

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
        };
        if (address['title'] != null && address['title']!.isNotEmpty) {
          addresses.add(address);
        }
      }

      if (addresses.length == 1) {
        selectedAddress = addresses.first;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Your Addresses'),
                ),
              ],
            ),
            GestureDetector(
              onTap: _showPicker,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedAddress != null
                      ? 'Selected Address: ${selectedAddress!['city']}'
                      : 'Select an Address',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
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
                child: Text('Add Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}