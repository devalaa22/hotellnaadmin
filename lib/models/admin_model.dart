class AdminModel {
  String? email;
  String? adminUid;
  String? fcmToken;
  String? password;
  String? name;
  String? type;

  AdminModel({
    this.password,
    this.email,
    this.adminUid,
    this.fcmToken ,
    this.name,
    this.type,
  });

  AdminModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    password = json['password'];
    fcmToken = json['fcmToken'];
    adminUid = json['uid'];
    type = json['category'];
    name = json['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'uid': adminUid,
      'fcmToken': fcmToken??'',
      'email': email,
      'category': type,
      'name': name,
    };
  }
}
