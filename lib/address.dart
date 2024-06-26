import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddressTab extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onAdd;
  final Function(int) onRemove;

  const AddressTab({
    required this.items,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  @override
  _AddressTabState createState() => _AddressTabState();
}

class _AddressTabState extends State<AddressTab> {
  late List<Map<String, dynamic>> addresses;

  @override
  void initState() {
    super.initState();
    addresses = List.from(widget.items);
  }

  void _addAddress(Map<String, dynamic> newAddress) async {
    setState(() {
      addresses.add(newAddress);
    });
    var box = await Hive.openBox('userBox');
    int index = addresses.length - 1;
    await box.put('addressTi$index', newAddress['title']);
    await box.put('addressCi$index', newAddress['city']);
    await box.put('addressSt$index', newAddress['street']);
    await box.put('addressBu$index', newAddress['building']);
    await box.put('addressAp$index', newAddress['appartment']);
    widget.onAdd(newAddress);
  }

  void _removeAddress(int index) async {
    if (index >= 0 && index < addresses.length) {
      setState(() {
        addresses.removeAt(index);
      });
      var box = await Hive.openBox('userBox');
      await box.delete('addressTi$index');
      await box.delete('addressCi$index');
      await box.delete('addressSt$index');
      await box.delete('addressBu$index');
      await box.delete('addressAp$index');
      widget.onRemove(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final item = addresses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 60,
                                color: Colors.yellow.shade600,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.home,
                                        color: Colors.black, size: 40),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 25,
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text('Title :'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text('${item['title']}'),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 25,
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text('City :'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text('${item['city']}'),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 25,
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: [
                                     Expanded(
                                        flex: 1,
                                        child: Text('Street :'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text('${item['street']}'),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 25,
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: [
                                     Expanded(
                                        flex: 1,
                                        child: Text('Building :'),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text('${item['building']}'),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _removeAddress(index);
                                      },
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.white),
                                              SizedBox(width: 5),
                                              Text('Remove item',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 40,
          right: 30,
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
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.add,
                color: Colors.yellow,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _appartmentController = TextEditingController();

    List<String> cities = ['Zahle', 'Beirut', 'Byblos'];

    Future<void> _selectFromList(
      BuildContext context, TextEditingController controller, List<String> items, String selectedItem) async {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Address title *',
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
                onTap: () => _selectFromList(context, _cityController, cities, cities[0]),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
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
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street *',
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
                  labelText: 'Building *',
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
                controller: _appartmentController,
                decoration: InputDecoration(
                  labelText: 'Appartment *',
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
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final newExperince = {
                      'title': _titleController.text,
                      'city': _cityController.text,
                      'street': _streetController.text,
                      'building': _buildingController.text,
                      'appartment': _appartmentController.text,
                    };
                    Navigator.pop(context, newExperince);
                  }
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.yellow.shade600,
                  ),
                  child: const Center(
                    child: Center(
                        child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
