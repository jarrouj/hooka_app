import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EducationTab extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onAdd;
  final Function(int) onRemove;

  const EducationTab({
    required this.items,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  @override
  _EducationTabState createState() => _EducationTabState();
}

class _EducationTabState extends State<EducationTab> {
  late List<Map<String, dynamic>> educations;

  @override
  void initState() {
    super.initState();
    educations = List.from(widget.items);
  }

  void _addEducation(Map<String, dynamic> newEducation) async {
    setState(() {
      educations.add(newEducation);
    });
    var box = await Hive.openBox('userBox');
    int index = educations.length - 1;
    await box.put('university$index', newEducation['university']);
    await box.put('degree$index', newEducation['degree']);
    await box.put('educationFrom$index', newEducation['from']);
    await box.put('educationTo$index', newEducation['to']);
    widget.onAdd(newEducation);
  }

  void _removeEducation(int index) async {
    if (index >= 0 && index < educations.length) {
      setState(() {
        educations.removeAt(index);
      });
      var box = await Hive.openBox('userBox');
      await box.delete('university$index');
      await box.delete('degree$index');
      await box.delete('educationFrom$index');
      await box.delete('educationTo$index');
      widget.onRemove(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: educations.length,
                  itemBuilder: (context, index) {
                    final item = educations[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
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
                                    Icon(Icons.school,
                                        color: Colors.black, size: 80),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: screenWidth * 0.07,
                                color: Colors.grey.shade300,
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'University:',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.05),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${item['university']}',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.05),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: screenWidth * 0.07,
                                color: Colors.grey.shade300,
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.2,
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Degree:',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${item['degree']}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.042),
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
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.044),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: screenWidth * 0.09,
                                    width: screenWidth * 0.36,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _removeEducation(index);
                                      },
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Row(
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
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 30,
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
                  builder: (context) => AddEducationPage(),
                ),
              );
              if (result != null) {
                _addEducation(result);
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

class AddEducationPage extends StatefulWidget {
  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  List<String> universities = ['Lau', 'Aul', 'Antonine'];
  List<String> degrees = ['BA'];
  String _selectedUniversity = 'Lau';
  String _selectedDegree = 'BA';

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2100);

    DateTime selectedDate = initialDate;
    await showModalBottomSheet<DateTime>(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context, selectedDate);
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
                      selectedDate = date;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          controller.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  Future<void> _selectFromList(
      BuildContext context,
      TextEditingController controller,
      List<String> items,
      String selectedItem) async {
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
        title: Text('Add Education'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectFromList(context, _universityController,
                    universities, _selectedUniversity),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _universityController,
                    decoration: InputDecoration(
                      labelText: 'University',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select university';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectFromList(
                    context, _degreeController, degrees, _selectedDegree),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _degreeController,
                    decoration: InputDecoration(
                      labelText: 'Degree',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select degree';
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
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final newEducation = {
                      'university': _universityController.text,
                      'degree': _degreeController.text,
                      'from': _fromDateController.text,
                      'to': _toDateController.text,
                    };
                    Navigator.pop(context, newEducation);
                  }
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.yellow.shade600,
                  ),
                  child: Center(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
