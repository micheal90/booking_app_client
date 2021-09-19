import 'package:booking_app_client/models/search_models/search_devices.dart';
import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/device_details_screen.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/device_item_view.dart';
import 'package:booking_app_client/widgets_model/main_drawer.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      child: Consumer<MainProvider>(
        builder: (context, valueMain, child) => Scaffold(
          appBar: AppBar(
            // centerTitle: true,
            title: Text('All Devices'),
            actions: [
              IconButton(
                  icon: valueMain.isSearch.value
                      ? Icon(Icons.cancel_outlined)
                      : Icon(Icons.search),
                  onPressed: () =>
                      showSearch(context: context, delegate: SearchDevices()))
            ],
          ),
          body: valueMain.allDevicesList.isEmpty
              ? Center(
                  child: CustomText(
                    text: 'No devices',
                    alignment: Alignment.center,
                    fontSize: 22,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 200,
                        mainAxisSpacing: 10),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DeviceDetailsScreen(
                              deviceId: valueMain.allDevicesList[index].id))),
                      child: DeviceItemView(
                          imageUrl: valueMain.allDevicesList[index].imageUrl[0],
                          available: valueMain.allDevicesList[index].isBooked,
                          name: valueMain.allDevicesList[index].name,
                          screenSize:
                              valueMain.allDevicesList[index].screenSize),
                    ),
                    itemCount: valueMain.allDevicesList.length,
                  ),
                ),
          drawer: MainDrawer(),
        ),
      ),
    );
  }
}
