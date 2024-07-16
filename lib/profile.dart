import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hooka_app/allpages.dart';
import 'package:hooka_app/edit-profile-page.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showLoading = true;
  late Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    var box = await Hive.openBox('myBox');
    String? token = box.get('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not found')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('https://api.hookatimes.com/api/Accounts/GetProfile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body)['data']['data'] ?? {};
        _showLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile data')),
      );
    }
  }

  void _editProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          profileData: profileData,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        profileData = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Center(
          child: Text('My Account', style: GoogleFonts.comfortaa(fontSize: 20)),
        ),
        actions: [
          GestureDetector(
            onTap: _editProfile,
            child: Text('Edit', style: GoogleFonts.comfortaa(fontSize: 15)),
          ),
          SizedBox(width: 20),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _showLoading
          ? const Center(child: LoadingAllpages())
          : ProfileMainPage(profileData: profileData),
    );
  }
}

class ProfileMainPage extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfileMainPage({Key? key, required this.profileData})
      : super(key: key);

  String getValue(String key) {
    return profileData[key]?.toString() ?? '';
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
    final size = MediaQuery.of(context).size;
    final double tableWidth = size.width * 0.3;

    final basicInfoLabels = {
      'birthDate': 'Date of Birth',
      'gender': 'Gender',
      'maritalStatus': 'Status',
      'height': 'Height',
      'weight': 'Weight',
      'bodyType': 'Body Type',
      'hair': 'Hair',
      'eyes': 'Eyes'
    };

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
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.network(
                    profileData['imageUrl'] ?? 'assets/images/profile-img.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color: Colors.black,
                            size: 25,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/profile-img.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ],
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
                        '${getValue('firstName')} ${getValue('lastName')}',
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
                      getValue('email'),
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(getValue('phoneNumber')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if ((getValue('aboutMe') ?? '').isNotEmpty) ...[
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
                  Text(getValue('aboutMe')),
                ],
                const SizedBox(
                  height: 20,
                ),
                if (profileData.isNotEmpty) ...[
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
                  const SizedBox(
                    height: 20,
                  ),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade400),
                    defaultColumnWidth: FixedColumnWidth(tableWidth),
                    children: [
                      for (var row in [
                        ['birthDate', 'gender', 'maritalStatus'],
                        ['height', 'weight', 'bodyType'],
                        ['hair', 'eyes', '']
                      ])
                        TableRow(
                          children: row.map((key) {
                            if (key.isEmpty) {
                              return TableCell(child: Container());
                            }
                            return TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 17),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      basicInfoLabels[key]!,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    Text(
                                      getValue(key),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 5),
                if (profileData['socialMediaLink1'] != null ||
                    profileData['socialMediaLink2'] != null ||
                    profileData['socialMediaLink3'] != null) ...[
                  Row(
                    children: [
                      if (profileData['socialMediaLink1'] != null)
                        GestureDetector(
                          onTap: () => _launchUrl(getValue('socialMediaLink1')),
                          child: const Padding(
                            padding:
                                EdgeInsets.only(top: 15, left: 50, bottom: 15),
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      if (profileData['socialMediaLink2'] != null)
                        GestureDetector(
                          onTap: () => _launchUrl(getValue('socialMediaLink2')),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 100),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      if (profileData['socialMediaLink3'] != null)
                        GestureDetector(
                          onTap: () => _launchUrl(getValue('socialMediaLink3')),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 100),
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
                const SizedBox(height: 0),
                if ((getValue('interests') ?? '').isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Interest',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(getValue('interests'))),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                if ((getValue('hobbies') ?? '').isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Hobbies',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(getValue('hobbies'))),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                if ((getValue('profession') ?? '').isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Profession',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(getValue('profession'))),
                      ),
                    ],
                  ),
                ],
                if (profileData['education'] != null &&
                    (profileData['education'] as List).isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Educations',
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
                      children: (profileData['education'] as List).map<Widget>((edu) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Table(
                            border:
                                TableBorder.all(color: Colors.grey.shade400),
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
                                          Text('University'),
                                          Text(
                                            edu['university'] ?? '',
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
                                          Text('From'),
                                          Text(
                                            edu['studiedFrom'] ?? '',
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
                                            edu['degree'] ?? '',
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
                                          Text('To'),
                                          Text(
                                            edu['studiedTo'] ?? '',
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
                ] else ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Educations',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text('No Educations...',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                if (profileData['experience'] != null &&
                    (profileData['experience'] as List).isNotEmpty) ...[
                  SizedBox(height: 40),
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
                  SizedBox(height: 30),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: (profileData['experience'] as List).map<Widget>((exp) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Table(
                            border:
                                TableBorder.all(color: Colors.grey.shade400),
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
                                          Text('Place'),
                                          Text(
                                            exp['place'] ?? '',
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
                                          Text('From'),
                                          Text(
                                            exp['workedFrom'] ?? '',
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
                                            exp['position'] ?? '',
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
                                          Text('To'),
                                          Text(
                                            exp['workedTo'] ?? '',
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
                ] else ...[
                  SizedBox(height: 40),
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
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'No Experiences...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (profileData['addresses'] != null &&
                    (profileData['addresses'] as List).isNotEmpty) ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Addresses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: (profileData['addresses'] as List).map<Widget>((addr) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Table(
                            border:
                                TableBorder.all(color: Colors.grey.shade400),
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
                                            addr['title'] ?? '',
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
                                            addr['city'] ?? '',
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
                                            addr['street'] ?? '',
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
                                            addr['building'] ?? '',
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
                ] else ...[
                  SizedBox(height: 30),
                  const Row(
                    children: [
                      Text(
                        'Addresses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('No Addresses...',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                const SizedBox(height: 100),
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
                      child: const Center(
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
