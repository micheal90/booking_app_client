import 'dart:convert';


class DeviceModel {
  String id;
  String name;
  String model;
  String os;
  String type;
  bool isBooked;
  String screenSize;
  String battery;
  List<String> imageUrl;
  DeviceModel({
    required this.id,
    required this.name,
    required this.model,
    required this.os,
    required this.type,
    required this.isBooked,
    required this.screenSize,
    required this.battery,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'os': os,
      'type': type,
      'isBooked': isBooked,
      'screenSize': screenSize,
      'battery': battery,
      'imageUrl': imageUrl,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'],
      name: map['name'],
      model: map['model'],
      os: map['os'],
      type: map['type'],
      isBooked: map['isBooked'],
      screenSize: map['screenSize'],
      battery: map['battery'],
      imageUrl: List<String>.from(map['imageUrl']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromJson(String source) => DeviceModel.fromMap(json.decode(source));
}
