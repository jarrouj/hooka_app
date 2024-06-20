import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/edit-profile-page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showLoading = true;
  late List<Map<String, dynamic>> basicInfo;
  late List<Map<String, dynamic>> educations;
  late List<Map<String, dynamic>> experiences;
  late List<Map<String, dynamic>> addresses;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    _changeBodyContent();
  }

  void _initializeProfileData() {
    basicInfo = [
      {'label': 'First Name', 'value': 'Georges'},
      {'label': 'Last Name', 'value': 'Jarrouj'},
      {'label': 'Email', 'value': 'georgesjarrouj3@gmail.com'},
      {'label': 'Mobile', 'value': '76974972'},
      {'label': 'Date Of Birth', 'value': '2003-05-29'},
      {'label': 'Gender', 'value': 'Male'},
      {'label': 'Status', 'value': 'Married'},
      {'label': 'Height', 'value': 'null'},
      {'label': 'Weight', 'value': 'Can\'t say'},
      {'label': 'Body Type', 'value': 'Super Skinny'},
      {'label': 'Hair', 'value': 'No Hair'},
      {'label': 'Eyes', 'value': 'Blue'},
    ];

    educations = [
      {
        'university': 'LAU',
        'from': '1972-01-01',
        'to': '2024-01-01',
        'degree': 'Example Degree',
      },
      {
        'university': 'LAU',
        'from': '1972-01-01',
        'to': '2024-01-01',
        'degree': 'Example Degree',
      },
      {
        'university': 'LAU',
        'from': '1972-01-01',
        'to': '2024-01-01',
        'degree': 'Example Degree',
      },
    ];

    experiences = [
      {
        'title': 'Professor',
        'position': 'Zahle',
        'from': '1972-01-01',
        'to': '2024-01-01',
      },
      {
        'title': 'Professor',
        'position': 'Zahle',
        'from': '1972-01-01',
        'to': '2024-01-01',
      },
      {
        'title': 'Professor',
        'position': 'Zahle',
        'from': '1972-01-01',
        'to': '2024-01-01',
      },
    ];

    addresses = [
      {
        'title': 'Home',
        'city': 'Zahle',
        'street': 'ff',
        'building': 'bb',
      },
      {
        'title': 'Office',
        'city': 'Beirut',
        'street': 'dd',
        'building': 'cc',
      },
    ];
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
      if (result['basicInfo'] != null) basicInfo = result['basicInfo'];
      if (result['educations'] != null) educations = result['educations'];
      if (result['experiences'] != null) experiences = result['experiences'];
      if (result['addresses'] != null) addresses = result['addresses'];
    });
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
        actions: [
          GestureDetector(
            onTap: _editProfile,
            child: Text(
              'Edit',
              style: GoogleFonts.comfortaa(),
            ),
          ),
          const SizedBox(width: 20),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                      basicInfo.firstWhere((item) => item['label'] == 'First Name')['value'] +
                          " " +
                          basicInfo.firstWhere((item) => item['label'] == 'Last Name')['value'],
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
                    Text(basicInfo.firstWhere((item) => item['label'] == 'Email')['value']),
                  ],
                ),
                Row(
                  children: [
                    Text(basicInfo.firstWhere((item) => item['label'] == 'Mobile')['value']),
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
                  children: _buildTableRows(basicInfo),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          children: socialLinks
                              .map(
                                (link) => TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 45),
                                    child: Column(
                                      children: [
                                        Icon(link['icon']),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Text(
                      'Interest',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 130,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('No Interest yet...'),
                      ),
                    ),
                  ],
                ),
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
            _buildTableCell(items[i]),
            if (i + 1 < items.length) _buildTableCell(items[i + 1]) else Container(),
            if (i + 2 < items.length) _buildTableCell(items[i + 2]) else Container(),
          ],
        ),
      );
    }
    return rows;
  }

  Widget _buildTableCell(Map<String, dynamic> item) {
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
