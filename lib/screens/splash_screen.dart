import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.3,
            // ),
            Expanded(
              flex: 1,
              child: Container(),
            ),

            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icon/icon.png',
                      height: 150,
                      width: 150,
                    ),
                    CustomText(
                      text: 'Booking App\nEmployee',
                      alignment: Alignment.center,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            Expanded(
              flex: 1,
              child: CustomText(
                text: 'Developed by Micheal Hana',
                alignment: Alignment.center,
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
