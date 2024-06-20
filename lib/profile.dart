import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/edit-profile-page.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onProfileUpdate;

  const ProfilePage({super.key, required this.onProfileUpdate});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showLoading = true;
  late List<Map<String, dynamic>> basicInfo;
  List<Map<String, dynamic>> educations = [];
  List<Map<String, dynamic>> experiences = [];
  List<Map<String, dynamic>> addresses = [];
  String _firstName = 'Georges';
  String _lastName = 'Jarrouj';
  String _email = 'georgesjarrouj3@gmail.com';
  String _mobile = '76974972';

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _initializeProfileData();
    _loadUserName();
    _changeBodyContent();
  }

  Future<void> _initializeHive() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.openBox('userBox');
  }

  void _initializeProfileData() {
    final box = Hive.box('userBox');

    basicInfo = [
      {'label': 'Date Of Birth', 'value': box.get('dateOfBirth', defaultValue: '2003-05-29')},
      {'label': 'Gender', 'value': box.get('gender', defaultValue: 'Male')},
      {'label': 'Status', 'value': box.get('status', defaultValue: 'Married')},
      {'label': 'Height', 'value': box.get('height', defaultValue: 'null')},
      {'label': 'Weight', 'value': box.get('weight', defaultValue: 'Can\'t say')},
      {'label': 'Body Type', 'value': box.get('bodyType', defaultValue: 'Super Skinny')},
      {'label': 'Hair', 'value': box.get('hair', defaultValue: 'No Hair')},
      {'label': 'Eyes', 'value': box.get('eyes', defaultValue: 'Blue')},
      {'label': 'First Name', 'value': _firstName},
      {'label': 'Last Name', 'value': _lastName},
      {'label': 'Email', 'value': _email},
      {'label': 'Mobile', 'value': _mobile},
    ];

    educations.clear();
    for (int i = 0; ; i++) {
      if (box.containsKey('university$i')) {
        educations.add({
          'university': box.get('university$i', defaultValue: 'LAU'),
          'from': box.get('educationFrom$i', defaultValue: '1972-01-01'),
          'to': box.get('educationTo$i', defaultValue: '2024-01-01'),
          'degree': box.get('degree$i', defaultValue: 'Example Degree'),
        });
      } else {
        break;
      }
    }

    experiences.clear();
    for (int i = 0; ; i++) {
      if (box.containsKey('experienceTitle$i')) {
        experiences.add({
          'title': box.get('experienceTitle$i', defaultValue: 'Professor'),
          'position': box.get('experiencePosition$i', defaultValue: 'Zahle'),
          'from': box.get('experienceFrom$i', defaultValue: '1972-01-01'),
          'to': box.get('experienceTo$i', defaultValue: '2024-01-01'),
        });
      } else {
        break;
      }
    }

    addresses.clear();
    for (int i = 0; ; i++) {
      if (box.containsKey('addressTitle$i')) {
        addresses.add({
          'title': box.get('addressTitle$i'),
          'city': box.get('addressCity$i'),
          'street': box.get('addressStreet$i'),
          'building': box.get('addressBuilding$i'),
        });
      } else {
        break;
      }
    }
  }

  void _loadUserName() async {
    var box = Hive.box('userBox');
    setState(() {
      _firstName = box.get('firstName', defaultValue: 'Georges');
      _lastName = box.get('lastName', defaultValue: 'Jarrouj');
      _email = box.get('email', defaultValue: 'georgesjarrouj3@gmail.com');
      _mobile = box.get('mobile', defaultValue: '76974972');
      _initializeProfileData();  
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
      });

      var box = Hive.box('userBox');
      for (var item in basicInfo) {
        box.put(item['label'].toLowerCase().replaceAll(' ', ''), item['value']);
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

      widget.onProfileUpdate();
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
              basicInfo: basicInfo,
              educations: educations,
              experiences: experiences,
              addresses: addresses,
            ),
    );
  }
}

class ProfileMainPage extends StatelessWidget {
  final List<Map<String, dynamic>> basicInfo;
  final List<Map<String, dynamic>> educations;
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> addresses;

  const ProfileMainPage({
    required this.basicInfo,
    required this.educations,
    required this.experiences,
    required this.addresses,
    super.key,
  });

  final List<Map<String, dynamic>> socialLinks = const [
    {'icon': Icons.facebook, 'label': 'Facebook'},
    {'icon': FontAwesomeIcons.instagram, 'label': 'Instagram'},
    {'icon': Icons.tiktok, 'label': 'TikTok'},
  ];

  String getValue(String label) {
    return basicInfo.firstWhere((item) => item['label'] == label)['value'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Image.asset(
              'assets/images/profile-img.png',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${getValue('First Name')} ${getValue('Last Name')}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(getValue('Email')),
                  ],
                ),
                Row(
                  children: [
                    Text(getValue('Mobile')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'About',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 90,
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
                  children: _buildTableRows(basicInfo),
                ),
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
                          fontSize: 18,
                        ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('University'),
                                          Text(
                                            edu['university'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('From'),
                                          Text(
                                            edu['from'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Degree'),
                                          Text(
                                            edu['degree'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('To'),
                                          Text(
                                            edu['to'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          fontSize: 18,
                        ),
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
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Title'),
                                          Text(
                                            exp['title'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('From'),
                                          Text(
                                            exp['from'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Position'),
                                          Text(
                                            exp['position'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('To'),
                                          Text(
                                            exp['to'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
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
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Title'),
                                          Text(
                                            addr['title'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('City'),
                                          Text(
                                            addr['city'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Street'),
                                          Text(
                                            addr['street'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Building'),
                                          Text(
                                            addr['building'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                SizedBox(height: 40),
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

  List<TableRow> _buildTableRows(List<Map<String, dynamic>> items) {
    List<TableRow> rows = [];
    for (var i = 0; i < items.length; i += 3) {
      rows.add(
        TableRow(
          children: [
            if (i < items.length) _buildTableCell(items[i]) else Container(),
            if (i + 1 < items.length) _buildTableCell(items[i + 1]) else Container(),
            if (i + 2 < items.length) _buildTableCell(items[i + 2]) else Container(),
          ],
        ),
      );
    }

    // Make the last cell empty
    if (rows.isNotEmpty) {
      var lastRowCells = rows.last.children;
      if (lastRowCells != null) {
        for (var j = 0; j < lastRowCells.length; j++) {
          if (lastRowCells[j] == Container()) {
            lastRowCells[j] = Container();
            break;
          }
        }
      }
    }

    return rows;
  }

  Widget _buildTableCell(Map<String, dynamic> item) {
    if (item['label'] == 'First Name' ||
        item['label'] == 'Last Name' ||
        item['label'] == 'Email' ||
        item['label'] == 'Mobile') {
      return Container();
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['label']),
            Text(
              item['value'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
