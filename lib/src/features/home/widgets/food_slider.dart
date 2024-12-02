import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/shapes/circular_container.dart';
import 'package:food_app_flutter/src/core/shapes/rounded_image.dart';
import 'package:food_app_flutter/src/features/home/controllers/controller.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:get/get.dart';

class FoodSlider extends StatelessWidget {
  const FoodSlider({
    super.key,
    required this.banners
  });

  final List<Food> banners;
  

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.7,
            height: 420,
            aspectRatio: 16/9,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
            enlargeCenterPage: true,
          ),
          items: banners.map((food) => RoundedImage(food: food)).toList()
        ),
        const SizedBox(height: 20,),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i = 0; i < banners.length; i++)
                CircularContainer(
                width: 20,
                height: 4,
                margin: EdgeInsets.only(right: 10),
                backgroundColor: controller.carousalCurrentIndex.value == i ? Constants.primaryColor : Colors.grey,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}