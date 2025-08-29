import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:image_picker/image_picker.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(InitUserState());

  static AdminCubit get(context) => BlocProvider.of(context);

  bool isOffer = false;
  setIsOffer() {
    isOffer = !isOffer;
    emit(SetIsOfferState());
  }
  // change index of check box

  final List<String> texts = [
    "تأجير السيارات",
    "إنترنت مجاني",
    "إنترنت برسوم",
    "غسيل وكي",
    "مطعم",
    "إفطار مجاني",
    "استقبال 24 ساعة",
    "خدمة الغرف",
    "مسبح",
    "حديقة",
    "ثلاجات صغيرة",
    "مراوح",
    "تكييف",
    "مصفف شعر",
    "فرش ضافي مجانا",
    "بقالة",
    "فرش إضافي برسوم",
    "مصعد",
    "كفتيريا",
    "صالة اجتماعات",
    "قاعة فعاليات",
    "غرف للمدخنين",
    "غرف لغير للمدخنين",
    "امن 24 ساعة",
    "مطل على البحر",
    "القنوات الرياضية",
    "كاميرات في الأماكن العامة",
    "خدمة السفريات والسياحة",
    "معدات السلامة من الحريق",
  ];
  int checkBoxIndex = 0;
  List<dynamic> servicesChecked = [];
  void changeCheckBox(bool value, String dataName) {
    if (value == true) {
      servicesChecked.add(dataName);
      emit(ChangeAddCheckBoxState());
    } else {
      servicesChecked.remove(dataName);
      emit(ChangeRemoveCheckBoxState());
    }
  }

  List offersList = [];
  AdminModel? adminModel;
  List<CategoryModel>? categoryModel;
  int categoryIndex = 0;
  CategoryModel? thisCategoryModel;
  setCategoryModel({required CategoryModel categoryModel, required int index}) {
    categoryIndex = index;
    thisCategoryUid = categoryModel.thisCategoryUid;
    CacheHelper.saveData(key: 'thisCategoryUid', value: thisCategoryUid);
    thisCategoryModel = null;
    thisCategoryModel = categoryModel;
    emit(SetCategoryModelState());
  }

  var nameWithHotel = type == 'hotels'
      ? 'فندق'
      : type == 'floors'
          ? 'شقة'
          : 'قاعة';

  var name = type == 'hotels'
      ? 'غرفة'
      : type == 'floors'
          ? 'شقة'
          : 'قاعة';

  getNames() {
    nameWithHotel = type == 'hotels'
        ? 'فندق'
        : type == 'floors'
            ? 'شقة'
            : 'قاعة';
    name = type == 'hotels'
        ? 'غرفة'
        : type == 'floors'
            ? 'شقة'
            : 'قاعة';

    emit(SetNameState());
  }

  Future<void> getAdminData() async {
    emit(UserLoadingState());

    FirebaseFirestore.instance
        .collection('admin')
        .doc(adminUid)
        .snapshots()
        .listen((event) {
      adminModel = null;

      if (event.exists) {
        adminModel = AdminModel.fromJson(event.data());
        adminUid = adminModel!.adminUid;
        CacheHelper.saveData(key: 'adminUid', value: adminModel!.adminUid);

        type = adminModel!.type;
        CacheHelper.saveData(key: 'type', value: adminModel!.type);
        emit(UserSuccessState());
      } else {
        emit(UserErrorState());
      }
    });
  }

  getMyCategory() async {
    emit(UserLoadingState());

    var myCategoryCollection = FirebaseFirestore.instance
        .collection(type!)
        .where('adminUid', isEqualTo: adminUid);
    await FirebaseFirestore.instance
        .collection("admin")
        .doc(adminUid)
        .update({
          "fcmToken":myToken
        });

    myCategoryCollection.snapshots().listen((event) {
      categoryModel = [];
      for (var item in event.docs) {
        categoryModel!.add(CategoryModel.fromJson(item.data()));

        setCategoryModel(
            categoryModel: thisCategoryModel ?? categoryModel![categoryIndex],
            index: categoryIndex);

        emit(UserSuccessState());
      }
    });
  }

