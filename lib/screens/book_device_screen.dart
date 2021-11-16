import 'package:booking_app_client/models/device_model.dart';
import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/home_screen.dart';
import 'package:booking_app_client/widgets_model/custom_elevated_button.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class BookDeviceScreen extends StatefulWidget {
  final String deviceId;

  BookDeviceScreen({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  _BookDeviceScreenState createState() => _BookDeviceScreenState();
}

class _BookDeviceScreenState extends State<BookDeviceScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();
  late DeviceModel deviceModel;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    deviceModel = Provider.of<MainProvider>(context, listen: false)
        .getDeviceById(widget.deviceId);
  }

  void bookDevice(BuildContext context, MainProvider value) async {
    if (value.startDateTime == null ||
        value.endDateTime == null ||
        value.endDateTime!.isBefore(value.startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a valid date'.tr),
        backgroundColor: Colors.black54,
      ));
    } else {
      setState(() {
        isLoading = true;
      });
      await Provider.of<MainProvider>(context, listen: false)
          .bookDevice(deviceModel)
          .then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.toString()),
            backgroundColor: Colors.black54,
          ));
          setState(() {
            isLoading = false;
          });
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The device is booked'.tr),
            backgroundColor: Colors.black54,
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 275,
            //backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                deviceModel.name,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              background: CarouselSlider.builder(
                  itemCount: deviceModel.imageUrl.length,
                  itemBuilder: (context, index, realIndex) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/loading.png'),
                          image: NetworkImage(
                            deviceModel.imageUrl[index],
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                  options: CarouselOptions(
                    aspectRatio: 1,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: deviceModel.imageUrl.length > 1 ? true : false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([buildBody()]))
        ],
      ),
    );
  }

  Consumer<MainProvider> buildBody() {
    return Consumer<MainProvider>(
      builder: (context, valueMain, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                CustomText(
                  text: deviceModel.name,
                  fontSize: 20,
                  color: KPrimaryColor,
                ),
                CustomText(
                  text: 'Type: '.tr + deviceModel.type,
                  color: Colors.grey,
                ),
                CustomText(
                  text: 'Model: '.tr + deviceModel.model,
                  color: Colors.grey,
                ),
                CustomText(
                  text: 'OS: '.tr + deviceModel.os,
                  color: Colors.grey,
                ),
                CustomText(
                  text: 'ScreenSize: '.tr + deviceModel.screenSize,
                  color: Colors.grey,
                ),
                CustomText(
                  text: 'Battery: '.tr + deviceModel.battery,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomText(
              text: 'Device Reservation Schedule'.tr,
              fontSize: 18,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: CustomText(
                    text: 'Device'.tr,
                    color: KPrimaryColor,
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: CustomText(
                    text: 'From'.tr,
                    color: KPrimaryColor,
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: CustomText(
                    text: 'To'.tr,
                    color: KPrimaryColor,
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
          buildListView(valueMain),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    onPressed: () => showDatePicker(
                                context: context,
                                initialDate: valueMain.startDateTime == null
                                    ? DateTime.now()
                                    : valueMain.startDateTime!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050))
                            .then((date) {
                          if (date == null) return;
                          valueMain.changeStartDateTime(date);
                        }),
                    icon: Icon(Icons.date_range),
                    label: CustomText(
                      text: 'From'.tr ,
                    )),
                CustomText(
                    color: KPrimaryColor,
                    text: valueMain.startDateTime == null
                        ? ''
                        : DateFormat()
                            .add_yMd()
                            .format(valueMain.startDateTime!)
                            .toString())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    onPressed: () => showDatePicker(
                                context: context,
                                initialDate: valueMain.endDateTime == null
                                    ? DateTime.now()
                                    : valueMain.endDateTime!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050))
                            .then((date) {
                          if (date == null) return;
                          valueMain.changeEndDateTime(date);
                        }),
                    icon: Icon(Icons.date_range),
                    label: CustomText(
                      text: 'To'.tr,
                    )),
                CustomText(
                    color: KPrimaryColor,
                    text: valueMain.endDateTime == null
                        ? ''
                        : DateFormat()
                            .add_yMd()
                            .format(valueMain.endDateTime!)
                            .toString())
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : CustomElevatedButton(
                          text: 'Book'.tr,
                          onPressed: () => bookDevice(context, valueMain),
                        ),
                ),
                SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Container buildListView(MainProvider valueMain) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(),
      ),
      child: valueMain.orderList.isEmpty
          ? Center(
              child: CustomText(
                alignment: Alignment.center,
                text: 'There is no reservation for this device yet'.tr,
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: CustomText(
                      maxLines: 2,
                      text: valueMain.orderList[index].deviceName,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: CustomText(
                      text: DateFormat.yMd().format(
                          DateTime.parse(valueMain.orderList[index].startDate)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: CustomText(
                      text: DateFormat.yMd().format(
                          DateTime.parse(valueMain.orderList[index].endDate)),
                    ),
                  )
                ],
              ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: valueMain.orderList.length,
            ),
    );
  }
}
