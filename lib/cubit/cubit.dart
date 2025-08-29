import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/shared/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/models/checkout_model.dart';
import 'package:edarhalfnadig/models/on_boarding.dart';
import 'package:edarhalfnadig/screens/archive_screen.dart';
import 'package:edarhalfnadig/screens/screens.dart';
 
import 'package:edarhalfnadig/shared/shared.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

  ThemeMode appMode = ThemeMode.light;
  List<CheckoutModel>? archiveList;
  List<CheckoutModel>? cartsList;
  // ----------------------- Home nav bar ---------------------------

  int currentIndex = 0;

  IconData? icon = Icons.brightness_4_outlined;
  final initalDateRange = DateTimeRange(
    end: DateTime.now().add(
      const Duration(hours: 24 * 3),
    ),
    start: DateTime.now(),
  );

// change Theme Mode
  bool isDark = false;

  List<Widget> navItem = [
    const OrdersScreen(),
    const ArchiveBookingScreen(),
    const ProfileScreen()
  ];

// ----------------------- Get All OnBoardings ---------------------------
  List<OnBoardingModel> onBoardingList = [];

  PageController pageController =
      PageController(initialPage: 0, keepPage: false);

// date range
  DateTimeRange? selectedDateRange;

  static AppCubit get(context) => BlocProvider.of(context);

  void changeMode({fromCache}) {
    if (fromCache == null) {
      isDark = !isDark;
    } else {
      isDark = fromCache;
    }
    CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
      if (isDark) {
        icon = Icons.brightness_7;
        appMode = ThemeMode.dark;
      } else {
        icon = Icons.brightness_4_outlined;
        appMode = ThemeMode.light;
      }
      emit(ChangeModeState());
    });
  }
 
  void logOut(context) {
    CacheHelper.removeData('afterLoginOrRegister');
    afterLoginOrRegister = false;
     
    CacheHelper.removeData('adminUid');
    adminUid = '';
    CacheHelper.removeData('type');
    type = '';
    cartsList = [];
    myToken = '';
    archiveList = [];
    onBoardingList = [];
    AdminCubit.get(context).adminModel = null;
    AdminCubit.get(context).thisCategoryModel = null;
    navigateAndReplacement(context, LoginScreen());
    showSnackBar(
        context: context, text: 'تم تسجيل الخروج بنجاح', color: Colors.green);
    emit(LogoutState());
  }

  void changeBottomNav(int index) {
    currentIndex = index;

    emit(ChangeBottomNavState());
  }

  void getAllOnBoardings() {
    emit(OnBoardingLoadingState());
    FirebaseFirestore.instance
        .collection('onboarding')
        .snapshots()
        .listen((event) {
      onBoardingList = [];
      for (var element in event.docs) {
        onBoardingList.add(OnBoardingModel.fromJson(element.data()));
        emit(OnBoardingSuccessState());
      }
    });
  }

  DateTimeRange getDate() {
    if (selectedDateRange == null) {
      return initalDateRange;
    } else {
      return selectedDateRange!;
    }
  }

  Future selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        // locale: const Locale("fr","FR"),
        context: context,
        initialDateRange: selectedDateRange ?? initalDateRange,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null && picked != selectedDateRange) {
      selectedDateRange = picked;
      emit(SelectDateState());
    }
  }

  void deleteRoomFromAchive({
    required String docId,
  }) {
    FirebaseFirestore.instance
        .collection('admin')
        .doc(adminUid)
        .collection('archive')
        .doc(docId)
        .delete()
        .then((value) {
      emit(DeleteRoomSuccessState());
    }).catchError((error) {
      emit(DeleteRoomErrorState());
      // print(error.toString());
    });
  }

  void deleteRoomFromHotel({
    required String roomId,
  }) {
    FirebaseFirestore.instance
        .collection('hotels')
        .doc(thisCategoryUid)
        .collection('rooms')
        .doc(roomId)
        .delete()
        .then((value) {
      emit(DeleteHotelRoomSuccessState());
    }).catchError((error) {
      emit(DeleteHotelRoomErrorState());
      // print(error.toString());
    });
  }
 

//   Future<bool> callOnFcmApiSendPushNotifications(
//       {required String notificationTitle, required String notificationBody,required String userToken,}) async {
//     const postUrl = 'https://fcm.googleapis.com/v1/projects/hotella-c439e/messages:send';
//    var body =
// {
//    "message":{
//       "token":userToken,
//       "notification":{
//         "body":notificationBody,
//         "title":notificationTitle
//       }
//    }
// };