// rating function
  List<ReviewModel> thisReviews = [];
  double getRating({required List<ReviewModel> thisReviews}) {
    if (thisReviews.isEmpty) {
      return 5;
    } else {
      var newlist =
          thisReviews.map((e) => double.parse(e.rating.toString())).toList();
      double result =
          newlist.map((m) => m).reduce((a, b) => a + b) / newlist.length;

      return result;
    }
  }

  Future<void> addHotelRoom({
    required String name,
    required String des,
    required String from,
    required String bank,
    required String hotelName,
    required String to,
    required int newPrice,
    required int oldPrice,
    required int level,
    required List<dynamic> roomImage,
  }) async {
    var roomDoc = FirebaseFirestore.instance
        .collection('hotels')
        .doc(thisCategoryUid)
        .collection('rooms')
        .doc();
    RoomModel roomModel = RoomModel(
      adminUid: adminUid, 
      name: name,
      des: des,
      type: type,
      roomImage: roomImage,
      level: level,
      isBooked: false,
      newPrice: newPrice,
      oldPrice: oldPrice,
      from: from,
      to: to,
      roomId: roomDoc.id,
      hotelId: thisCategoryUid,
      isPending: false,
      isRefused: false,
      hotelName: hotelName,
      bank: bank,
      categoryLocation: thisCategoryModel!.location ?? '',
    );

    await roomDoc.set(roomModel.toMap()).then((value) {
      uploading = false;
      images.clear();
      imageUrl.clear();
      emit(AddRoomSuccessState());
    }).catchError((error) {
      emit(AddRoomErrorState());
    });
  }

  void updateHotelRoom({
    required bool isCopy,
    required String name,
    required String des,
    required String from,
    required String bank,
    required String hotelName,
    required String to,
    required String roomId,
    required int newPrice,
    required int oldPrice,
    required int level,
    required List<dynamic> roomImage,
  }) async {
    
    var roomDoc = FirebaseFirestore.instance
        .collection('hotels')
        .doc(thisCategoryUid)
        .collection('rooms')
        .doc(roomId);
    var copyRoomDoc = FirebaseFirestore.instance
        .collection('hotels')
        .doc(thisCategoryUid)
        .collection('rooms')
        .doc( );
    RoomModel roomModel = RoomModel(
      adminUid: adminUid,
      categoryLocation: thisCategoryModel!.location ?? '',
    
      name: name,
      des: des,
      type: type,
      roomImage: roomImage,
      level: level,
      isBooked: false,
      newPrice: newPrice,
      oldPrice: oldPrice,
      from: from,
      to: to,
      roomId:isCopy?copyRoomDoc.id: roomId,
      hotelId: thisCategoryUid,
      isPending: false,
      isRefused: false,
      hotelName: hotelName,
      bank: bank,
    );
isCopy?await copyRoomDoc.set(roomModel.toMap()).then((value) {
      emit(UpdateRoomSuccessState());
    }).catchError((error) {
      emit(UpdateRoomErrorState());
    }):
    await roomDoc.set(roomModel.toMap()).then((value) {
      emit(UpdateRoomSuccessState());
    }).catchError((error) {
      emit(UpdateRoomErrorState());
    });
  }

  // void updateHotelRoomBooking({
  //   required String roomId,
  // }) {
  //   var roomDoc = FirebaseFirestore.instance
  //       .collection('hotels')
  //       .doc(thisCategoryUid)
  //       .collection('rooms')
  //       .doc(roomId);
  //   roomDoc.update({
  //     'isBooked': true,
  //   }).then((value) {
  //     emit(UpdateRoomSuccessState());
  //   }).catchError((error) {
  //     emit(UpdateRoomErrorState());
  //   });
  // }

  List<String>? categoryImages = [];
  void updateCategoryImages({
    required List<dynamic>? categoryImages,
  }) {
    var categoryDoc = FirebaseFirestore.instance
        .collection(type!)
        .doc(thisCategoryUid)
        .collection('pics')
        .doc(thisCategoryUid);
    categoryDoc.set({
      'img': categoryImages,
    }).then((value) {
      emit(UpdateCategoryImageSuccessState());
    }).catchError((error) {
      emit(UpdateCategoryImageErrorState());
    });
  }

