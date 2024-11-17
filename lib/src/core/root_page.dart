import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/camera_page.dart';
import 'package:food_app_flutter/src/features/favorites/favorites_page.dart';
import 'package:food_app_flutter/src/features/home/home_page.dart';
import 'package:food_app_flutter/src/features/inventory/inventory_page.dart';
import 'package:food_app_flutter/src/features/profile/profile_page.dart';
import 'package:page_transition/page_transition.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  //List of pages
  List<Widget> pages = const [
    HomePage(),
    InventoryPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  //List of pages icon
  List<IconData> iconList = [
    Icons.home,
    Icons.inventory,
    Icons.favorite,
    Icons.person,
  ];

  //List of pages title
  List<String> titleList = [
    'Home',
    'Inventory',
    'Favorite',
    'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, PageTransition(child: const CameraPage(), type: PageTransitionType.bottomToTop));
          },
          shape: CircleBorder(),
          backgroundColor: Constants.primaryColor,
          child: Image.asset('assets/image/camera_icon_white.png', height: 30.0,),
          
      ),  
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Constants.primaryColor,
        activeColor: Constants.primaryColor,
        inactiveColor: Colors.black.withOpacity(.5),
        icons: iconList,
        
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index){
          setState(() {
            _bottomNavIndex = index;
          });
        }
      ),
    );
  }
}