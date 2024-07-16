import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/address.dart';
import 'package:hooka_app/education.dart';
import 'package:hooka_app/experience.dart';
import 'package:hooka_app/personal.dart';
import 'package:hooka_app/tab-item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:hive/hive.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const EditProfilePage({
    required this.profileData,
    Key? key,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
  final ImagePicker _picker = ImagePicker();
  int? _hairType;
  int? _eyeColor;
  int? _gender;
  int? _maritalStatus;
  String? _profileImagePath;
  File? _profileImageFile;

  List<Map<String, dynamic>> educationData = [];
  List<Map<String, dynamic>> experienceData = [];
  List<Map<String, dynamic>> addressData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final data = widget.profileData;

    setState(() {
      _firstNameController.text = data['firstName'] ?? '';
      _lastNameController.text = data['lastName'] ?? '';
      _emailController.text = data['email'] ?? '';
      _mobileController.text = data['phoneNumber'] ?? '';
      _dateController.text = data['birthDate'] ?? '';
      _hairType = 1;
      _eyeColor = 1;
      _gender = 1;
      _maritalStatus = 1;
      _bioController.text = data['aboutMe'] ?? '';
      _weightController.text = data['weight']?.toString() ?? '';
      _heightController.text = data['height']?.toString() ?? '';
      _interestController.text = data['interests'] ?? '';
      _professionController.text = data['profession'] ?? '';
      _hobbiesController.text = data['hobbies'] ?? '';
      _facebookController.text = data['socialMediaLink1'] ?? '';
      _instagramController.text = data['socialMediaLink2'] ?? '';
      _tiktokController.text = data['socialMediaLink3'] ?? '';
      _profileImagePath = data['imageUrl'];
      educationData = List<Map<String, dynamic>>.from(data['education'] ?? []);
      experienceData = List<Map<String, dynamic>>.from(data['experience'] ?? []);
      addressData = List<Map<String, dynamic>>.from(data['addresses'] ?? []);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Choose an option',
                      style: TextStyle(
                        color: Colors.yellow.shade600,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined,
                      color: Colors.yellow.shade600),
                  title: Text('Camera',
                      style: TextStyle(color: Colors.yellow.shade600)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo, color: Colors.yellow.shade600),
                  title: Text('Gallery',
                      style: TextStyle(color: Colors.yellow.shade600)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime firstDate = DateTime(1970);
    DateTime lastDate = DateTime(2015, 12, 31);
    DateTime initialDate = DateTime(2015, 1, 1);

    DateTime? pickedDate;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
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
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _dateController.text =
            "${pickedDate?.year}-${pickedDate?.month.toString().padLeft(2, '0')}-${pickedDate?.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveData(BuildContext context) async {
    Map<String, dynamic> updatedData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'phoneNumber': _mobileController.text,
      'birthDate': _dateController.text,
      'hair': 1,
      'eyes': 1,
      'gender': 1,
      'maritalStatus': 1,
      'aboutMe': _bioController.text,
      'weight': _weightController.text,
      'height': _heightController.text,
      'interests': _interestController.text,
      'profession': _professionController.text,
      'hobbies': _hobbiesController.text,
      'socialMediaLink1': _facebookController.text,
      'socialMediaLink2': _instagramController.text,
      'socialMediaLink3': _tiktokController.text,
    };

    var response = await _updateProfile(updatedData);
    final responseData = jsonDecode(response.body);

    if (responseData['statusCode'] == 200) {
      if (mounted) {
        Navigator.of(context).pop(updatedData);
      }
    } else {
      final String errorMessage = responseData['errorMessage'] ?? 'Failed to update';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<http.Response> _updateProfile(Map<String, dynamic> updatedData) async {
    String url = 'https://api.hookatimes.com/api/Accounts/UpdateProfile';

    var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    if (token == null) {
      throw Exception('Token is null');
    }

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(updatedData.map((key, value) => MapEntry(key, value.toString())));

    if (_profileImageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _profileImageFile!.path,
        filename: basename(_profileImageFile!.path),
      ));
    }

    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,  // Set the correct length for the tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Edit Account', style: GoogleFonts.comfortaa(fontSize: 20)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              _saveData(context);
            },
          ),
          actions: const [
            SizedBox(width: 45),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipOval(
                        child: _profileImagePath != null
                            ? Image.file(
                                File(_profileImagePath!),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              )
                            : Image.asset(
                                'assets/images/profile-img.png',
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.yellow.shade600,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                        tabs: const [
                          TabItem(title: 'Personal'),
                          TabItem(title: 'Education'),
                          TabItem(title: 'Experience'),
                          TabItem(title: 'Address'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: PersonalTab(
                          data: widget.profileData,
                          onSave: (updatedData) {
                            setState(() {
                              widget.profileData.addAll(updatedData);
                            });
                          },
                          saveProfile: (context) {
                            _saveData(context);
                          },
                        ),
                      ),
                      EducationTab(
                        items: educationData,
                        onAdd: (item) {
                          setState(() {
                            educationData.add(item);
                          });
                        },
                        onRemove: (index) {
                          setState(() {
                            educationData.removeAt(index);
                          });
                        },
                      ),
                      ExperienceTab(
                        items: experienceData,
                        onAdd: (item) {
                          setState(() {
                            experienceData.add(item);
                          });
                        },
                        onRemove: (index) {
                          setState(() {
                            experienceData.removeAt(index);
                          });
                        },
                      ),
                      AddressTab(
                        items: addressData,
                        onAdd: (item) {
                          setState(() {
                            addressData.add(item);
                          });
                        },
                        onRemove: (index) {
                          setState(() {
                            addressData.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 170,
              left: MediaQuery.of(context).size.width / 1.7,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.yellow.shade600),
                  onPressed: () {
                    _showImageSourceDialog(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
