import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/login_cubit/login_states.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:edarhalfnadig/shared/shared.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  AdminModel? model;
  void changePasswordShow() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  List<AdminModel> admins = [];

  void getAllAdmins() {
    FirebaseFirestore.instance.collection('admin').snapshots().listen(
      (event) {
        admins = [];
        for (var element in event.docs) {
          admins.add(
            AdminModel.fromJson(
              element.data(),
            ),
          );
          // print("email is${admins[0].email}");
          emit(
            GetAlladminsSuccessState(),
          );
        }
      },
    );
  }

  void userLogin({
    required String adminEmail,
    required String password,
    required BuildContext context,
  }) async {
    if (admins.any((element) => element.email == adminEmail) == true &&
        admins.any((element) => element.password == password) == true) {
      CacheHelper.saveData(
          key: 'adminUid',
          value: admins
              .where((element) => element.email == adminEmail)
              .first
              .adminUid);
      adminUid =
          admins.where((element) => element.email == adminEmail).first.adminUid;
      CacheHelper.saveData(
          key: 'type',
          value: admins
              .where((element) => element.email == adminEmail)
              .first
              .type);
      CacheHelper.saveData(key: 'afterLoginOrRegister', value: true);

      type = admins.where((element) => element.email == adminEmail).first.type;
      await AdminCubit.get(context).getMyCategory();
      await AdminCubit.get(context).getNames();
      await AdminCubit.get(context).getAdminData();
      showSnackBar(
          context: context, text: 'تم تسجيل الدخول بنجاح', color: Colors.green);
      AppCubit.get(context).changeBottomNav(0);
      navigateAndReplacement(context, HomeScreen());

      emit(LoginSuccessState());
    } else if (admins.any((element) => element.email == adminEmail) == false) {
      showSnackBar(
          context: context, text: 'الإيميل أو الرقم خاطئ', color: Colors.amber);
    } else if (admins.any((element) => element.email == adminEmail) == true &&
        admins.any((element) => element.password == password) == false) {
      showSnackBar(
          context: context, text: 'الرمز السري خاطئ', color: Colors.amber);
    } else {
      showSnackBar(
          context: context, text: 'مشكلة في تسجيل الدخول', color: Colors.amber);
    }
  }
}
