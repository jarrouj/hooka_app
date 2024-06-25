import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooka_app/address.dart';
import 'package:hooka_app/education.dart';
import 'package:hooka_app/experience.dart';
import 'package:hooka_app/personal.dart';
import 'package:hooka_app/tab-item.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    basicInfo = List.from(widget.basicInfo);
    educations = List.from(widget.educations);
    experiences = List.from(widget.experiences);
    addresses = List.from(widget.addresses);
  }

  void _saveProfile() async {
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

    Navigator.pop(context, {
      'basicInfo': basicInfo,
      'educations': educations,
      'experiences': experiences,
      'addresses': addresses,
    });
  }

  void _updateBasicInfo(List<Map<String, dynamic>> updatedBasicInfo) {
    setState(() {
      basicInfo = updatedBasicInfo;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      var box = Hive.box('userBox');
      box.put('profileImage', pickedFile.path);

      setState(() {
        basicInfo.firstWhere((item) => item['label'] == 'Profile Image')['value'] = pickedFile.path;
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
                  leading: Icon(Icons.camera_alt_outlined, color: Colors.yellow.shade600),
                  title: Text('Camera', style: TextStyle(color: Colors.yellow.shade600)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo, color: Colors.yellow.shade600),
                  title: Text('Gallery', style: TextStyle(color: Colors.yellow.shade600)),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              _saveProfile();
            },
          ),
          actions: const [
            SizedBox(width: 45,),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
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
                      SingleChildScrollView(
                        child: PersonalTab(
                          data: basicInfo,
                          onSave: _updateBasicInfo,
                          saveProfile: _saveProfile,  
                        ),
                      ),
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
              child: GestureDetector(
                onTap: (){
                  _showImageSourceDialog(context);
                },
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
            ),
          ],
        ),
      ),
    );
  }
}
