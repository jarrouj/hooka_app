import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalTab extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const PersonalTab({required this.data, super.key});

  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  String? _hairType;
  String? _eyeColor;
  String? _gender;
  String? _maritalStatus;

  @override
  void dispose() {
    _dateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final Map<String, String> dataMap = {for (var item in widget.data) item['label']: item['value']};
    _firstNameController.text = dataMap['First Name'] ?? '';
    _lastNameController.text = dataMap['Last Name'] ?? '';
    _emailController.text = dataMap['Email'] ?? '';
    _mobileController.text = dataMap['Mobile'] ?? '';
    _dateController.text = dataMap['Date Of Birth'] ?? '';
    _hairType = dataMap['Hair'];
    _eyeColor = dataMap['Eyes'];
    _gender = dataMap['Gender'];
    _maritalStatus = dataMap['Status'];
  }

  Future<void> _selectDate(BuildContext context) async {
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
        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showPicker(BuildContext context, List<String> options, String title, ValueChanged<String> onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 250,
              child: CupertinoPicker(
                itemExtent: 32.0,
                onSelectedItemChanged: (int index) {
                  onSelected(options[index]);
                },
                children: options.map((String value) {
                  return Center(child: Text(value));
                }).toList(),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: Colors.yellow)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showPicker(context, ['Curly', 'Straight'], 'Hair Type', (String value) {
                  setState(() {
                    _hairType = value;
                  });
                });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _hairType ?? 'Hair Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showPicker(context, ['Brown', 'Blue', 'Green'], 'Eye Color', (String value) {
                  setState(() {
                    _eyeColor = value;
                  });
                });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _eyeColor ?? 'Eye Color',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showPicker(context, ['Male', 'Female', 'Rather Not To Say'], 'Gender', (String value) {
                  setState(() {
                    _gender = value;
                  });
                });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _gender ?? 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showPicker(context, ['Single', 'Married', 'Divorced'], 'Marital Status', (String value) {
                  setState(() {
                    _maritalStatus = value;
                  });
                });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _maritalStatus ?? 'Marital Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  Navigator.pop(context, {
                    'basicInfo': widget.data.map((item) {
                      if (item['label'] == 'First Name') {
                        item['value'] = _firstNameController.text;
                      } else if (item['label'] == 'Last Name') {
                        item['value'] = _lastNameController.text;
                      } else if (item['label'] == 'Email') {
                        item['value'] = _emailController.text;
                      } else if (item['label'] == 'Mobile') {
                        item['value'] = _mobileController.text;
                      } else if (item['label'] == 'Date Of Birth') {
                        item['value'] = _dateController.text;
                      } else if (item['label'] == 'Hair') {
                        item['value'] = _hairType;
                      } else if (item['label'] == 'Eyes') {
                        item['value'] = _eyeColor;
                      } else if (item['label'] == 'Gender') {
                        item['value'] = _gender;
                      } else if (item['label'] == 'Status') {
                        item['value'] = _maritalStatus;
                      }
                      return item;
                    }).toList()
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
