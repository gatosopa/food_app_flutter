import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/root_page.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: (){//route to log in screen
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RootPage()));
              }, 
              child: const Text('Skip', style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ))
            ),
          )
        ]
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page){
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: [
              CreatePage(
                image: 'assets/image/food_1.png',
                title: Constants.titleOne,
                description: Constants.descriptionOne,
              ),
              CreatePage(
                image: 'assets/image/food_2.png',
                title: Constants.titleTwo,
                description: Constants.descriptionTwo,
              ),
              CreatePage(
                image: 'assets/image/food_3.png',
                title: Constants.titleThree,
                description: Constants.descriptionThree,
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 30,
            child: Row(
              children: _buildIndicator(),
              )
            ),
            Positioned(
              bottom: 60,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.primaryColor,
                ),
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      if(currentIndex < 2){
                        currentIndex++;
                        if(currentIndex < 3){
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      }else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RootPage()));
                      }
                    });
                  }, 
                  icon: const Icon(
                    Icons.arrow_forward_ios, 
                    size: 24, 
                    color: Colors.white,)
                ),
                
              )
            ),
        ],
      ),
    );
  }

   //Indicator decorations widget
  Widget _indicator(bool isActive){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

//Create indicator list
  List<Widget> _buildIndicator(){
    List<Widget> indicators = [];

    for(int i = 0; i < 3; i++){
      if(currentIndex == i){
        indicators.add(_indicator(true));
      }
      else{
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({
    super.key,
    required this.image,
    required this.title,
    required this.description
  } 
  );
  
  final String image;
  final String title;
  final String description;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 350, child: Image.asset(image),),
          const SizedBox(height: 20,),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Constants.primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20,),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

