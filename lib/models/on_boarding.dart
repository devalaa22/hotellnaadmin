class OnBoardingModel {
  String? onboardingUid;
  String? title;
  String? subTitle;
  String? imageUrl;

  OnBoardingModel(
      {required this.subTitle, required this.title, required this.imageUrl});

  OnBoardingModel.fromJson(Map<String, dynamic>? json) {
    subTitle = json!['subTitle'];
    onboardingUid = json['uid'];
    title = json['title'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'subTitle': subTitle,
      'title': title,
      'uid': onboardingUid,
      'imageUrl': imageUrl,
    };
  }
}
