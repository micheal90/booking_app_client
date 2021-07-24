import 'package:flutter/material.dart';

import 'custom_text.dart';


class CategoryWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  CategoryWidget({
    required this.text,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          height: 50,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey.shade200, borderRadius: BorderRadius.circular(50)),
          child: Image.network(imageUrl),
        ),
        SizedBox(
          height: 5,
        ),
        CustomText(
          text: text,
        )
      ],
    );
  }
}
