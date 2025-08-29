class CheckoutModel {
  String? bookId;
  String? userToken;
  String? name;
  String? email;
  String? androidInvoice;
  String? phone;
  String? passport;
  bool? isBooked;
  bool? isPending;
  bool? isRefused;
  String? location;
  String? hotelId;
  String? categoryName;
  String? categoryLocation;
  String? type;
  String? roomUid;

  String? roomName;
  String? des;
  int? price;
  String? from;
  String? to;
  int? level;

  CheckoutModel({
    required this.name,
     this.roomUid,
   required  this.userToken,
   required  this.categoryName,
   required  this.categoryLocation,
    required this.bookId,
    required this.androidInvoice,
    required this.phone,
    required this.passport,
    required this.isBooked,
    required this.email,
    required this.isPending,
    required this.isRefused,
    required this.location,
    required this.hotelId,
    required this.type,
    required this.roomName,
    required this.des,
    required this.price,
    required this.from,
    required this.to,
    required this.level,
  });

  CheckoutModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    bookId = json['bookId'];
    userToken = json['userToken'];
    androidInvoice = json['androidInvoice'];
    phone = json['phone'];
    passport = json['pasport'];
    isBooked = json['isBooked'];
    categoryName = json['categoryName'];
    categoryLocation = json['categoryLocation'];
    email = json['email'];
    isPending = json['isPending'];
    isRefused = json['isRefused'];
    location = json['location'];
    hotelId = json['hotelId'];
    roomUid = json['roomUid'];
    roomName = json['roomName'];
    des = json['des'];
    price = json['price'];
    type = json['type'];
    from = json['from'];
    to = json['to'];
    level = json['level'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bookId': bookId,
      'userToken': userToken,
      'androidInvoice': androidInvoice,
      'phone': phone,
      'pasport': passport,
      'isBooked': isBooked,
      'categoryName': categoryName,
      'categoryLocation': categoryLocation,
      'email': email,
      'isPending': isPending,
      'isRefused': isRefused,
      'location': location,
      'hotelId': hotelId,
      'roomUid': roomUid,
      'roomName': roomName,
      'des': des,
      'price': price,
      'type': type,
      'from': from,
      'to': to,
      'level': level,
    };
  }
}
