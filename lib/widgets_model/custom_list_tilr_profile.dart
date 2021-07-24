import 'package:flutter/material.dart';

import 'package:booking_app_client/widgets_model/custom_text.dart';

class CustomListTileProfile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget? trailing;
  final Color titleColor;
  final Color subtitleColor;
  const CustomListTileProfile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.leading,
    this.trailing,
    this.titleColor = Colors.grey,
    this.subtitleColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: CustomText(
        text: title,
        color: titleColor,
      ),
      subtitle: CustomText(
        text: subtitle,
        color: subtitleColor,
      ),
      trailing: trailing,
    );
  }
}
