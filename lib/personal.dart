import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PersonalTab extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(List<Map<String, dynamic>>) onSave;
  final Function saveProfile;

  const PersonalTab({required this.data, required this.onSave, required this.saveProfile, super.key});

  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
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
    var userBox = await Hive.openBox('userBox');
    var userInfoBox = await Hive.openBox('userInfoBox');
    var aboutBox = await Hive.openBox('aboutBox');
    var interestBox = await Hive.openBox('interestBox');
    final Map<String, String> dataMap = {for (var item in widget.data) item['label']: item['value']};
    setState(() {
      _firstNameController.text = userBox.get('firstName', defaultValue: dataMap['First Name'] ?? '');
      _lastNameController.text = userBox.get('lastName', defaultValue: dataMap['Last Name'] ?? '');
      _emailController.text = userBox.get('email', defaultValue: dataMap['Email'] ?? '');
      _mobileController.text = userBox.get('mobile', defaultValue: dataMap['Mobile'] ?? '');
      _dateController.text = dataMap['Date Of Birth'] ?? '';
      _hairType = userInfoBox.get('hairType', defaultValue: dataMap['Hair']);
      _eyeColor = userInfoBox.get('eyeColor', defaultValue: dataMap['Eyes']);
      _gender = userInfoBox.get('gender', defaultValue: dataMap['Gender']);
      _maritalStatus = userInfoBox.get('maritalStatus', defaultValue: dataMap['Status']);
      _bioController.text = aboutBox.get('bio', defaultValue: dataMap['Bio'] ?? '');
      _weightController.text = dataMap['Weight'] ?? '';
      _heightController.text = dataMap['Height'] ?? '';
      _interestController.text = interestBox.get('interest', defaultValue: dataMap['Interest'] ?? '');
      _professionController.text = aboutBox.get('profession', defaultValue: dataMap['Profession'] ?? '');
      _hobbiesController.text = aboutBox.get('hobbies', defaultValue: dataMap['Hobbies'] ?? '');
      _facebookController.text = userBox.get('facebook', defaultValue: dataMap['Facebook Url'] ?? '');
      _instagramController.text = userBox.get('instagram', defaultValue: dataMap['Instagram Url'] ?? '');
      _tiktokController.text = userBox.get('tiktok', defaultValue: dataMap['Tiktok Url'] ?? '');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2025);

    DateTime pickedDate = initialDate;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
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
        );
      },
    );

    if (pickedDate != initialDate) {
      setState(() {
        _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
      // _saveData();
    }
  }

  void _showPicker(BuildContext context, List<String> options, String title, String? initialValue, ValueChanged<String> onSelected) {
    final int initialIndex = initialValue != null ? options.indexOf(initialValue) : 0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      onSelected(options[index]);
                    });
                  },
                  children: options.map((String value) {
                    return Center(child: Text(value));
                  }).toList(),
                ),
              ),
             
            ],
          ),
        );
      },
    );
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      var userBox = await Hive.openBox('userBox');
      var userInfoBox = await Hive.openBox('userInfoBox');
      var aboutBox = await Hive.openBox('aboutBox');
      var interestBox = await Hive.openBox('interestBox');
      userBox.put('firstName', _firstNameController.text);
      userBox.put('lastName', _lastNameController.text);
      userBox.put('email', _emailController.text);
      userBox.put('mobile', _mobileController.text);
      userInfoBox.put('dateOfBirth', _dateController.text);
      userInfoBox.put('hairType', _hairType);
      userInfoBox.put('eyeColor', _eyeColor);
      userInfoBox.put('gender', _gender);
      userInfoBox.put('maritalStatus', _maritalStatus);
      aboutBox.put('bio', _bioController.text);
      userInfoBox.put('weight', _weightController.text);
      userInfoBox.put('height', _heightController.text);
      interestBox.put('interest', _interestController.text);
      aboutBox.put('profession', _professionController.text);
      aboutBox.put('hobbies', _hobbiesController.text);
      userBox.put('facebook', _facebookController.text);
      userBox.put('instagram', _instagramController.text);
      userBox.put('tiktok', _tiktokController.text);

      List<Map<String, dynamic>> updatedData = widget.data.map((item) {
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
      }).toList();

      widget.onSave(updatedData);

      widget.saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  _showPicker(context, ['Curly', 'Straight'], 'Hair Type', _hairType, (String value) {
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
                  _showPicker(context, ['Brown', 'Blue', 'Green'], 'Eye Color', _eyeColor, (String value) {
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
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _showPicker(context, ['Male', 'Female', 'Rather Not To Say'], 'Gender', _gender, (String value) {
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
                  _showPicker(context, ['Single', 'Married', 'Divorced'], 'Marital Status', _maritalStatus, (String value) {
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
                Text('Social Media' , style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
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
              GestureDetector(
                onTap: (){
                  _saveData();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.yellow.shade600,
                  ),
                  child: const Center(child: Text('Save', style: TextStyle(fontSize: 20),)),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
