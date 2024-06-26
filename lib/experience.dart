import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ExperienceTab extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onAdd;
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
  late List<Map<String, dynamic>> experiences;

  @override
  void initState() {
    super.initState();
    experiences = List.from(widget.items); // Ensure a copy is made
  }

  void _addExperience(Map<String, dynamic> newExperience) async {
    setState(() {
      experiences.add(newExperience);
    });
    var box = await Hive.openBox('userBox');
    int index = experiences.length - 1;
    await box.put('experienceTitle$index', newExperience['title']);
    await box.put('experiencePosition$index', newExperience['position']);
    await box.put('experienceFrom$index', newExperience['from']);
    await box.put('experienceTo$index', newExperience['to']);
    widget.onAdd(newExperience);
  }

  void _removeExperience(int index) async {
    if (index >= 0 && index < experiences.length) {
      setState(() {
        experiences.removeAt(index);
      });
      var box = await Hive.openBox('userBox');
      await box.delete('experienceTitle$index');
      await box.delete('experiencePosition$index');
      await box.delete('experienceFrom$index');
      await box.delete('experienceTo$index');
      widget.onRemove(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: experiences.length,
                  itemBuilder: (context, index) {
                    final item = experiences[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: screenWidth * 0.2,
                                width: double.infinity,
                                color: Colors.yellow.shade600,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.work,
                                        color: Colors.black, size: 80),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                  width: double.infinity,
                                  height: screenWidth * 0.07,
                                  color: Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(width: screenWidth * 0.2,),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Place:',
                                              style: TextStyle(fontSize: screenWidth * 0.05),
                                            ),
                                          ),

                                           Expanded(
                                            flex: 1,
                                             child: Text(
                                              '${item['title']}',
                                              style: TextStyle(fontSize: screenWidth * 0.05),
                                                                                       ),
                                           ),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 16),
                              Container(
                                  width: double.infinity,
                                  height: screenWidth * 0.07,
                                  color: Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(width: screenWidth * 0.2,),
                                      
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Position:',
                                              style: TextStyle(fontSize: screenWidth * 0.05),
                                            ),
                                          ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                              '${item['position']}',
                                              style: TextStyle(fontSize: screenWidth * 0.05),
                                                                                        ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.42,
                                      height: screenWidth * 0.07,
                                      color: Colors.grey.shade300,
                                      child: Center(
                                        child: Text(
                                          'From : ${item['from']}',
                                          style: TextStyle(fontSize: screenWidth * 0.044),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.042,
                                    ),
                                    Container(
                                      width: screenWidth * 0.38,
                                      height: screenWidth * 0.07,
                                      color: Colors.grey.shade300,
                                      child: Center(
                                        child: Text(
                                          'To : ${item['to']}',
                                          style: TextStyle(fontSize: screenWidth * 0.044),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.035),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: screenWidth * 0.09,
                                    width: screenWidth * 0.38,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _removeExperience(index);
                                      },
                                      child:const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Remove item',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
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
                  builder: (context) => AddExperiencePage(),
                ),
              );
              if (result != null) {
                _addExperience(result);
              }
            },
            child: Container(
              height: screenWidth * 0.14,
              width: screenWidth * 0.14,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.add,
                color: Colors.yellow,
                size: screenWidth * 0.07,
              ),
            ),
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

  List<String> positions = ['Professor', 'Developer'];
  List<String> cities = ['Zahle', 'Beirut', 'Byblos'];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2100);

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = initialDate;
        return Container(
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
                    selectedDate = date;
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, selectedDate);
                },
                child: Text('Done'),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

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
        title: Text('Add Experience'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectFromList(context, _positionController, positions, positions[0]),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _positionController,
                    decoration: InputDecoration(
                      labelText: 'Position',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select position';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectFromList(context, _titleController, cities, cities[0]),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _titleController,
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
              Row(
                children: [
                  Text(
                    'From',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  )
                ],
              ),
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
              Row(
                children: [
                  Text(
                    'To',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  )
                ],
              ),
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
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
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
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.yellow.shade600,
                  ),
                  child: const Center(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
