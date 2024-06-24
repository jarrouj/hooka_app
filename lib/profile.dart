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
      {
        'label': 'Date Of Birth',
        'value': box.get('dateOfBirth', defaultValue: '2003-05-29')
      },
      {'label': 'Gender', 'value': box.get('gender', defaultValue: 'Male')},
      {'label': 'Status', 'value': box.get('status', defaultValue: 'Married')},
      {'label': 'Height', 'value': box.get('height', defaultValue: 'null')},
      {
        'label': 'Weight',
        'value': box.get('weight', defaultValue: 'Can\'t say')
      },
      {
        'label': 'Body Type',
        'value': box.get('bodyType', defaultValue: 'Super Skinny')
      },
      {'label': 'Hair', 'value': box.get('hair', defaultValue: 'No Hair')},
      {'label': 'Eyes', 'value': box.get('eyes', defaultValue: 'Blue')},
      {'label': 'First Name', 'value': _firstName},
      {'label': 'Last Name', 'value': _lastName},
      {'label': 'Email', 'value': _email},
      {'label': 'Mobile', 'value': _mobile},
      {'label': 'Facebook Url', 'value': box.get('facebook', defaultValue: '')},
      {
        'label': 'Instagram Url',
        'value': box.get('instagram', defaultValue: '')
      },
      {'label': 'Tiktok Url', 'value': box.get('tiktok', defaultValue: '')},
    ];

    educations.clear();
    for (int i = 0;; i++) {
      if (box.containsKey('university$i')) {
        educations.add({
          'university': box.get('university$i'),
          'from': box.get('educationFrom$i'),
          'to': box.get('educationTo$i'),
          'degree': box.get('degree$i'),
        });
      } else {
        break;
      }
    }

    experiences.clear();
    for (int i = 0;; i++) {
      if (box.containsKey('experienceTitle$i')) {
        experiences.add({
          'title': box.get('experienceTitle$i'),
          'position': box.get('experiencePosition$i'),
          'from': box.get('experienceFrom$i'),
          'to': box.get('experienceTo$i'),
        });
      } else {
        break;
      }
    }

    addresses.clear();
    for (int i = 0;; i++) {
      if (box.containsKey('addressTi$i')) {
        addresses.add({
          'title': box.get('addressTi$i'),
          'city': box.get('addressCi$i'),
          'street': box.get('addressSt$i'),
          'building': box.get('addressBu$i'),
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
        box.put('addressTi$i', addresses[i]['title']);
        box.put('addressCi$i', addresses[i]['city']);
        box.put('addressSt$i', addresses[i]['street']);
        box.put('addressBu$i', addresses[i]['building']);
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

  String getValue(String label) {
    return basicInfo.firstWhere((item) => item['label'] == label)['value'];
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${getValue('First Name')} ${getValue('Last Name')}',
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
                      getValue('Email'),
                      overflow: TextOverflow.visible,
                    ),
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
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date Of Birth', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Date Of Birth'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gender', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Gender'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Status'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Height', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Height'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weight', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Weight'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Body Type', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Body Type'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hair', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Hair'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Eyes', style: const TextStyle(fontSize: 11)),
                                Text(getValue('Eyes'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                          onTap: () => _launchUrl(getValue('Facebook Url')),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 45),
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(getValue('Instagram Url')),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 53),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(getValue('Tiktok Url')),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 55),
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
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child:  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 85,
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
                                          right: 60,
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
