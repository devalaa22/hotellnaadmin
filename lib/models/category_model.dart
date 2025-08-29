class CategoryModel {
  String? thisCategoryUid;
  String? name;
  String? type;
  String? adminUid; 
  String? bank;
  String? imgAssetPath;
  String? about;
  String? facebook;
  String? whatsapp;
  String? callNumber;
  String? from;
  String? to;
  bool? isBooked;
  bool? isOffer;
  int? newPrice;
  int? oldPrice;
  String? location;
  List<dynamic>? servicesChecked;

  CategoryModel({
    required this.thisCategoryUid,
    required this.name,
    required this.adminUid, 
    required this.type,
    required this.imgAssetPath,
    required this.callNumber,
    required this.about,
    required this.facebook,
    required this.bank,
    required this.isOffer,
    required this.whatsapp,
    this.from,
    this.to,
    this.isBooked,
    this.newPrice,
    this.oldPrice,
    required this.location,
    required this.servicesChecked,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': thisCategoryUid,
      'adminUid': adminUid, 
      'name': name,
      'type': type,
      'callNumber': callNumber,
      'imgAssetPath': imgAssetPath,
      'about': about,
      'facebook': facebook,
      'whatsapp': whatsapp,
      'isOffer': isOffer,
      'bank': bank,
      'from': from,
      'to': to,
      'isBooked': isBooked,
      'newPrice': newPrice,
      'oldPrice': oldPrice,
      'location': location,
      'servicesChecked': servicesChecked,
    };
  }

  CategoryModel.fromJson(Map<String, dynamic> json) {
    thisCategoryUid = json['uid'];
    adminUid = json['adminUid']; 
    name = json['name'];
    type = json['type'];
    imgAssetPath = json['imgAssetPath'];
    about = json['about'];
    callNumber = json['callNumber'];
    facebook = json['facebook'];
    bank = json['bank'];
    isOffer = json['isOffer'];
    whatsapp = json['whatsapp'];
    from = json['from'];
    to = json['to'];

    isBooked = json['isBooked'];
    newPrice = json['newPrice']?.toInt();
    oldPrice = json['oldPrice']?.toInt();
    location = json['location'];
    if (json['servicesChecked'] != null) {
      servicesChecked = List<dynamic>.from(json['servicesChecked']);
    } else {
      null;
    }
  }
}
