import 'package:flutter/material.dart';

import 'package:booking_app_client/widgets_model/custom_text.dart';

import '../constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onPressedYes;
  final Function() onPressedNo;
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressedYes,
    required this.onPressedNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        text: title,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: content,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: onPressedNo,
                  child: CustomText(text: 'No', color: KPrimaryColor)),
              TextButton(
                  onPressed: onPressedYes,
                  child: CustomText(text: 'Yes', color: KPrimaryColor)),
            ],
          )
        ],
      ),
    );
  }
}
