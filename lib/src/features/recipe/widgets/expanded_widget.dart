import 'package:flutter/material.dart';
import 'package:food_app_flutter/src/core/constants.dart';

class ExpandedWidget extends StatefulWidget {
  const ExpandedWidget({super.key, required this.text});
  final String text;

  @override
  State<ExpandedWidget> createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget> {
  late String firstHalf;
  late String secondHalf;
  bool flag = true;

  @override
  void initState(){
    super.initState();
    if(widget.text.length > 150){
      firstHalf = widget.text.substring(0, 150);
      secondHalf = widget.text.substring(151, widget.text.length);
    }
    else{
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.length ==""?Text(
        widget.text
      ): Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            flag? firstHalf:widget.text
          ),
          SizedBox (height: 7,),
          InkWell(
            onTap: (){
              setState(() {
                flag = !flag;
              });
            },
            child: Row(
              children: [
                Text (
                  flag?"Show More":"Show Less",
                  style: TextStyle(
                    color: Constants.primaryColor,
                  ),
                ),
                Icon(flag?Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Constants.primaryColor,)
              ],
            ),
          ),
          SizedBox (height: 7,),
        ],
      ),
    );
  }
}