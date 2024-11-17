import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/home/widgets/food_slider.dart';
import 'package:food_app_flutter/src/features/profile/edit_profile_page.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}




class _ProfilePageState extends State<ProfilePage> {
  String username = "Wilhelm II";
  late TextEditingController emailController;
  late TextEditingController birthdayController;
  late TextEditingController countryController;
  late TextEditingController pwController;

  @override
  void initState() {
    super.initState();
    // initialize controller and set the data
    emailController = TextEditingController(text: 'wilhelm2nd@gep.rol');
    birthdayController = TextEditingController(text: '27/01/1859');
    pwController = TextEditingController(text: 'this is password');
    countryController = TextEditingController(text: 'German Empire');
  }

  @override
  void dispose() {
    //usernameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    countryController.dispose();
    super.dispose();
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
            SizedBox(
              width: 120, height: 120,
              // we need to get this photo from database, also for info
              child: ClipRRect(borderRadius: BorderRadius.circular(100), child: Image(image: AssetImage(Constants.profilePhoto))),
            ),
            const SizedBox(height: 10,),
            Text(username, style: Theme.of(context).textTheme.titleSmall,),
            const SizedBox(height: 20),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: emailController,   // get email from database
                    enabled: false,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pwController,   // get email from database
                    obscureText: true,
                    enabled: false,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 12,),
                  TextField(
                    controller: birthdayController,   // get birthday from database
                    enabled: false,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  TextField(
                    controller: countryController,   // get country from database
                    enabled: false,
                    style: TextStyle(color: Constants.blackColor),
                    decoration: InputDecoration(
                      labelText: "Country",
                      prefixIcon: Icon(Icons.flag_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12,),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  final updatedInfo = await Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        email: emailController.text,
                        birthday: birthdayController.text,
                        country: countryController.text,
                      ),
                    ),
                  );
                  if (updatedInfo != null) {
                    setState(() {
                      // todo
                      // update the information
                    });
                  }
                }, 
                child: Text(Constants.tEditProfile, style: TextStyle(color: Constants.backgroundColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor, side: BorderSide.none, shape: StadiumBorder()
                ),
              ),
            ),
            const SizedBox(height: 30,),
            //const Divider(),

          ],
          ),


        ),
      ),
    );
  }
}


