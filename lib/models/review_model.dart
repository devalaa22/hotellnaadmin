class ReviewModel {
  String? categoriId;
  String? userId;
  String? name;
  String? comment;
  String? dateTime;
  String? rating;

  ReviewModel({
    required this.categoriId,
    required this.userId,
    required this.name,
    required this.comment,
    required this.dateTime,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoriId': categoriId,
      'userId': userId,
      'name': name,
      'comment': comment,
      'dateTime': dateTime,
      'rating': rating,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> map) {
    return ReviewModel(
      categoriId: map['categoriId'],
      userId: map['userId'],
      name: map['name'],
      comment: map['comment'],
      dateTime: map['dateTime'],
      rating: map['rating'],
    );
  }
}
