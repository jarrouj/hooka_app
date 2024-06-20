import 'package:flutter/material.dart';

class AddressTab extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, String>) onAdd;
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.home, color: Colors.yellow, size: 40),
                                SizedBox(width: 10),
                                Text('Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Title: ${item['title']}'),
                            Text('City: ${item['city']}'),
                            Text('Street: ${item['street']}'),
                            Text('Building: ${item['building']}'),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                widget.onRemove(index);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              child: Text('Remove item', style: TextStyle(color: Colors.white)),
                            ),
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
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddressPage(),
                ),
              );
              if (result != null) {
                widget.onAdd(result);
              }
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.yellow,
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newAddress = {
                      'title': _titleController.text,
                      'city': _cityController.text,
                      'street': _streetController.text,
                      'building': _buildingController.text,
                    };
                    Navigator.pop(context, newAddress);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
