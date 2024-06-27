import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/edit-profile-page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onProfileUpdate;
  final List<Map<String, dynamic>> data;

  const ProfilePage({super.key, required this.onProfileUpdate, required this.data});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showLoading = true;
  late List<Map<String, dynamic>> basicInfo;
  List<Map<String, dynamic>> educations = [];
  List<Map<String, dynamic>> experiences = [];
  List<Map<String, dynamic>> addresses = [];
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _mobile = '';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _initializeHive().then((_) {
      _initializeProfileData();
      _loadUserName();
      _changeBodyContent();
    });
  }

  Future<void> _initializeHive() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.openBox('userBox');
    await Hive.openBox('userInfoBox');
    await Hive.openBox('aboutBox');
    await Hive.openBox('interestBox');
  }

  void _initializeProfileData() {
    final userBox = Hive.box('userBox');
    final userInfoBox = Hive.box('userInfoBox');
    final aboutBox = Hive.box('aboutBox');
    final interestBox = Hive.box('interestBox');

    basicInfo = [
      {'label': 'Date Of Birth', 'value': userInfoBox.get('dateOfBirth', defaultValue: '')},
      {'label': 'Gender', 'value': userInfoBox.get('gender', defaultValue: '')},
      {'label': 'Status', 'value': userInfoBox.get('maritalStatus', defaultValue: '')},
      {'label': 'Height', 'value': userInfoBox.get('height', defaultValue: '')},
      {'label': 'Weight', 'value': userInfoBox.get('weight', defaultValue: '')},
      {'label': 'Body Type', 'value': userInfoBox.get('bodyType', defaultValue: '')},
      {'label': 'Hair', 'value': userInfoBox.get('hairType', defaultValue: '')},
      {'label': 'Eyes', 'value': userInfoBox.get('eyeColor', defaultValue: '')},
      {'label': 'Bio', 'value': aboutBox.get('bio', defaultValue: '')},
      {'label': 'Profession', 'value': aboutBox.get('profession', defaultValue: '')},
      {'label': 'Hobbies', 'value': aboutBox.get('hobbies', defaultValue: '')},
      {'label': 'Interest', 'value': interestBox.get('interest', defaultValue: '')},
      {'label': 'Facebook Url', 'value': userBox.get('facebook', defaultValue: '')},
      {'label': 'Instagram Url', 'value': userBox.get('instagram', defaultValue: '')},
      {'label': 'Tiktok Url', 'value': userBox.get('tiktok', defaultValue: '')},
    ];

    educations.clear();
    for (int i = 0;; i++) {
      if (userBox.containsKey('university$i')) {
        educations.add({
          'university': userBox.get('university$i'),
          'from': userBox.get('educationFrom$i'),
          'to': userBox.get('educationTo$i'),
          'degree': userBox.get('degree$i'),
        });
      } else {
        break;
      }
    }

    experiences.clear();
    for (int i = 0;; i++) {
      if (userBox.containsKey('experienceTitle$i')) {
        experiences.add({
          'title': userBox.get('experienceTitle$i'),
          'position': userBox.get('experiencePosition$i'),
          'from': userBox.get('experienceFrom$i'),
          'to': userBox.get('experienceTo$i'),
        });
      } else {
        break;
      }
    }

    addresses.clear();
    for (int i = 0;; i++) {
      if (userBox.containsKey('addressTitle$i')) {
        addresses.add({
          'title': userBox.get('addressTitle$i'),
          'city': userBox.get('addressCity$i'),
          'street': userBox.get('addressStreet$i'),
          'building': userBox.get('addressBuilding$i'),
          'appartment`': userBox.get('addressAppartment$i'),
        });
      } else {
        break;
      }
    }
    _profileImagePath = userBox.get('profileImage', defaultValue: '');
  }

  void _loadUserName() async {
    var box = Hive.box('userBox');
    setState(() {
      _firstName = box.get('firstName', defaultValue: '');
      _lastName = box.get('lastName', defaultValue: '');
      _email = box.get('email', defaultValue: '');
      _mobile = box.get('mobile', defaultValue: '');
    });
  }

  void _changeBodyContent() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  void _editProfile() async {
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EditProfilePage(
        basicInfo: basicInfo,
        educations: educations,
        experiences: experiences,
        addresses: addresses,
      ),
    ),
  );

  if (result != null) {
    setState(() {
      basicInfo = result['basicInfo'];
      educations = result['educations'];
      experiences = result['experiences'];
      addresses = result['addresses'];
      _profileImagePath = result['profileImagePath'];
    });

    var box = Hive.box('userBox');
    var userInfoBox = Hive.box('userInfoBox');
    var aboutBox = Hive.box('aboutBox');
    var interestBox = Hive.box('interestBox');

    for (var item in basicInfo) {
      if (item['label'] == 'Date Of Birth') {
        userInfoBox.put('dateOfBirth', item['value']);
      } else if (item['label'] == 'Gender') {
        userInfoBox.put('gender', item['value']);
      } else if (item['label'] == 'Status') {
        userInfoBox.put('maritalStatus', item['value']);
      } else if (item['label'] == 'Height') {
        userInfoBox.put('height', item['value']);
      } else if (item['label'] == 'Weight') {
        userInfoBox.put('weight', item['value']);
      } else if (item['label'] == 'Body Type') {
        userInfoBox.put('bodyType', item['value']);
      } else if (item['label'] == 'Hair') {
        userInfoBox.put('hairType', item['value']);
      } else if (item['label'] == 'Eyes') {
        userInfoBox.put('eyeColor', item['value']);
      } else if (item['label'] == 'Bio') {
        aboutBox.put('bio', item['value']);
      } else if (item['label'] == 'Profession') {
        aboutBox.put('profession', item['value']);
      } else if (item['label'] == 'Hobbies') {
        aboutBox.put('hobbies', item['value']);
      } else if (item['label'] == 'Interest') {
        interestBox.put('interest', item['value']);
      } else if (item['label'] == 'First Name') {
        box.put('firstName', item['value']);
      } else if (item['label'] == 'Last Name') {
        box.put('lastName', item['value']);
      } else if (item['label'] == 'Email') {
        box.put('email', item['value']);
      } else if (item['label'] == 'Mobile') {
        box.put('mobile', item['value']);
      } else if (item['label'] == 'Profile Image') {
        box.put('profileImage', item['value']);
      } else if (item['label'] == 'Facebook Url') {
        box.put('facebook', item['value']);
      }
    }

    for (var i = 0; i < educations.length; i++) {
      box.put('university$i', educations[i]['university']);
      box.put('educationFrom$i', educations[i]['from']);
      box.put('educationTo$i', educations[i]['to']);
      box.put('degree$i', educations[i]['degree']);
    }

    for (var i = 0; i < experiences.length; i++) {
      box.put('experienceTitle$i', experiences[i]['title']);
      box.put('experiencePosition$i', experiences[i]['position']);
      box.put('experienceFrom$i', experiences[i]['from']);
      box.put('experienceTo$i', experiences[i]['to']);
    }

    for (var i = 0; i < addresses.length; i++) {
      box.put('addressTitle$i', addresses[i]['title']);
      box.put('addressCity$i', addresses[i]['city']);
      box.put('addressStreet$i', addresses[i]['street']);
      box.put('addressBuilding$i', addresses[i]['building']);
    }

    _loadUserName();
    widget.onProfileUpdate();
    setState(() {}); 
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('My Account', style: GoogleFonts.comfortaa(fontSize: 20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            _initializeProfileData();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: _editProfile,
            child: Text('Edit', style: GoogleFonts.comfortaa(fontSize: 15)),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: _showLoading
          ? const LoadingAllpages()
          : ProfileMainPage(
              firstName: _firstName,
              lastName: _lastName,
              email: _email,
              mobile: _mobile,
              basicInfo: basicInfo,
              educations: educations,
              experiences: experiences,
              addresses: addresses,
              profileImagePath: _profileImagePath,
            ),
    );
  }
}

class ProfileMainPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final List<Map<String, dynamic>> basicInfo;
  final List<Map<String, dynamic>> educations;
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> addresses;
  final String? profileImagePath;

  const ProfileMainPage({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.basicInfo,
    required this.educations,
    required this.experiences,
    required this.addresses,
    this.profileImagePath,
    super.key,
  });

  String getValue(String label) {
    return basicInfo.firstWhere((item) => item['label'] == label, orElse: () => {'value': ''})['value'];
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredBasicInfo = basicInfo.where((item) => item['value'].isNotEmpty && !['First Name', 'Last Name', 'Email', 'Mobile', 'Bio', 'Hobbies', 'Profession', 'Interest' , 'Facebook Url' , 'Instagram Url' , 'Tiktok Url'].contains(item['label'])).toList();

    String facebookUrl = getValue('Facebook Url');
    String instagramUrl = getValue('Instagram Url');
    String tiktokUrl = getValue('Tiktok Url');

    return SingleChildScrollView(
      child: Column(
        children: [
         Container(
  width: double.infinity,
  height: 300,
  decoration: BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(40),
      bottomRight: Radius.circular(40),
    ),
  ),
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(40),
      bottomRight: Radius.circular(40),
    ),
    child: profileImagePath != null && profileImagePath!.isNotEmpty
      ? Image.file(
          File(profileImagePath!),
          fit: BoxFit.cover,
        )
      : Image.asset(
          'assets/images/profile-img.png',
          fit: BoxFit.cover,
        ),
  ),
),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$firstName $lastName',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      email,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(mobile),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if ((getValue('Bio') ?? '').isNotEmpty ) ...[
                  const Row(
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if ((getValue('Bio') ?? '').isNotEmpty) Text(getValue('Bio')),
                 
                ],
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'Basic Information',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Table(
                  border: TableBorder.all(color: Colors.grey.shade400),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    for (int i = 0; i < filteredBasicInfo.length; i += 3)
                      TableRow(
                        children: [
                          for (int j = 0; j < 3; j++)
                            if (i + j < filteredBasicInfo.length)
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredBasicInfo[i + j]['label'],
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      Text(
                                        filteredBasicInfo[i + j]['value'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              TableCell(
                                child: Container(), // Empty cell
                              ),
                        ],
                      ),
                  ],
                ),
              
                // const SizedBox(height: 20),
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        GestureDetector(
                          onTap: () => _launchUrl(facebookUrl),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(instagramUrl),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 53),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(tiktokUrl),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                            child: Icon(
                              FontAwesomeIcons.tiktok,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                  if ((getValue('Interest') ?? '').isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Interest',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                    SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(getValue('Interest'))),
                      )
                    ],
                  ),
                  ],
                   const SizedBox(height: 20),
                  if ((getValue('Hobbies') ?? '').isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Hobbies',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                    SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(getValue('Hobbies'))),
                      )
                    ],
                  ),
                  ],
                   const SizedBox(height: 20),
                  if ((getValue('Profession') ?? '').isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Profession',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(getValue('Profession'))),
                      )
                    ],
                  ),
                ],
                if (educations.isNotEmpty) ...[
                  SizedBox(
                    height: 40,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Educations',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: educations.map((edu) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Table(
                            border: TableBorder.all(color: Colors.grey.shade400),
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('University'),
                                          Text(
                                            edu['university'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('From'),
                                          Text(
                                            edu['from'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Degree'),
                                          Text(
                                            edu['degree'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('To'),
                                          Text(
                                            edu['to'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                if (experiences.isNotEmpty) ...[
                  SizedBox(
                    height: 40,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Experiences',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: experiences.map((exp) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Table(
                            border: TableBorder.all(color: Colors.grey.shade400),
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Title'),
                                          Text(
                                            exp['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('From'),
                                          Text(
                                            exp['from'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Position'),
                                          Text(
                                            exp['position'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('To'),
                                          Text(
                                            exp['to'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                if (addresses.isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Addresses',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: addresses.map((addr) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Table(
                            border: TableBorder.all(color: Colors.grey.shade400),
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 80,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Title'),
                                          Text(
                                            addr['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 100,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('City'),
                                          Text(
                                            addr['city'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 60,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Street'),
                                          Text(
                                            addr['street'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 100,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Building'),
                                          Text(
                                            addr['building'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Delete account',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
