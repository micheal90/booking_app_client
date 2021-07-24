import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/device_details_screen.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/device_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IosDevicesScreen extends StatelessWidget {
  final TextEditingController? searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, valueMain, child) => Scaffold(
        appBar: AppBar(
          title: valueMain.isSearch.value
              ? Consumer<MainProvider>(
                  builder: (context, valueMain, child) => TextField(
                    autofocus: true,
                    controller: searchController,
                    onChanged: (val) =>
                        valueMain.searchFunction(val, valueMain.iosDevicesList),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: " Search...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10)),
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Text("IOS Devices"),
          actions: [
            IconButton(
                icon: valueMain.isSearch.value
                    ? Icon(Icons.cancel_outlined)
                    : Icon(Icons.search),
                onPressed: () {
                  valueMain.changeIsSearch();
                  searchController!.clear();
                  valueMain.searchList = [];
                })
          ],
          //centerTitle: true,
        ),
        body: valueMain.iosDevicesList.isEmpty
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
            itemBuilder: (context, index) => searchController!.text.isNotEmpty
                ? GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DeviceDetailsScreen(
                            deviceId: valueMain.searchList[index].id))),
                    child: DeviceItemView(
                        imageUrl: valueMain.searchList[index].imgUrl[0],
                        available: valueMain.searchList[index].isBooked,
                        name: valueMain.searchList[index].name,
                        screenSize: valueMain.searchList[index].screenSize),
                  )
                : GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DeviceDetailsScreen(
                            deviceId: valueMain.iosDevicesList[index].id))),
                    child: DeviceItemView(
                        imageUrl: valueMain.iosDevicesList[index].imageUrl[0],
                        available: valueMain.iosDevicesList[index].isBooked,
                        name: valueMain.iosDevicesList[index].name,
                        screenSize: valueMain.iosDevicesList[index].screenSize),
                  ),
            itemCount: searchController!.text.isNotEmpty
                ? valueMain.searchList.length
                : valueMain.iosDevicesList.length,
          ),
        ),
      ),
    );
  }
}
