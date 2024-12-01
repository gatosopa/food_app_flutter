import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/camera/presentation/view/camera_page.dart';
import 'package:page_transition/page_transition.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  // List of icons
  final List<IconData> iconList = const [
    Icons.home,
    Icons.inventory,
    Icons.favorite,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      splashColor: Constants.primaryColor,
      activeColor: Constants.primaryColor,
      inactiveColor: Colors.black.withOpacity(.5),
      icons: iconList,
      activeIndex: currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      onTap: (index) => onTap(index),
    );
  }
}