//add multi images to new room
  bool uploading = false;
  double val = 0;
  firebase_storage.Reference? ref;

  final List<Uint8List> images = [];
  final List<String> imageUrl = [];
  String generateRandomId() {
    var random = Random();
    var randomId = random.nextInt(1000000000);
    return randomId.toString();
  }

  Future uploadFile() async {
    for (var img in images) {
      emit(UploadImgessState());
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(thisCategoryModel!.name!)
          .child(generateRandomId());
      await ref!.putData(img).whenComplete(() async {
        await ref!.getDownloadURL().then((value) {
          imageUrl.add(value);
        });
      });
    }
  }

  Future<Uint8List?> getImage(bool isCamera) async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85);
    if (file != null) {
      return file.readAsBytes();
    } else {
      return null;
    }
  }

  Future<void> chooseImage(bool isAdd, {required bool isCamera}) async {
    Uint8List? temp = await getImage(isCamera);

    if (temp != null) {
      images.add(temp);
      emit(AddSelectedRoomState(isAdd));
    }
  }

  removeFromSelected(int index) {
    images.removeAt(index);
    emit(RemoveSelectedRoomState());
  }

  removeFromEdited(int index, List<dynamic> list) {
    list.removeAt(index);
    emit(RemoveEditedRoomState());
  }

  Future<void> updateCategory({
    required String name,
    required String about,
    required String facebook,
    required bool? isBooked,
    required String? from,
    required String? callNumber,
    required String? thisCategoryUid,
    required String? to,
    required String? bank,
    required int? newPrice,
    required int? oldPrice,
    required String whatsapp,
    required bool isOffer,
    required String category,
    required List<dynamic> servicesChecked,
    required String location,
    required String? imgAssetPath,
  }) async {
    emit(UpdateMyCategoryLoadingState());
    CategoryModel newmodel = CategoryModel(
     
      isOffer:   isOffer,
      name: name,
      bank: bank,
      adminUid: adminUid,
      callNumber: callNumber,
      thisCategoryUid: thisCategoryUid,
      imgAssetPath: imgAssetPath,
      about: about,
      facebook: facebook,
      isBooked: isBooked,
      newPrice: newPrice,
      oldPrice: oldPrice,
      type: category,
      to: to,
      from: from,
      whatsapp: whatsapp,
      location: location,
      servicesChecked: servicesChecked,
    );

    await FirebaseFirestore.instance
        .collection(category)
        .doc(thisCategoryUid)
        .set(newmodel.toMap())
        .then((value) {
      emit(UpdateMyCategorySuccessState());
      getMyCategory();
    }).catchError((error) {
      emit(UpdateMyCategoryErrorState());
    });
  }

  Future<void> addCategory({
    required String name,
    required String about,
    required String facebook,
    required bool? isBooked,
    required String? from,
    required String? to,
    required String? bank,
    required int? newPrice,
    required String? callNumber,
    int? oldPrice,
    required String whatsapp,
    required bool isOffer,
    required String category,
    required List<dynamic> servicesChecked,
    required String location,
    required String? imgAssetPath,
  }) async {
    emit(UpdateMyCategoryLoadingState());
    var doc = FirebaseFirestore.instance.collection(category).doc();
    CategoryModel newmodel = CategoryModel(
      
      adminUid: adminUid,
      name: name,
      bank: bank,
      callNumber: callNumber,
      isOffer:  isOffer,
      thisCategoryUid: doc.id,
      imgAssetPath: imgAssetPath,
      about: about,
      facebook: facebook,
      isBooked: isBooked,
      newPrice: newPrice,
      oldPrice: oldPrice,
      type: category,
      to: to,
      from: from,
      whatsapp: whatsapp,
      location: location,
      servicesChecked: servicesChecked,
    );

    await doc.set(newmodel.toMap()).then((value) {
      thisCategoryUid = doc.id;
      CacheHelper.saveData(key: "thisCategoryUid", value: thisCategoryUid);
      emit(UpdateMyCategorySuccessState());
      getMyCategory();
    }).catchError((error) {
      emit(UpdateMyCategoryErrorState());
    });
  }

  // upload image to Storage
  File? profileImage;

  var picker = ImagePicker();

  Future<void> getProfileImage({required bool isCamera}) async {
    final pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 75);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage(File(pickedFile.path));
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
      // print('no image selected');
    }
  }

  String profileImageUrl = '';

  Future<void> uploadProfileImage(File profileImageUploaded) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('admin/${Uri.file(profileImageUploaded.path).pathSegments.last}')
        .putFile(profileImageUploaded)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(ProfileImageUploadSuccessState());

        // update profile image
        updateProfileImage(value, thisCategoryUid);
      }).catchError((error) {
        emit(ProfileImageUploadErrorState());
        // print(error.toString());
      });
    }).catchError((error) {
      emit(ProfileImageUploadErrorState());
      // print(error.toString());
    });
  }

  Future<void> updateProfileImage(String img, thisCategoryUi) async {
    if (img != '') {
      await FirebaseFirestore.instance
          .collection(type!)
          .doc(thisCategoryUi)
          .update({'imgAssetPath': img}).then((value) {
        emit(ProfileImageUpdateSuccessState());
      }).catchError((error) {
        emit(ProfileImageUpdateErrorState());
      });
    }
  }

  //clear old image from storage
  clearOldProfileImage() {
    profileImage = null;
    profileImageUrl = "";
    emit(ProfileImageClearedState());
  }

  // delete category
  void deleteCategory({
    required CategoryModel category,
  }) async {
    if (category.type == 'hotels') {
      await FirebaseFirestore.instance
          .collection('hotels')
          .where('adminUid', isEqualTo: thisCategoryUid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('hotels')
              .doc(element.id)
              .collection('rooms')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
          FirebaseFirestore.instance
              .collection('hotels')
              .doc(element.id)
              .collection('archive')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        }
      });
      await FirebaseFirestore.instance
          .collection('hotels')
          .where('adminUid', isEqualTo: thisCategoryUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    }
    if (category.type == 'departments') {
      await FirebaseFirestore.instance
          .collection('departments')
          .where('adminUid', isEqualTo: thisCategoryUid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('departments')
              .doc(element.id)
              .collection('pics')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
          FirebaseFirestore.instance
              .collection('departments')
              .doc(element.id)
              .collection('archive')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        }
      });
      await FirebaseFirestore.instance
          .collection('departments')
          .where('adminUid', isEqualTo: thisCategoryUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    }
    if (category.type == 'floors') {
      await FirebaseFirestore.instance
          .collection('floors')
          .where('adminUid', isEqualTo: thisCategoryUid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('floors')
              .doc(element.id)
              .collection('pics')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
          FirebaseFirestore.instance
              .collection('floors')
              .doc(element.id)
              .collection('archive')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        }
      });
      await FirebaseFirestore.instance
          .collection('floors')
          .where('adminUid', isEqualTo: thisCategoryUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    }

    FirebaseFirestore.instance
        .collection(type!)
        .doc(category.thisCategoryUid)
        .delete()
        .then((value) {
      categoryIndex = 0;
      if (type == 'hotels') {
        thisCategoryModel = null;
      }
      getMyCategory();
      emit(DeleteCategorySuccessState());
    }).catchError((error) {
      emit(DeleteCategoryErrorState());
      // print(error.toString());
    });
  }
}
