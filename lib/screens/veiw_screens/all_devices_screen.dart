import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/device_details_screen.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/device_item_view.dart';
import 'package:booking_app_client/widgets_model/main_drawer.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllDevicesScreen extends StatelessWidget {
  final TextEditingController? searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      child: Consumer<MainProvider>(
        builder: (context, valueMain, child) => Scaffold(
          appBar: AppBar(
           // centerTitle: true,
            title: valueMain.isSearch.value
                ? Consumer<MainProvider>(
                    builder: (context, valueMain, child) => TextField(
                      autofocus: true,
                      controller: searchController,
                      onChanged: (val) => valueMain.searchFunction(
                          val, valueMain.allDevicesList),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: " Search...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10)),
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Text('All Devices'),
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
              itemBuilder: (context, index) => searchController!.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DeviceDetailsScreen(
                              deviceId: valueMain.searchList[index].id))),
                      child: DeviceItemView(
                          imageUrl: valueMain.searchList[index].imgUrl[0],
                          name: valueMain.searchList[index].name,
                          available: valueMain.searchList[index].isBooked,
                          screenSize: valueMain.searchList[index].screenSize),
                    )
                  : GestureDetector(
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
              itemCount: searchController!.text.isNotEmpty
                  ? valueMain.searchList.length
                  : valueMain.allDevicesList.length,
            ),
          ),
          drawer: MainDrawer(),
        ),
      ),
    );
  }
}
