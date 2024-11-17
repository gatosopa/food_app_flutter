import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';
import 'package:food_app_flutter/src/features/inventory/my_fridge.dart';
import 'package:food_app_flutter/src/models/ingredients.dart';
import 'package:page_transition/page_transition.dart';


class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  List<Ingredients> _ingredientList = Ingredients.ingredientList;

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
          child: Text("Inventory", style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 30
          ),),
        ),
        
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/fridge.png'),
                    fit: BoxFit.cover
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.4),
                      Colors.black.withOpacity(.2),
                    ]
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("My Fridge",
                    style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(child: MyFridge(), type: PageTransitionType.bottomToTop));
                        },
                        child: Center(child: Text("Check Ingredients", style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 16
                        ),)),
                      ),
                    ),
                    SizedBox(height: 30,),
                    
                  ],
                ),
              ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: _ingredientList.map((ingredient)=>Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(ingredient.imageUrl),
                              fit: BoxFit.cover
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                stops: [.2, .9],
                                colors: [
                                  Colors.black.withOpacity(.5),
                                  Colors.black.withOpacity(.2)
                                ]
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ingredient.name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                                    
                                ],),
                            ),
                          ),
                        ),
                      )).toList()
                    ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}