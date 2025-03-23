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
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          color: isSelected ? Colors.blue : Colors.white,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
