import 'package:booking_app_client/models/device_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDevice {
  CollectionReference _deviceCollectionRef =
      FirebaseFirestore.instance.collection('devices');

  Future getDevices() async {
    var value = await _deviceCollectionRef.get();
    return value.docs;
  }

  //used when add new device
  Future<String> getDocId() async {
    return _deviceCollectionRef.doc().id;
  }

  Future addDevice(DeviceModel deviceModel, deviceId) async {
    await _deviceCollectionRef.doc(deviceId).set(deviceModel.toMap());
  }

  Future updateDevice({
    // String? deviceId,
    // String? deviceName,
    // String? model,
    // String? type,
    // String? os,
    // bool? isBooked,
    // String? screenSize,
    // String? battery,
    // List<String>? imageUrls,
   required DeviceModel deviceModel,
  }) async {
    await _deviceCollectionRef.doc(deviceModel.id).update({
      'id': deviceModel.id,
      'name': deviceModel.name,
      'model': deviceModel.model,
      'os': deviceModel.os,
      'type': deviceModel.type,
      'isBooked': deviceModel.isBooked,
      'screenSize': deviceModel.screenSize,
      'battery': deviceModel.battery,
      'imageUrl': deviceModel.imageUrl,
    });
  }

  Future deleteDevice(String deviceId) async {
    await _deviceCollectionRef.doc(deviceId).delete();
  }
}
