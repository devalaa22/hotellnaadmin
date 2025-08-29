class RoomModel {
  String? name;
  List<dynamic>? roomImage;
  String? des;
  bool? isBooked;
  bool? isPending; 
  bool? isRefused;
  int? level; 
  int? newPrice;
  int? oldPrice;
  String? from;
  String? adminUid;
  String? categoryLocation;
  String? to;
  String? roomId; 
  String? bank;
  String? type;
  String? hotelId;
  String? hotelName;  

  RoomModel({
    required this.name,
    required this.des,
    required this.adminUid,
    required this.categoryLocation,
    required this.roomImage,
    required this.bank,
    required this.level,
    required this.isBooked,  
    required this.newPrice,
    required this.oldPrice,
    required this.from,
    required this.to,
    required this.roomId,
    required this.type,
    required this.hotelId,
    required this.isPending,
    required this.isRefused,
    required this.hotelName, 
  });

  RoomModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    des = json['des'];
    adminUid = json['adminUid']; 
    categoryLocation = json['categoryLocation']; 
    roomImage = json['roomImage']; 
    level = json['level'];
    bank = json['bank'];
    isBooked = json['isBooked'];
    newPrice = json['newPrice'];
    oldPrice = json['oldPrice'];
    from = json['from'];
    to = json['to'];
    roomId = json['roomId'];
    type = json['type'];
    hotelId = json['hotelId']; 
    isPending = json['isPending'];
    isRefused = json['isRefused'];
    hotelName = json['hotelName']; 

  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'des': des,
      'adminUid': adminUid,
      'categoryLocation': categoryLocation,
      'roomImage': roomImage,
      'level': level,
      'bank': bank,
      'isBooked': isBooked,
      'isPending': isPending,
      'isRefused': isRefused, 
      'newPrice': newPrice,
      'oldPrice': oldPrice,
      'from': from,
      'to': to,
      'type': type,
      'roomId': roomId,
      'hotelId': hotelId,
      'hotelName': hotelName, 
    };
  }
}