// var headersList = {
//  'Accept': 'application/json',
//  'Authorization': 'Bearer ya29.a0AVA9y1u6KkFeJ_ETvNAjKU1kV87Cn9E2nYAP6vyVyClcDvpM0tWiFo3-5RhnWpsJr8gWtG-4MxyzwaTxvZdtmPAQ4O-4MiTKJ-JbzZPjbHteIQX69LdIsvKZbD39SsrD1pMeN4lgC_e9Mo4CM_xLaqGH4PfraCgYKATASAQASFQE65dr85PzSlCzlX1f-WuPC9lM3oQ0163 ',
//  'Content-Type': 'application/json'
// };
//     final response = await http.post(Uri.parse(postUrl),
//         body: json.encode(body),
//         encoding: Encoding.getByName('utf-8'),
//         headers: headersList);
//     emit(UpdateUserNotificationSuccessState());
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       // on success do sth
//       print('test ok push FCM');
//       return true;
//     } else {
//       print(' FCM error');
//       // on failure do sth
//       return false;
//     }
//   }

  void confirmBook({
    required String name,
    required String userToken,
    required String type,
    required String phone,
    required String passport,
    required String bookId,
    required String email,
    required String location,
    required String categoryName,
    required String categoryLocation,
    required bool isBooked,
    required bool isPending,
    required bool isRefused,
    required String hotelId,
    required String roomUid,
    required String androidInvoice,
    required String roomName,
    required String des,
    required int price,
    required String from,
    required String to,
    required int level,
  }) {
    var archiveDoc =
        FirebaseFirestore.instance.collection('orders').doc(bookId);
    CheckoutModel checkoutModel = CheckoutModel(
      bookId: bookId,
      name: name,
      phone: phone,
      passport: passport,
      email: email,
      userToken: userToken,
      roomUid: roomUid,
      location: location,
      isPending: isPending,
      isBooked: isBooked,
      isRefused: isRefused,
      androidInvoice: androidInvoice,
      hotelId: hotelId,
      price: price,
      level: level,
      roomName: roomName,
      des: des,
      from: from,
      to: to,
      type: type, categoryLocation: categoryLocation, categoryName: categoryName,
    );

    archiveDoc.set(checkoutModel.toMap()).then((value) {
      LocalNotificationService.sendNotification(
          notificationTitle: '${bookId.substring(0, 7)} حالة الحجز',
          notificationBody: isRefused
              ? '$categoryName \n$roomName \n ${bookId.substring(0, 7)} تم رفض الحجز'
              : '$categoryName \n$roomName \n ${bookId.substring(0, 7)} تم تاكيد الحجز',
          userToken: userToken);
      emit(AddToArchiveSuccessState());
    }).catchError((error) {
      emit(AddToArchiveErrorState());
    });
  }

  void addToArchive({
    required String name,
    required String userToken,
    required String roomUid,
    required String type,
    required String phone,
    required String passport,
    required String bookId,
    required String email,
    required String location,
    required bool isBooked,
    required bool isPending,
    required bool isRefused,
    required String hotelId,
    required String categoryName,
    required String categoryLocation,
    required String androidInvoice,
    required String roomName,
    required String des,
    required int price,
    required String from,
    required String to,
    required int level,
  }) {
    var archiveDoc = FirebaseFirestore.instance
        .collection('admin')
        .doc(adminUid)
        .collection('archive')
        .doc(bookId);
    CheckoutModel checkoutModel = CheckoutModel(
      bookId: bookId,
      name: name,
      phone: phone,
      passport: passport,
      userToken: userToken,
      email: email,
      roomUid: roomUid,
      location: location,
      isPending: isPending,
      isBooked: isBooked,
      isRefused: isRefused,
      androidInvoice: androidInvoice,
      hotelId: hotelId,
      price: price,
      level: level,
      from: from,
      to: to,
      roomName: roomName,
      des: des,
       type: type, categoryLocation: categoryLocation, categoryName: categoryName,
    );

    archiveDoc.set(checkoutModel.toMap()).then((value) {
      emit(AddToArchiveSuccessState());
    }).catchError((error) {
      emit(AddToArchiveErrorState());
    });
  }

//-------------------- get Days In Between ------------------------//

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  updateScreen() {
    emit(UpdateSuccessState());
  }
}
