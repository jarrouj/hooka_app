import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PersonalTab extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(List<Map<String, dynamic>>) onSave;

  const PersonalTab({required this.data, required this.onSave, super.key});

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
  TextEditingController _bioController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _interestController = TextEditingController();
  TextEditingController _professionController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _tiktokController = TextEditingController();
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
    _bioController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _interestController.dispose();
    _professionController.dispose();
    _hobbiesController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var box = await Hive.openBox('userBox');
    final Map<String, String> dataMap = {for (var item in widget.data) item['label']: item['value']};
    _firstNameController.text = box.get('firstName', defaultValue: dataMap['First Name'] ?? '');
    _lastNameController.text = box.get('lastName', defaultValue: dataMap['Last Name'] ?? '');
    _emailController.text = box.get('email', defaultValue: dataMap['Email'] ?? '');
    _mobileController.text = box.get('mobile', defaultValue: dataMap['Mobile'] ?? '');
    _dateController.text = dataMap['Date Of Birth'] ?? '';
    _hairType = dataMap['Hair'];
    _eyeColor = dataMap['Eyes'];
    _gender = dataMap['Gender'];
    _maritalStatus = dataMap['Status'];
    _bioController.text = dataMap['Bio'] ?? '';
    _weightController.text = dataMap['Weight'] ?? '';
    _heightController.text = dataMap['Height'] ?? '';
    _interestController.text = dataMap['Interest'] ?? '';
    _professionController.text = dataMap['Profession'] ?? '';
    _hobbiesController.text = dataMap['Hobbies'] ?? '';
    _facebookController.text = dataMap['Facebook Url'] ?? '';
    _instagramController.text = dataMap['Instagram Url'] ?? '';
    _tiktokController.text = dataMap['Tiktok Url'] ?? '';
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

  void _saveAndReturn() {
    if (_formKey.currentState!.validate()) {
      // Save data to Hive
      var box = Hive.box('userBox');
      box.put('firstName', _firstNameController.text);
      box.put('lastName', _lastNameController.text);
      box.put('email', _emailController.text);
      box.put('mobile', _mobileController.text);
      box.put('bio', _bioController.text);
      box.put('weight', _weightController.text);
      box.put('height', _heightController.text);
      box.put('interest', _interestController.text);
      box.put('profession', _professionController.text);
      box.put('hobbies', _hobbiesController.text);
      box.put('facebook', _facebookController.text);
      box.put('instagram', _instagramController.text);
      box.put('tiktok', _tiktokController.text);

      // Update basic info
      widget.onSave(widget.data.map((item) {
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
        } else if (item['label'] == 'Bio') {
          item['value'] = _bioController.text;
        } else if (item['label'] == 'Weight') {
          item['value'] = _weightController.text;
        } else if (item['label'] == 'Height') {
          item['value'] = _heightController.text;
        } else if (item['label'] == 'Interest') {
          item['value'] = _interestController.text;
        } else if (item['label'] == 'Profession') {
          item['value'] = _professionController.text;
        } else if (item['label'] == 'Hobbies') {
          item['value'] = _hobbiesController.text;
        } else if (item['label'] == 'Facebook Url') {
          item['value'] = _facebookController.text;
        } else if (item['label'] == 'Instagram Url') {
          item['value'] = _instagramController.text;
        } else if (item['label'] == 'Tiktok Url') {
          item['value'] = _tiktokController.text;
        }
        return item;
      }).toList());

      Navigator.pop(context, {'basicInfo': widget.data}); // Return to profile page with updated data
    }
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
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _interestController,
              decoration: InputDecoration(
                labelText: 'Interest',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _professionController,
              decoration: InputDecoration(
                labelText: 'Profession',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hobbiesController,
              decoration: InputDecoration(
                labelText: 'Hobbies',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Social Media',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _facebookController,
              decoration: InputDecoration(
                labelText: 'Facebook Url',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instagramController,
              decoration: InputDecoration(
                labelText: 'Instagram Url',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tiktokController,
              decoration: InputDecoration(
                labelText: 'Tiktok Url',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveAndReturn,
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
