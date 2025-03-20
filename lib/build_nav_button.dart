import 'package:flutter/material.dart';

Widget buildNavButton(
  BuildContext context,
  String imagePath,
  Widget page,
  Type currentPageType,
) {
  bool isSelected = page.runtimeType == currentPageType;

  return InkWell(
    onTap: () {
      if (!isSelected) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      }
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          color: isSelected ? Colors.blue : null,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
