import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    educations = List.from(widget.items);
  }

 Future<void> _removeEducation(int educationId) async {
  var box = await Hive.openBox('myBox');
  String? token = box.get('token');

  if (token == null) {
    throw Exception('Token is null');
  }

  String url = 'https://api.hookatimes.com/api/Accounts/DeleteEducation';

  try {
    print('Attempting to delete education with ID: $educationId');
    print('Current educations: $educations');

    Response response = await _dio.delete(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
      data: jsonEncode({
        'EducationId': educationId,  
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        final index = educations.indexWhere((item) => item['id'] == educationId);
        if (index != -1) {
          educations.removeAt(index);
          widget.onRemove(educationId);
        } else {
          throw Exception('Education ID not found in the list');
        }
      });
    } else {
      final errorMessage = response.data['errorMessage'];
      print('Failed to delete education: $errorMessage');
      throw Exception('Failed to delete education: $errorMessage');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError) {
      print('Connection error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete education: Connection error'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (e.response != null) {
      print('Error response: ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete education: ${e.response?.data}'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete education: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete education: $error'),
        backgroundColor: Colors.red,
      ),
    );
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
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${item['degree']}',
                                          style: TextStyle(fontSize: 20),
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
                                          'From : ${item['studiedFrom']}',
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
                                          'To : ${item['studiedTo']}',
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
                                        print(
                                            'Education ID to be deleted: ${item['id']}');
                                        _removeEducation(item['id']);
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
                  builder: (context) => AddEducationPage(onAdd: _addEducation),
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

  Future<void> _addEducation(Map<String, dynamic> newEducation) async {
  var box = await Hive.openBox('myBox');
  String? token = box.get('token');

  if (token == null) {
    throw Exception('Token is null');
  }

  String url = 'https://api.hookatimes.com/api/Accounts/AddEducation';
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers['Authorization'] = 'Bearer $token';
  request.fields['StudiedFrom'] = newEducation['studiedFrom'];
  request.fields['Degree'] = newEducation['degree'];
  request.fields['University'] = newEducation['university'];
  request.fields['StudiedTo'] = newEducation['studiedTo'];

  var response = await request.send();

  if (response.statusCode == 200) {
    setState(() {
      educations.add(newEducation);
    });
    widget.onAdd(newEducation);
  } else {
    throw Exception('Failed to add education');
  }
}
}

class AddEducationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddEducationPage({required this.onAdd});

  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

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
                      controller.text =
                          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
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
              TextFormField(
                controller: _universityController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'University',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter university';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _degreeController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Degree',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter degree';
                  }
                  return null;
                },
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
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
      DateTime fromDate = DateTime.parse(_fromDateController.text);
      DateTime toDate = DateTime.parse(_toDateController.text);

      if (toDate.isBefore(fromDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The To date must be greater than From date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newEducation = {
        'university': _universityController.text,
        'degree': _degreeController.text,
        'studiedFrom': _fromDateController.text,
        'studiedTo': _toDateController.text,
      };

      widget.onAdd(newEducation);
      Navigator.pop(context);
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
