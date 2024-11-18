import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/home/widgets/food_slider.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditProfilePage  extends StatefulWidget {
  final String email;
  final String birthday;
  final String country;

  const EditProfilePage({
    Key? key,
    required this.email,
    required this.birthday,
    required this.country,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}




class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController birthdayController;
  late TextEditingController countryController;
  late TextEditingController pwController;
  String? selectedCountry;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: 'Wilhelm II');
    emailController = TextEditingController(text: 'wilhelm2nd@gep.rol');
    birthdayController = TextEditingController(text: '27/01/1859');
    pwController = TextEditingController(text: 'this is password');
    countryController = TextEditingController(text: 'German Empire');
  }
  
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    pwController.dispose();
    countryController.dispose();
    super.dispose();
  }


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // update profile image
      });
    }
  }


  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context); // close BottomSheet
                  _pickImage(ImageSource.camera); // open camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context); // close BottomSheet
                  _pickImage(ImageSource.gallery); // select from camera
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.tProfile, style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
          child: Column(children: [
            GestureDetector(
              onTap: _showImagePicker, // Pop up the menu when clicking the photo
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) // display selected image
                    : AssetImage(Constants.profilePhoto)
                        as ImageProvider, // default image
                child: _imageFile == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      )
                    : null, // display camera icon when there's no image
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: usernameController,   // get username from database
                    enabled: true,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.abc_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15,),

                  TextField(
                    controller: emailController,   // get email from database
                    enabled: true,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15,),

                  TextField(
                    controller: pwController,   // get pw from database
                    obscureText: false,
                    enabled: true,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 15,),

                  TextField(
                    controller: birthdayController,   // get birthday from database
                    readOnly: true,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        // Format and display the date
                        setState(() {
                          birthdayController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  DropdownButtonFormField<String>(
                    value: selectedCountry,
                    items: [
                      'United States', 
                      'South Korea',
                      'North Korea',
                      'China',
                      'Indonesia',
                      'Germany',
                      'Russia',
                      'France',
                      'Malaysia',
                    ].map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder()
                    ),  
                  ),
                  /*
                  // selecting country old version
                  TextField(
                    controller: countryController,   // get country from database
                    enabled: true,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Country",
                      prefixIcon: Icon(Icons.flag_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),*/
                  const SizedBox(height: 10,),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: (){
                  // save changes and return to profile page
                  // haven't implemented 
                  Navigator.pop(context);
                }, 
                child: Text(Constants.tEditProfileDone, style: TextStyle(color: Constants.backgroundColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor, side: BorderSide.none, shape: StadiumBorder()
                ),
              ),
            ),
            //const Divider(),

          ],
          ),


        ),
      ),
    );
  }
}