import 'package:booking_app_client/models/reserve_device_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorReserveDevices {
  CollectionReference _reservedCollectionRef =
      FirebaseFirestore.instance.collection('reservedDevices');
  CollectionReference _ordersCollectionRef =
      FirebaseFirestore.instance.collection('orderReservedDevices');

  Future getAllreservedDevices() async {
    var reserved = await _reservedCollectionRef.get();
    return reserved.docs;
  }

  Future getAllOrder() async {
    var orders = await _ordersCollectionRef.get();
    return orders.docs;
  }

  Future addReserveDevice(ReserveDeviceModel reserveDeviceModel) async {
    await _reservedCollectionRef.add(reserveDeviceModel.toMap());
  }
  Future addOrderReserve(ReserveDeviceModel reserveDeviceModel) async {
    await _ordersCollectionRef.add(reserveDeviceModel.toMap());
  }

  Future deleteOrderReserved(String orderId) async {
    await _ordersCollectionRef.doc(orderId).delete();
  }
  Future deleteReservedDevice(String resvId) async {
    await _reservedCollectionRef.doc(resvId).delete();
  }
}
