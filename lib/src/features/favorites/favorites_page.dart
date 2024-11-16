import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/core/containers/section_heading.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Favorites", style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 30
          ),),
        ),
        
      ),
      body: NestedScrollView(headerSliverBuilder: (_, innerBoxIsScrolled){
        return [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 440,

            flexibleSpace: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [

                   Padding( //Search box
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container( //Actual Search Box
                            
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            width: size.width * .9,
                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17),
                            
                            ),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color:Colors.black54.withOpacity(.6),),
                                SizedBox(
                                  width:20
                                ),
                                const Expanded(
                                  
                                  child: TextField(
                                    showCursor: false,
                                    decoration: InputDecoration(
                                      hintText: 'Search Your Favorite Recipes',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.mic, color: Colors.black54.withOpacity(.6),),
                              ],
                            ),

                          )
                        ],
                      ),
                    ),
                  SizedBox(height: 16,), //End of Search box

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            "Favorite Recipes",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: TextButton(
                          onPressed: (){}, 
                          child: 
                            Text("View All", style: TextStyle(color: Constants.primaryColor,)),
                          ),
                        ),
                      ],),

                  const SizedBox (height: 8,)

                ],
              ),
            ),
          )
        ];
      }, body: Container())
    );
  }
}