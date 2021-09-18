import 'package:booking_app_client/models/category_model.dart';
import 'package:booking_app_client/models/device_model.dart';
import 'package:booking_app_client/models/reserve_device_model.dart';
import 'package:booking_app_client/sevices/firestore_device.dart';
import 'package:booking_app_client/sevices/firestore_reserve_devices.dart';
import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  // List<DeviceModel> allDevicesList = [
  //   DeviceModel(
  //       id: '1',
  //       name: 'Samsung Note 10',
  //       model: 'Note 10',
  //       os: 'Android Pie',
  //       type: 'Android',
  //       screenSize: '6 inch',
  //       isBooked: false,
  //       battery: '5000 mA',
  //       imageUrl: [
  //         'https://www.mytrendyphone.eu/images/Samsung-Galaxy-Note10-Duos-256GB-Pre-owned-Good-condition-Aura-Black-14042020-01-p.jpg'
  //       ]),
  //   DeviceModel(
  //       id: '2',
  //       name: 'Samsung A50',
  //       model: 'A50',
  //       os: 'Android Pie',
  //       type: 'Android',
  //       isBooked: false,
  //       screenSize: '6 inch',
  //       imageUrl: [
  //         'https://www.mytrendyphone.eu/images/Original-Samsung-Galaxy-A50-Gradation-Cover-EF-AA505CBEGWW-Black-8801643776848-22042019-01-p.jpg'
  //       ],
  //       battery: '5000 mA'),
  //   DeviceModel(
  //       id: '3',
  //       name: 'Iphone X',
  //       model: 'X',
  //       os: 'IOS 10',
  //       type: 'IOS',
  //       isBooked: false,
  //       imageUrl: [
  //         'https://www.mytrendyphone.eu/images/iPhone-X-XS-Fake-Camera-Sticker-Black-05122019-01-p.jpg',
  //         'https://www.tjara.com/wp-content/uploads/2021/04/temp1618662955_1903984948.jpg',
  //         'https://cdn.alloallo.media/catalog/product/apple/iphone/iphone-x/iphone-x-space-gray.jpg'
  //       ],
  //       screenSize: '6 inch',
  //       battery: '5000 mA'),
  //   DeviceModel(
  //       id: '4',
  //       name: 'Iphone 9',
  //       model: '9',
  //       os: 'IOS 9',
  //       type: 'IOS',
  //       isBooked: false,
  //       screenSize: '6 inch',
  //       imageUrl: [
  //         'https://fdn.gsmarena.com/imgroot/news/20/01/iphone-9-renders/-727/gsmarena_005.jpg'
  //       ],
  //       battery: '5000 mA'),
  //   DeviceModel(
  //       id: '5',
  //       name: 'HP 110',
  //       model: '110',
  //       os: 'Windows 10',
  //       type: 'PC',
  //       isBooked: false,
  //       imageUrl: ['https://www.notebookcheck.net/uploads/tx_nbc2/hp110.jpg'],
  //       screenSize: '15 inch',
  //       battery: '5000 mA'),
  //   DeviceModel(
  //       id: '6',
  //       name: 'Lenovo 120',
  //       model: '120',
  //       os: 'Windows 10',
  //       type: 'PC',
  //       isBooked: false,
  //       imageUrl: [
  //         'https://www.notebookcheck.net/uploads/tx_nbc2/1204810_10.jpg'
  //       ],
  //       screenSize: '15 inch',
  //       battery: '5000 mA'),
  // ];
  List<CatergoryModel> categories = [
    CatergoryModel(
        name: 'Android',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/booking-app-d737d.appspot.com/o/categoriesIcons%2Fandroid96.png?alt=media&token=04dfd03d-2494-48f9-95fe-1f1af390f2c7'),
    CatergoryModel(
        name: 'IOS',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/booking-app-d737d.appspot.com/o/categoriesIcons%2Fios-96.png?alt=media&token=9fdeb72c-e35e-4d29-a78e-305361fb0b3d'),
    CatergoryModel(
        name: 'PC',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/booking-app-d737d.appspot.com/o/categoriesIcons%2Fpc-96.png?alt=media&token=30326472-db66-4374-aa8e-153bef4587a7'),
    CatergoryModel(
        name: 'Others',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/booking-app-d737d.appspot.com/o/categoriesIcons%2Fothers-96.png?alt=media&token=b95ea046-d22c-46c5-b782-a17303832320'),
  ];
  List<DeviceModel> allDevicesList = [];
  List<DeviceModel> devicesNotBookedList = [];
  List<DeviceModel> androidDevicesList = [];
  List<DeviceModel> iosDevicesList = [];
  List<DeviceModel> pcDevicesList = [];
  List<DeviceModel> othersDevicesList = [];
  List<ReserveDeviceModel> orderList = [];

  ///list for get all orders of device from database for view to user before book device
  List<ReserveDeviceModel> scheduleOrder = []; //used in my schedule screen
  List<ReserveDeviceModel> reservedDevicesList = [];
  List<ReserveDeviceModel> checkList = [];
  DateTime? startDateTime;
  DateTime? endDateTime;
  List<dynamic> searchList = [];
  ValueNotifier<bool> isSearch = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? userId;

  //firebase services
  FirestoreDevice firestoreDevice = FirestoreDevice();
  FirestorReserveDevices firestorReserveDevices = FirestorReserveDevices();

  Future getDevices() async {
    isLoading.value = true;
    clearAllList(); //reset all lists befor getdevices

    var devices = await firestoreDevice.getDevices();
    //add all devices to allDevicesList after get
    for (var dev in devices) {
      allDevicesList.add(DeviceModel.fromMap(dev.data()));
    }
    print('all device get: ${allDevicesList.length}');

    await checkStartReserveDate();
    await checkEndReserveDate();
    await filterDevices();
    await getReservedDevicesByUserId(userId);
    await getOrderDevResByUserId(userId);
    isLoading.value = false;
    notifyListeners();
  }

  void clearAllList() {
    allDevicesList = [];
    androidDevicesList = [];
    iosDevicesList = [];
    pcDevicesList = [];
    reservedDevicesList = [];
    devicesNotBookedList = [];
    scheduleOrder = [];
    orderList = [];
  }

  Future refreshDevices() async {
    await getDevices();
    notifyListeners();
  }

  Future checkStartReserveDate() async {
    //get all order in orderReseveRef
    var allOrdersReserved = await firestorReserveDevices.getAllOrder();
    checkList = [];
    print('order length: ${allOrdersReserved.length}');
    // check if allOrdersReserved is empty
    if (allOrdersReserved.isEmpty) return;
    //loop in allOrdersReserved and save in checkList
    for (var order in allOrdersReserved) {
      checkList.add(ReserveDeviceModel.fromMap(order.data()));
    }

    print('checkList length:${checkList.length}');
    //check orders in checkList if date now is after start time
    checkList.forEach((order) async {
      //get start an end time for check
      var start = DateTime.parse(order.startDate);
      var end = DateTime.parse(order.endDate);

      if (DateTime.now().isAfter(start) && DateTime.now().isBefore(end)) {
        print(DateTime.now().isAfter(start) && DateTime.now().isBefore(end));
        // add reserve device to database
        ReserveDeviceModel resDevice = ReserveDeviceModel(
            id: order.id,
            deviceName: order.deviceName,
            userId: order.userId,
            type: order.type,
            startDate: order.startDate,
            endDate: order.endDate);
        await firestorReserveDevices.addReserveDevice(resDevice);

        //change key isBooked to true in device and update device
        DeviceModel deviceModel = getDeviceById(order.id);
        await updateBookedDevice(deviceModel, book: true);

        // delete the order reservation from database
        allOrdersReserved.forEach((element) async {
          if (ReserveDeviceModel.fromMap(element.data()).id == deviceModel.id) {
            await firestorReserveDevices.deleteOrderReserved(element.id);
          }
        });
      }
    });
  }

  Future checkEndReserveDate() async {
    //get all docs in orderReseveRef
    await firestorReserveDevices.getAllreservedDevices().then((value) {
      List<ReserveDeviceModel> list = [];
      for (var i in value) {
        list.add(ReserveDeviceModel.fromMap(i.data()));
      }
      //check if found orders
      if (list.isEmpty) return;
      list.forEach((device) async {
        //check if date now is afer the end date in device reserved
        if (DateTime.now().isAfter(DateTime.parse(device.endDate))) {
          await unBookedDevice(device);
        }
      });
    });
  }

  //set start date when user book
  void changeStartDateTime(DateTime date) {
    startDateTime = date;
    notifyListeners();
  }

  //set end date when user book
  void changeEndDateTime(DateTime date) {
    endDateTime = date;
    notifyListeners();
  }

  void changeIsSearch() {
    isSearch.value = !isSearch.value;
    notifyListeners();
  }

  void searchFunction(String val, List list) {
    searchList = list
        .where(
            (element) => element.name.toLowerCase().contains(val.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future filterDevices() async {
    devicesNotBookedList =
        allDevicesList.where((element) => !element.isBooked).toList();
    androidDevicesList = allDevicesList
        .where((element) =>
            (element.type == 'Android' && element.isBooked == false))
        .toList();
    iosDevicesList = allDevicesList
        .where(
            (element) => (element.type == 'IOS' && element.isBooked == false))
        .toList();
    pcDevicesList = allDevicesList
        .where((element) => (element.type == 'PC' && element.isBooked == false))
        .toList();
    othersDevicesList = allDevicesList
        .where((element) =>
            (element.type == 'OTHERS' && element.isBooked == false))
        .toList();
/*
    allDevicesList.forEach((device) {
      //filter devices as booked
      if (device.isBooked == false) {
        var isExest = devicesNotBookedList.indexWhere(
          (element) => element.id == device.id,
        );
        if (isExest == -1) {
          devicesNotBookedList.add(device);
        }
      }

      //filter devices as type
      if (device.type == 'Android' && device.isBooked == false) {
        var isExest = androidDevicesList.indexWhere(
          (element) => element.id == device.id,
        );
        if (isExest == -1) {
          androidDevicesList.add(device);
        }
      } else if (device.type == 'IOS' && device.isBooked == false) {
        var isExest =
            iosDevicesList.indexWhere((element) => element.id == device.id);
        if (isExest == -1) {
          iosDevicesList.add(device);
        }
      } else if (device.type == 'PC' && device.isBooked == false) {
        var isExest =
            pcDevicesList.indexWhere((element) => element.id == device.id);
        if (isExest == -1) {
          pcDevicesList.add(device);
        }
      } else if (device.type == 'OTHERS' && device.isBooked == false) {
        var isExest =
            othersDevicesList.indexWhere((element) => element.id == device.id);
        if (isExest == -1) {
          othersDevicesList.add(device);
        }
      }
    });
    */
  }

  DeviceModel getDeviceById(String id) {
    print('all device id: ${allDevicesList.length}');
    return allDevicesList.firstWhere((device) => device.id == id);
  }

  //get orders of device from database
  Future getOrderResevedDeviceByDeviceId(String id) async {
    isLoading.value = true;
    List<ReserveDeviceModel> list = [];

    var data = await firestorReserveDevices.getAllOrder();
    if (data.isEmpty) {
      isLoading.value = false;
      orderList = [];
    } else {
      data.forEach((element) {
        list.add(ReserveDeviceModel.fromMap(element.data()));
      });
    }
    //return all orders reserved of device
    var devices = list.where((element) => element.id == id).toList();
    isLoading.value = false;
    orderList = devices;
  }

  Future getReservedDevicesByUserId(String? id) async {
    userId = id;

    firestorReserveDevices.getAllreservedDevices().then((value) {
      List<ReserveDeviceModel> list = [];
      for (var i in value) {
        list.add(ReserveDeviceModel.fromMap(i.data()));
      }
      if (list.isEmpty) return;
      list.forEach((device) {
        if (device.userId == userId) {
          var isExest = reservedDevicesList
              .indexWhere((element) => element.id == device.id);
          if (isExest == -1) {
            reservedDevicesList.add(device);
          }
        }
      });
      print(reservedDevicesList.length);
    });

    notifyListeners();
  }

  Future getOrderDevResByUserId(String? userId) async {
    firestorReserveDevices.getAllOrder().then((value) {
      List<ReserveDeviceModel> list = [];
      for (var i in value) {
        list.add(ReserveDeviceModel.fromMap(i.data()));
      }
      if (list.isEmpty) return;
      list.forEach((order) {
        if (order.userId == userId) {
          var isExest = scheduleOrder.indexWhere((element) =>
              element.startDate == order.startDate &&
              element.endDate == order.endDate &&
              element.id == order.id);
          if (isExest == -1) {
            scheduleOrder.add(order);
          }
        }
      });
    });

    notifyListeners();
  }

  Future<bool> checkIfdeviceBooked(String id, String start, String end) async {
    List<ReserveDeviceModel> list = [];

    //get all order from database
    await firestorReserveDevices.getAllreservedDevices().then((value) {
      //check if order is empty
      if (value.isEmpty) return;
      //add all orders to list
      value.forEach((element) {
        list.add(ReserveDeviceModel.fromMap(element.data()));
      });
    });

    if (list.isEmpty) {
      return false;
    } else {
      var startD = DateTime.parse(start);
      var endD = DateTime.parse(end);
      //check if the new reserve device found in list
      var isExit = list.indexWhere((device) => device.id == id);
      if (isExit == -1) return false;
      //get the reserve device from list if found
      // for compare the date if can be reserved
      var device = list.firstWhere((device) => (device.id == id));
      //if startDate new reserved is after the order endDate &&
      //if startDate && the endDate is befor the order stardDate
      if (startD.isAfter(DateTime.parse(device.endDate))) {
        return false;
      } else if ((startD.isBefore(DateTime.parse(device.startDate)) ||
              start.compareTo(device.startDate) == 0) &&
          (endD.isBefore(DateTime.parse(device.startDate)) ||
              end.compareTo(device.startDate) == 0)) {
        return false;
      } else
        return true;
    }
  }

  Future<bool> checkIfDeviceInOrder(String id, String start, String end) async {
    List<ReserveDeviceModel> list = [];

    //get all order from database
    await firestorReserveDevices.getAllOrder().then((value) {
      //check if orders is empty
      if (value.isEmpty) return;
      //add all orders to list
      value.forEach((element) {
        list.add(ReserveDeviceModel.fromMap(element.data()));
      });
    });

    if (list.isEmpty) {
      return false;
    } else {
      var startD = DateTime.parse(start);
      var endD = DateTime.parse(end);
      //check if the new reserve device found in list
      var isExit = list.indexWhere((device) => device.id == id);
      if (isExit == -1) return false;
      //get the reserve device from list if found
      // for compare the date if can be reserved
      var device = list.firstWhere(
        (device) => (device.id == id),
      );
      //if startDate new reserved is after the order endDate &&
      //if startDate && the endDate is befor the order stardDate
      if (startD.isAfter(DateTime.parse(device.endDate))) {
        return false;
      } else if ((startD.isBefore(DateTime.parse(device.startDate)) ||
              start.compareTo(device.startDate) == 0) &&
          (endD.isBefore(DateTime.parse(device.startDate)) ||
              end.compareTo(device.startDate) == 0)) {
        return false;
      } else
        return true;
    }
  }

  Future bookDevice(DeviceModel deviceModel) async {
    ReserveDeviceModel resDevice = ReserveDeviceModel(
        id: deviceModel.id,
        deviceName: deviceModel.name,
        userId: userId!,
        type: deviceModel.type,
        startDate: startDateTime!.toIso8601String(),
        endDate: endDateTime!
            .add(Duration(hours: 23, minutes: 59))
            .toIso8601String());
    //Check if a reserved device is found
    bool isFoundInReservedDevices = await checkIfdeviceBooked(
        resDevice.id, resDevice.startDate, resDevice.endDate);
    bool isFoundInOrderReservedDevices = await checkIfDeviceInOrder(
        resDevice.id, resDevice.startDate, resDevice.endDate);
    print('found in order: $isFoundInOrderReservedDevices');
    print('found in reserved: $isFoundInReservedDevices');

    if (isFoundInOrderReservedDevices) {
      return 'The device cannot be reserved on this date';
    } else {
      // add reserve device to database
      if (isFoundInReservedDevices) {
        return 'The device cannot be reserved on this date';
      }
      if (DateTime.now().isAfter(startDateTime!)) {
        await firestorReserveDevices.addReserveDevice(resDevice);
        await updateBookedDevice(deviceModel, book: true);
      } else {
        await firestorReserveDevices.addOrderReserve(resDevice);
      }
    }

    await getDevices();
    startDateTime = null;
    endDateTime = null;
    notifyListeners();
  }

  Future updateBookedDevice(DeviceModel deviceModel, {bool? book}) async {
    DeviceModel updatedDevice = DeviceModel(
        id: deviceModel.id,
        name: deviceModel.name,
        model: deviceModel.model,
        os: deviceModel.os,
        type: deviceModel.type,
        isBooked: book!,
        screenSize: deviceModel.screenSize,
        battery: deviceModel.battery,
        imageUrl: deviceModel.imageUrl);
    await firestoreDevice.updateDevice(deviceModel: updatedDevice);
  }

  Future unBookedDevice(ReserveDeviceModel reserveDeviceModel) async {
    isLoading.value = true;

    var deviceModel = allDevicesList //get deviceModel from reservation id
        .firstWhere((element) => element.id == reserveDeviceModel.id);

    //remove reseved divice from database
    await firestorReserveDevices.getAllreservedDevices().then((value) async {
      for (var i in value) {
        if (ReserveDeviceModel.fromMap(i.data()).id == reserveDeviceModel.id) {
          await firestorReserveDevices.deleteReservedDevice(i.id);
        }
      }
    });

    await updateBookedDevice(deviceModel, book: false);
    await getReservedDevicesByUserId(userId);
    print(reservedDevicesList.length);
    isLoading.value = false;
    notifyListeners();
  }

  Future deleteOrderReservation(ReserveDeviceModel reserveDeviceModel) async {
    isLoading.value = true;
    List<ReserveDeviceModel> list = [];

    var orders = await firestorReserveDevices.getAllOrder();
    if (orders.isEmpty) return;
    orders.forEach((order) async {
      list.add(
          ReserveDeviceModel.fromMap(order.data() as Map<String, dynamic>));
      var deviceRes =
          ReserveDeviceModel.fromMap(order.data() as Map<String, dynamic>);
      if (deviceRes.id == reserveDeviceModel.id &&
          (deviceRes.startDate == reserveDeviceModel.startDate &&
              deviceRes.endDate == reserveDeviceModel.endDate))
        await firestorReserveDevices.deleteOrderReserved(order.id);
    });
    await getDevices();
    await getOrderResevedDeviceByDeviceId(userId!);
    print(scheduleOrder.length);
    isLoading.value = false;
    notifyListeners();
  }
}
