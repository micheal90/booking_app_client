
class ReserveDeviceModel {
  String id;
  String deviceName;
  String userId;
  String type;
  String startDate;
  String endDate;
  ReserveDeviceModel({
    required this.id,
    required this.deviceName,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceName': deviceName,
      'userId': userId,
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory ReserveDeviceModel.fromMap(Map<String, dynamic> map) {
    return ReserveDeviceModel(
      id: map['id'],
      deviceName: map['deviceName'],
      userId: map['userId'],
      type: map['type'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

}
