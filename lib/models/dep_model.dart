class DepModel {
  List<dynamic>? img;

  DepModel({
    required this.img,
  });

  DepModel.fromJson(Map<String, dynamic>? json) {
    img = json!['img'];
  }

  Map<String, dynamic> toMap() {
    return {
      'img': img,
    };
  }
}
