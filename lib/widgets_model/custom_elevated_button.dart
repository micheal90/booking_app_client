
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_text.dart';




class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;

  const CustomElevatedButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomText(
          text: text,
          alignment: Alignment.center,
          color: Colors.white,
        ),
      ),
      
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),)),
        backgroundColor: MaterialStateProperty.all(KPrimaryColor),
        
      ),
    );
  }
}
