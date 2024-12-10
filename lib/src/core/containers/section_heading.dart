import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle = 'View all',
    required this.title,
    this.showActionButton = true,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
            maxLines: 3, // Allow up to 3 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
          ),
        ),
        if(showActionButton) TextButton(onPressed: onPressed, child: Text(buttonTitle),)
      ],
    );
  }
}