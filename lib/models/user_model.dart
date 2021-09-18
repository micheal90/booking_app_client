class EmployeeModel {
  String id;
  String name;
  String lastName;
  String occupationGroup;
  String email;
  String imageUrl;
  String phone;
  EmployeeModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.occupationGroup,
    required this.email,
    required this.imageUrl,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'occupationGroup': occupationGroup,
      'email': email,
      'imageUrl': imageUrl,
      'phone': phone,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'],
      lastName: map['lastName'],
      occupationGroup: map['occupationGroup'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      phone: map['phone'],
    );
  }
}
