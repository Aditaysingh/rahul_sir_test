class UserModel {
  int? id;
  String title;
  String? description;
  String? image;

  UserModel({this.id, required this.title, this.description, this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
    );
  }
}
