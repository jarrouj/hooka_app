import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/address.dart';
import 'package:hooka_app/education.dart';
import 'package:hooka_app/experience.dart';
import 'package:hooka_app/personal.dart';
import 'package:hooka_app/tab-item.dart';

class EditProfilePage extends StatefulWidget {
  final List<Map<String, dynamic>> basicInfo;
  final List<Map<String, dynamic>> educations;
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> addresses;

  const EditProfilePage({
    required this.basicInfo,
    required this.educations,
    required this.experiences,
    required this.addresses,
    super.key,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late List<Map<String, dynamic>> basicInfo;
  late List<Map<String, dynamic>> educations;
  late List<Map<String, dynamic>> experiences;
  late List<Map<String, dynamic>> addresses;

  @override
  void initState() {
    super.initState();
    basicInfo = List.from(widget.basicInfo);
    educations = List.from(widget.educations);
    experiences = List.from(widget.experiences);
    addresses = List.from(widget.addresses);
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'basicInfo': basicInfo,
      'educations': educations,
      'experiences': experiences,
      'addresses': addresses,
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Edit Account', style: GoogleFonts.comfortaa(fontSize: 20)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
            const SizedBox(width: 20),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
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
                        child: Image.asset(
                          'assets/images/profile-img.png',
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10 ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                    ),
                    child:  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.yellow.shade600,
                          borderRadius:const BorderRadius.all(Radius.circular(10)),
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
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(child: PersonalTab(data: basicInfo)),
                      EducationTab(
                        items: educations,
                        onAdd: (item) {
                          setState(() {
                            educations.add(item);
                          });
                        },
                        onRemove: (index) {
                          setState(() {
                            educations.removeAt(index);
                          });
                        },
                      ),
                      ExperienceTab(
                        items: experiences,
                        onAdd: (item) {
                          setState(() {
                            experiences.add(item);
                          });
                        },
                        onRemove: (index) {
                          setState(() {
                            experiences.removeAt(index);
                          });
                        },
                      ),
                      AddressTab(
                        items: addresses,
                        onAdd: (item) {
                          setState(() {
                            addresses.add(item);
                          });
                        },
                        onRemove: (index) {
                          setState(() {
                            addresses.removeAt(index);
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
              right: 100,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Icon(Icons.camera_alt_outlined, color: Colors.yellow.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
