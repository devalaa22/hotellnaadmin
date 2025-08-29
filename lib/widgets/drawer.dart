import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/screens/room_detail_screen.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget myDrawer({required BuildContext context, required AppCubit cubit}) {
  return BlocBuilder<AdminCubit, AdminStates>(builder: (context, states) {
    var adminCubit = AdminCubit.get(context);
    bool isHotel = type == 'hotels';
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: DefaultText(
              text: adminCubit.adminModel == null
                  ? 'سجل الدخول أولا'
                  : adminCubit.adminModel!.name!),
        ),
        adminUid == null || adminUid == ''
            ? Center(
                child: defaultButton(
                    context: context,
                    function: () {
                      navigateAndReplacement(context, LoginScreen());
                      AppCubit.get(context).currentIndex = 0;
                    },
                    text: "سجل الدخول الآن",
                    width: MediaQuery.of(context).size.width / 2),
              )
            : adminCubit.categoryModel == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultButton(
                      context: context,
                      function: () {
                        navigateTo(
                            context,
                            AddNewCategoryScreen(
                              isEdit: false,
                            ));
                      },
                      text: 'إضافة ${adminCubit.name} جديدة',
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: isHotel
                              ? FirebaseFirestore.instance
                                  .collection(type!)
                                  .doc(thisCategoryUid)
                                  .collection('rooms')
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection(type!)
                                  .where('adminUid', isEqualTo: adminUid)
                                  .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.data == null) {
                              return const Text('لا يوجد بيانات');
                            } else {
                              List<RoomModel> roomsList = [];
                              List<CategoryModel>? categories = [];
                              if (isHotel) {
                                for (var element in snapshot.data!.docs) {
                                  roomsList.add(RoomModel.fromJson(
                                      element.data() as Map<String, dynamic>));
                                }
                              } else {
                                for (var element in snapshot.data!.docs) {
                                  categories.add(CategoryModel.fromJson(
                                      element.data() as Map<String, dynamic>));
                                }
                              }

                              return Column(
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: isHotel
                                        ? roomsList.length
                                        : categories.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: DefaultText(
                                          text: isHotel
                                              ? roomsList[index].name!
                                              : categories[index].name!,
                                          isStart: true,
                                          isHedline6: true,
                                        ),
                                        onTap: () {
                                          if (isHotel) {
                                            navigateTo(
                                                context,
                                                RoomDetailScreen(
                                                    room: roomsList[index]));
                                          } else {
                                            adminCubit.setCategoryModel(
                                              index: index,
                                              categoryModel: categories[index],
                                            );
                                            cubit.updateScreen();
                                            Navigator.pop(context);
                                          }
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: defaultButton(
                                      context: context,
                                      function: () {
                                        isHotel &&
                                                adminCubit.thisCategoryModel !=
                                                    null
                                            ? navigateTo(
                                                context,
                                                AddNewRoomScreen(),
                                              )
                                            : navigateTo(
                                                context,
                                                AddNewCategoryScreen(
                                                  isEdit: false,
                                                ));
                                        adminCubit.clearOldProfileImage();
                                      },
                                      text:
                                          'إضافة ${isHotel && adminCubit.thisCategoryModel == null ? adminCubit.nameWithHotel : adminCubit.name} ${isHotel && adminCubit.thisCategoryModel != null ? 'جديدة' : ''}',
                                    ),
                                  ),
                                 
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: defaultButton(
                                        hasIcon: true,
                                        icon: Iconly_Broken.Logout,
                                        function: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BaseAlertDialog(
                                                title: "هل تريد تسجيل الخروج",
                                                content: "تسجيل الخروج",
                                                yesOnPressed: () {
                                                  cubit.logOut(context);
                                                },
                                                noOnPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                yes: "نعم",
                                                no: "لا",
                                                yesColor: Colors.red,
                                                noColor: Colors.grey,
                                              );
                                            },
                                          );
                                        },
                                        text: 'تسجيل الخروج',
                                        context: context),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
      ],
    ));
  });
}
