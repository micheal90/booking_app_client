import 'package:flutter/material.dart';

import 'custom_text.dart';

class DeviceItemView extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String screenSize;
  final bool? available;
  DeviceItemView({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.screenSize,
    this.available,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: GridTile(
          child: FadeInImage(
            placeholder: AssetImage('assets/images/loading.png'),
            image: NetworkImage(
              imageUrl,
            ),
            imageErrorBuilder: (context, error, stackTrace) =>
                Icon(Icons.error),
            fit: BoxFit.fill,
          ),
          footer: GridTileBar(
              backgroundColor: Colors.black26,
              title: CustomText(
                color: Colors.white,
                text: name,
              ),
              subtitle: CustomText(
                color: Colors.white,
                text: screenSize,
              ),
              trailing: available!
                  ? buildStatus(Colors.red)
                  : buildStatus(Colors.green)),
        ));
  }

  Column buildStatus(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Status',
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ],
    );
  }
}
