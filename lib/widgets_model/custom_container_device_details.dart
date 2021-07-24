import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_text.dart';



class CustomContainerDeviceDetail extends StatelessWidget {
  final String title;
  final String detail;
  const CustomContainerDeviceDetail({
    Key? key,
    required this.title,
    required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomText(
            text: title,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KPrimaryColor,
          ),
          Spacer(),
          CustomText(
            text: detail,
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}
