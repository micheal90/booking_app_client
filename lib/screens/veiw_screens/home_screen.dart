import 'dart:async';

import 'package:booking_app_client/providers/main_provider.dart';
import 'package:booking_app_client/screens/veiw_screens/android_devices_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/device_details_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/ios_devices_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/others_devices_screen.dart';
import 'package:booking_app_client/screens/veiw_screens/pc_devices_screen.dart';
import 'package:booking_app_client/widgets_model/custom_text.dart';
import 'package:booking_app_client/widgets_model/device_item_view.dart';
import 'package:booking_app_client/widgets_model/gatecory_widget.dart';
import 'package:booking_app_client/widgets_model/main_drawer.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController? searchController = TextEditingController();
  Timer? timer;
  @override
  void initState() {
    Provider.of<MainProvider>(context, listen: false).getDevices();

    super.initState();
  }

  // @override
  // void didChangeDependencies() async{
  //    const oneSecond = const Duration(seconds: 5);
  //   timer = Timer.periodic(oneSecond, (Timer t) async=>await Provider.of<MainProvider>(context, listen: false).refreshDevices());
  //   //await Provider.of<MainProvider>(context, listen: false).refreshDevices();
  //   super.didChangeDependencies();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer!.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
          child: RefreshIndicator(
        onRefresh: () async =>
            await Provider.of<MainProvider>(context, listen: false)
                .refreshDevices(),
        child: Consumer<MainProvider>(
          builder: (context, valueMain, child) => Scaffold(
              appBar: AppBar(
                //centerTitle: true,
                title: valueMain.isSearch.value
                    ? TextField(
                        autofocus: true,
                        controller: searchController,
                        onChanged: (val) => valueMain.searchFunction(
                            val, valueMain.devicesNotBookedList),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: " Search...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10)),
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                      )
                    : Text("Booking App Employee"),
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
              body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    CustomText(
                      text: 'Categories',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AndroidDevicesScreen())),
                          child: CategoryWidget(
                            text: valueMain.categories[0].name,
                            imageUrl: valueMain.categories[0].imageUrl,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => IosDevicesScreen())),
                          child: CategoryWidget(
                            text: valueMain.categories[1].name,
                            imageUrl: valueMain.categories[1].imageUrl,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PcDevicesScreen())),
                          child: CategoryWidget(
                            text: valueMain.categories[2].name,
                            imageUrl: valueMain.categories[2].imageUrl,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => OthersDevicesScreen())),
                          child: CategoryWidget(
                            text: valueMain.categories[3].name,
                            imageUrl: valueMain.categories[3].imageUrl,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: 'Recent Add',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: valueMain.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : buildGridView(valueMain),
                    )
                  ])),
              drawer: MainDrawer()),
        ),
      ),
    );
  }

  ListView buildListView(MainProvider value) {
    return ListView.builder(
      itemCount: value.devicesNotBookedList.length,
      itemBuilder: (context, index) => Container(
        width: 150,
        height: 200,
        child: DeviceItemView(
            imageUrl: value.devicesNotBookedList[index].imageUrl[0],
            name: value.devicesNotBookedList[index].name,
            screenSize: value.devicesNotBookedList[index].screenSize),
      ),
    );
  }

  GridView buildGridView(MainProvider value) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          //mainAxisExtent: 200,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) => searchController!.text.isNotEmpty
          ? GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DeviceDetailsScreen(
                      deviceId: value.searchList[index].id))),
              child: DeviceItemView(
                  imageUrl: value.searchList[index].imgUrl[0],
                  name: value.searchList[index].name,
                  available: value.searchList[index].isBooked,
                  screenSize: value.searchList[index].screenSize),
            )
          : GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DeviceDetailsScreen(
                      deviceId: value.devicesNotBookedList[index].id))),
              child: DeviceItemView(
                  imageUrl: value.devicesNotBookedList[index].imageUrl[0],
                  name: value.devicesNotBookedList[index].name,
                  available: value.devicesNotBookedList[index].isBooked,
                  screenSize: value.devicesNotBookedList[index].screenSize),
            ),
      itemCount: searchController!.text.isNotEmpty
          ? value.searchList.length
          : value.devicesNotBookedList.length,
    );
  }
}
