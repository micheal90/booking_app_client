import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Function()? onTap;
  const CustomListTile({
    Key? key,
    this.leading,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      onTap: onTap,
      subtitle: CustomText(
      ),
      title: CustomText(
        text: title,
      ),
    );
  }
}
