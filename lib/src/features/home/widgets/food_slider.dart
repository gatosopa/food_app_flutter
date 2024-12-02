import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/shapes/circular_container.dart';
import 'package:food_app_flutter/src/core/shapes/rounded_image.dart';
import 'package:food_app_flutter/src/models/food.dart';
import 'package:get/get.dart';

class FoodSlider extends StatelessWidget {
  final List<Food> banners;

  const FoodSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_FoodSliderController());

    return Column(
      children: [
        _buildCarouselSlider(controller),
        const SizedBox(height: 20),
        _buildPageIndicator(controller),
      ],
    );
  }

  // Carousel Slider
  Widget _buildCarouselSlider(_FoodSliderController controller) {
    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (context, index, realIndex) {
        final food = banners[index];
        return RoundedImage(food: food);
      },
      options: CarouselOptions(
        viewportFraction: 0.7,
        height: 420,
        aspectRatio: 16 / 9,
        onPageChanged: (index, _) => controller.updatePageIndicator(index),
        enlargeCenterPage: true,
      ),
    );
  }

  // Page Indicator
  Widget _buildPageIndicator(_FoodSliderController controller) {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          banners.length,
          (index) => CircularContainer(
            width: 20,
            height: 4,
            margin: const EdgeInsets.only(right: 10),
            backgroundColor: controller.carousalCurrentIndex.value == index
                ? Constants.primaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// Controller for the Carousel
class _FoodSliderController extends GetxController {
  var carousalCurrentIndex = 0.obs;

  void updatePageIndicator(int index) {
    carousalCurrentIndex.value = index;
  }
}
