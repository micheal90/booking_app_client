
class CatergoryModel {
  String name;
  String imageUrl;
  CatergoryModel({
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagUrl': imageUrl,
    };
  }

  factory CatergoryModel.fromMap(Map<String, dynamic> map) {
    return CatergoryModel(
      name: map['name'],
      imageUrl: map['imagUrl'],
    );
  }
}
