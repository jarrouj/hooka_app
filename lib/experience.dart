import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExperienceTab extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, String>) onAdd;
  final Function(int) onRemove;

  const ExperienceTab({
    required this.items,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  @override
  State<ExperienceTab> createState() => _ExperienceTabState();
}

class _ExperienceTabState extends State<ExperienceTab> {
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
                                Icon(Icons.work, color: Colors.yellow, size: 40),
                                SizedBox(width: 10),
                                Text('Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Title: ${item['title']}'),
                            Text('Position: ${item['position']}'),
                            Text('From: ${item['from']}'),
                            Text('To: ${item['to']}'),
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
                  builder: (context) => AddExperiencePage(),
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

class AddExperiencePage extends StatefulWidget {
  @override
  _AddExperiencePageState createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2100);

    DateTime pickedDate = initialDate;
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 250,
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: firstDate,
                    maximumDate: lastDate,
                    onDateTimeChanged: (DateTime date) {
                      pickedDate = date;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate != initialDate) {
      setState(() {
        controller.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Experience'),
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
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: 'Position',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter position';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fromDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _fromDateController),
                decoration: InputDecoration(
                  labelText: 'From Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter from date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _toDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _toDateController),
                decoration: InputDecoration(
                  labelText: 'To Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter to date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newExperience = {
                      'title': _titleController.text,
                      'position': _positionController.text,
                      'from': _fromDateController.text,
                      'to': _toDateController.text,
                    };
                    Navigator.pop(context, newExperience);
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
