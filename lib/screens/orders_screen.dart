import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var adminCubit = AdminCubit.get(context);
        return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
          return adminUid == null || adminUid == ''
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
              : Scaffold(
                  body: adminUid != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 100, bottom: 20),
                          child: StreamBuilder<Object>(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('hotelId', isEqualTo: thisCategoryUid)
                                  .where('isPending', isEqualTo: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  cubit.cartsList = [];
                                  snapshot.data.docs.forEach((element) {
                                    cubit.cartsList!.add(
                                        CheckoutModel.fromJson(element.data()));
                                  });
                                  return cubit.cartsList!.isEmpty
                                      ? Center(
                                          child: DefaultText(
                                            text:
                                                'لا توجد طلبات للحجز حتى الآن',
                                            h2size: 20,
                                          ),
                                        )
                                      : ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.only(
                                              top: 20,
                                              bottom: 0,
                                              right: 0,
                                              left: 0),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) =>
                                              Column(
                                            children: [
                                              Card(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                elevation: 10,
                                                shadowColor: Theme.of(context)
                                                    .dividerColor,
                                                child: ExpansionTile(
                                                    initiallyExpanded: true,
                                                    title: CheckoutDetailTile(
                                                      text:
                                                          "اسم الغرفة : ${cubit.cartsList![index].roomName!}",
                                                      icon: Icons.night_shelter,
                                                    ),
                                                    children: [
                                                      Card(
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                navigateTo(
                                                                  context,
                                                                  ImageViewScreen(
                                                                      image: cubit
                                                                          .cartsList![
                                                                              index]
                                                                          .androidInvoice!),
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                height: 210,
                                                                child:
                                                                    cacheImage(
                                                                  url: cubit
                                                                      .cartsList![
                                                                          index]
                                                                      .androidInvoice!,
                                                                  height: 210,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                ),
                                                              ),
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "الاسم : ${cubit.cartsList![index].name!}",
                                                              icon: Icons
                                                                  .location_history_outlined,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "العنوان : ${cubit.cartsList![index].location!}",
                                                              icon: Icons
                                                                  .location_on,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "رقم الحجز : ${cubit.cartsList![index].bookId!.substring(0, 7)}",
                                                              icon: Icons.book,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "${cubit.cartsList![index].from!} | ${cubit.cartsList![index].to!}",
                                                              icon: Icons.book,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "رقم الهاتف : ${cubit.cartsList![index].phone!}",
                                                              icon: Icons.call,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "رقم البطاقة أو الجواز : ${cubit.cartsList![index].passport!}",
                                                              icon: Icons
                                                                  .verified_user,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "سعر الليلة : ${cubit.cartsList![index].price!}",
                                                              icon:
                                                                  FontAwesomeIcons
                                                                      .moneyBill,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text:
                                                                  "رقم الدور : ${cubit.cartsList![index].level!}",
                                                              icon:
                                                                  Icons.layers,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text: "عدد الليالي : ${AppCubit.get(context).getDaysInBetween(
                                                                    DateTime.parse(cubit
                                                                        .cartsList![
                                                                            index]
                                                                        .from!),
                                                                    DateTime.parse(cubit
                                                                        .cartsList![
                                                                            index]
                                                                        .to!),
                                                                  ).length - 1}",
                                                              icon: Icons
                                                                  .night_shelter,
                                                            ),
                                                            CheckoutDetailTile(
                                                              text: "المجموع : ${cubit.cartsList![index].price! * (AppCubit.get(context).getDaysInBetween(
                                                                    DateTime.parse(cubit
                                                                        .cartsList![
                                                                            index]
                                                                        .from!),
                                                                    DateTime.parse(cubit
                                                                        .cartsList![
                                                                            index]
                                                                        .to!),
                                                                  ).length - 1)}",
                                                              icon: Icons.money,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          defaultButton(
                                                              context: context,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              function: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return BaseAlertDialog(
                                                                      title:
                                                                          "هل تريد تاكيد الحجز",
                                                                      content:
                                                                          "${cubit.cartsList![index].name}\nريال يمني  ${cubit.cartsList![index].price! * (AppCubit.get(context).getDaysInBetween(
                                                                                DateTime.parse(cubit.cartsList![index].from!),
                                                                                DateTime.parse(cubit.cartsList![index].to!),
                                                                              ).length - 1)}",
                                                                      yesOnPressed:
                                                                          () {
                                                                        if (adminUid ==
                                                                            null) {
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            backgroundColor:
                                                                                Colors.amber,
                                                                            content:
                                                                                Text(
                                                                              'سجل الدخول أولا',
                                                                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ));
                                                                        } else {
                                                                          cubit
                                                                              .confirmBook(
                                                                            categoryName:
                                                                                adminCubit.adminModel!.name!,
                                                                            name:
                                                                                cubit.cartsList![index].name!,
                                                                            userToken:
                                                                                cubit.cartsList![index].userToken!,
                                                                            roomUid:
                                                                                cubit.cartsList![index].roomUid!,
                                                                            phone:
                                                                                cubit.cartsList![index].phone!,
                                                                            passport:
                                                                                cubit.cartsList![index].passport!,
                                                                            email:
                                                                                cubit.cartsList![index].email!,
                                                                            location:
                                                                                cubit.cartsList![index].location!,
                                                                            isBooked:
                                                                                true,
                                                                            isPending:
                                                                                false,
                                                                            isRefused:
                                                                                false,
                                                                            hotelId:
                                                                                cubit.cartsList![index].hotelId!,
                                                                            androidInvoice:
                                                                                cubit.cartsList![index].androidInvoice!,
                                                                            roomName:
                                                                                cubit.cartsList![index].roomName!,
                                                                            des:
                                                                                cubit.cartsList![index].des!,
                                                                            price:
                                                                                cubit.cartsList![index].price!,
                                                                            level:
                                                                                cubit.cartsList![index].level!,
                                                                            bookId:
                                                                                cubit.cartsList![index].bookId!,
                                                                            from:
                                                                                cubit.cartsList![index].from!,
                                                                            to: cubit.cartsList![index].to!,
                                                                            type:
                                                                                cubit.cartsList![index].type!,
                                                                            categoryLocation:
                                                                                cubit.cartsList![index].categoryLocation ?? '',
                                                                          );

                                                                          cubit
                                                                              .addToArchive(
                                                                            name:
                                                                                cubit.cartsList![index].name!,
                                                                            userToken:
                                                                                cubit.cartsList![index].userToken!,
                                                                            roomUid:
                                                                                cubit.cartsList![index].roomUid!,
                                                                            phone:
                                                                                cubit.cartsList![index].phone!,
                                                                            passport:
                                                                                cubit.cartsList![index].passport!,
                                                                            email:
                                                                                cubit.cartsList![index].email!,
                                                                            location:
                                                                                cubit.cartsList![index].location!,
                                                                            isBooked:
                                                                                true,
                                                                            isPending:
                                                                                false,
                                                                            isRefused:
                                                                                false,
                                                                            hotelId:
                                                                                cubit.cartsList![index].hotelId!,
                                                                            androidInvoice:
                                                                                cubit.cartsList![index].androidInvoice!,
                                                                            roomName:
                                                                                cubit.cartsList![index].roomName!,
                                                                            des:
                                                                                cubit.cartsList![index].des!,
                                                                            price:
                                                                                cubit.cartsList![index].price!,
                                                                            from:
                                                                                cubit.cartsList![index].from!,
                                                                            to: cubit.cartsList![index].to!,
                                                                            level:
                                                                                cubit.cartsList![index].level!,
                                                                            bookId:
                                                                                cubit.cartsList![index].bookId!,
                                                                            type:
                                                                                cubit.cartsList![index].type!,
                                                                            categoryLocation:
                                                                                cubit.cartsList![index].categoryLocation ?? '',
                                                                            categoryName:
                                                                                cubit.cartsList![index].categoryName ?? '',
                                                                          );

                                                                          //todo update room book
                                                                          type == 'hotels'
                                                                              ? null
                                                                              :
                                                                              // adminCubit.updateHotelRoomBooking(
                                                                              //     roomId: cubit.cartsList![index].roomUid!,
                                                                              //   )
                                                                              // :
                                                                              adminCubit.updateCategory(
                                                                                  isOffer: adminCubit.thisCategoryModel!.isOffer!,
                                                                                  thisCategoryUid: thisCategoryUid,
                                                                                  name: adminCubit.thisCategoryModel!.name!,
                                                                                  about: adminCubit.thisCategoryModel!.about!,
                                                                                  newPrice: adminCubit.thisCategoryModel!.newPrice!,
                                                                                  oldPrice: adminCubit.thisCategoryModel!.oldPrice!,
                                                                                  facebook: adminCubit.thisCategoryModel!.facebook!,
                                                                                  whatsapp: adminCubit.thisCategoryModel!.whatsapp!,
                                                                                  callNumber: adminCubit.thisCategoryModel!.callNumber!,
                                                                                  location: adminCubit.thisCategoryModel!.location!,
                                                                                  imgAssetPath: adminCubit.thisCategoryModel!.imgAssetPath,
                                                                                  from: cubit.cartsList![index].from!,
                                                                                  to: cubit.cartsList![index].to!,
                                                                                  isBooked: true,
                                                                                  servicesChecked: adminCubit.servicesChecked,
                                                                                  category: adminCubit.adminModel!.type!,
                                                                                  bank: adminCubit.thisCategoryModel!.bank!,
                                                                                );

                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            content:
                                                                                Text(
                                                                              'تم تاكيد الحجز',
                                                                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ));
                                                                        }
                                                                      },
                                                                      noOnPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      yes:
                                                                          "نعم",
                                                                      no: "لا",
                                                                      yesColor:
                                                                          Colors
                                                                              .green,
                                                                      noColor:
                                                                          Colors
                                                                              .grey,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              text:
                                                                  'تاكيد الحجز'),
                                                          defaultButton(
                                                              context: context,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              function: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return BaseAlertDialog(
                                                                      title:
                                                                          "هل تريد إلغاء الحجز",
                                                                      content:
                                                                          "${cubit.cartsList![index].name}\nريال يمني  ${cubit.cartsList![index].price! * (AppCubit.get(context).getDaysInBetween(
                                                                                DateTime.parse(cubit.cartsList![index].from!),
                                                                                DateTime.parse(cubit.cartsList![index].to!),
                                                                              ).length - 1)}",
                                                                      yesOnPressed:
                                                                          () {
                                                                        if (adminUid ==
                                                                            null) {
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            backgroundColor:
                                                                                Colors.amber,
                                                                            content:
                                                                                Text(
                                                                              'سجل الدخول أولا ',
                                                                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ));
                                                                        } else {
                                                                          cubit
                                                                              .confirmBook(
                                                                            categoryName:
                                                                                adminCubit.adminModel!.name!,
                                                                            name:
                                                                                cubit.cartsList![index].name!,
                                                                            userToken:
                                                                                cubit.cartsList![index].userToken ?? '',
                                                                            roomUid:
                                                                                cubit.cartsList![index].roomUid ?? '',
                                                                            phone:
                                                                                cubit.cartsList![index].phone!,
                                                                            passport:
                                                                                cubit.cartsList![index].passport!,
                                                                            email:
                                                                                cubit.cartsList![index].email!,
                                                                            location:
                                                                                cubit.cartsList![index].location!,
                                                                            isBooked:
                                                                                false,
                                                                            isPending:
                                                                                false,
                                                                            isRefused:
                                                                                true,
                                                                            hotelId:
                                                                                cubit.cartsList![index].hotelId!,
                                                                            androidInvoice:
                                                                                cubit.cartsList![index].androidInvoice!,
                                                                            roomName:
                                                                                cubit.cartsList![index].roomName!,
                                                                            des:
                                                                                cubit.cartsList![index].des!,
                                                                            price:
                                                                                cubit.cartsList![index].price!,
                                                                            from:
                                                                                cubit.cartsList![index].from!,
                                                                            to: cubit.cartsList![index].to!,
                                                                            level:
                                                                                cubit.cartsList![index].level!,
                                                                            bookId:
                                                                                cubit.cartsList![index].bookId!,
                                                                            type:
                                                                                cubit.cartsList![index].type!,
                                                                            categoryLocation:
                                                                                cubit.cartsList![index].categoryLocation ?? '',
                                                                          );
                                                                          cubit
                                                                              .addToArchive(
                                                                            name:
                                                                                cubit.cartsList![index].name!,
                                                                            userToken:
                                                                                cubit.cartsList![index].userToken ?? '',
                                                                            roomUid:
                                                                                cubit.cartsList![index].roomUid ?? "",
                                                                            phone:
                                                                                cubit.cartsList![index].phone!,
                                                                            passport:
                                                                                cubit.cartsList![index].passport!,
                                                                            email:
                                                                                cubit.cartsList![index].email!,
                                                                            location:
                                                                                cubit.cartsList![index].location!,
                                                                            isBooked:
                                                                                false,
                                                                            isPending:
                                                                                false,
                                                                            isRefused:
                                                                                true,
                                                                            hotelId:
                                                                                cubit.cartsList![index].hotelId!,
                                                                            androidInvoice:
                                                                                cubit.cartsList![index].androidInvoice!,
                                                                            roomName:
                                                                                cubit.cartsList![index].roomName!,
                                                                            des:
                                                                                cubit.cartsList![index].des!,
                                                                            price:
                                                                                cubit.cartsList![index].price!,
                                                                            from:
                                                                                cubit.cartsList![index].from!,
                                                                            to: cubit.cartsList![index].to!,
                                                                            level:
                                                                                cubit.cartsList![index].level!,
                                                                            bookId:
                                                                                cubit.cartsList![index].bookId!,
                                                                            type:
                                                                                cubit.cartsList![index].type!,
                                                                            categoryLocation:
                                                                                cubit.cartsList![index].categoryLocation ?? '',
                                                                            categoryName:
                                                                                cubit.cartsList![index].categoryName ?? '',
                                                                          );
                                                                          type == 'hotels'
                                                                              ? adminCubit.updateCategory(
                                                                                  callNumber: adminCubit.thisCategoryModel!.callNumber!,
                                                                                  isOffer: adminCubit.thisCategoryModel!.isOffer!,
                                                                                  thisCategoryUid: thisCategoryUid,
                                                                                  name: adminCubit.thisCategoryModel!.name!,
                                                                                  about: adminCubit.thisCategoryModel!.about!,
                                                                                  newPrice: adminCubit.thisCategoryModel!.newPrice!,
                                                                                  oldPrice: adminCubit.thisCategoryModel!.oldPrice!,
                                                                                  facebook: adminCubit.thisCategoryModel!.facebook!,
                                                                                  whatsapp: adminCubit.thisCategoryModel!.whatsapp!,
                                                                                  location: adminCubit.thisCategoryModel!.location!,
                                                                                  imgAssetPath: adminCubit.thisCategoryModel!.imgAssetPath,
                                                                                  servicesChecked: adminCubit.servicesChecked,
                                                                                  category: adminCubit.adminModel!.type!,
                                                                                  from: cubit.cartsList![index].from!,
                                                                                  to: cubit.cartsList![index].to!,
                                                                                  isBooked: false,
                                                                                  bank: adminCubit.thisCategoryModel!.bank!,
                                                                                )
                                                                              : adminCubit.updateCategory(
                                                                                  callNumber: adminCubit.thisCategoryModel!.callNumber!,
                                                                                  isOffer: adminCubit.thisCategoryModel!.isOffer!,
                                                                                  thisCategoryUid: thisCategoryUid,
                                                                                  name: adminCubit.thisCategoryModel!.name!,
                                                                                  about: adminCubit.thisCategoryModel!.about!,
                                                                                  newPrice: adminCubit.thisCategoryModel!.newPrice!,
                                                                                  oldPrice: adminCubit.thisCategoryModel!.oldPrice!,
                                                                                  facebook: adminCubit.thisCategoryModel!.facebook!,
                                                                                  whatsapp: adminCubit.thisCategoryModel!.whatsapp!,
                                                                                  location: adminCubit.thisCategoryModel!.location!,
                                                                                  imgAssetPath: adminCubit.thisCategoryModel!.imgAssetPath,
                                                                                  from: cubit.cartsList![index].from!,
                                                                                  to: cubit.cartsList![index].to!,
                                                                                  isBooked: false,
                                                                                  servicesChecked: adminCubit.servicesChecked,
                                                                                  category: adminCubit.adminModel!.type!,
                                                                                  bank: adminCubit.thisCategoryModel!.bank!,
                                                                                );

                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            content:
                                                                                Text(
                                                                              'تم إلغاء الحجز',
                                                                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ));
                                                                        }
                                                                      },
                                                                      noOnPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      yes:
                                                                          "نعم",
                                                                      no: "لا",
                                                                      yesColor:
                                                                          Colors
                                                                              .red,
                                                                      noColor:
                                                                          Colors
                                                                              .green,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              text:
                                                                  'إلغاء الحجز'),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ]),
                                              )
                                            ],
                                          ),
                                          itemCount: cubit.cartsList!.length,
                                        );
                                }
                              }),
                        )
                      : Center(
                          child: DefaultText(
                            text: 'لا توجد طلبات للحجز حتى الآن',
                          ),
                        ),
                );
        });
      },
      listener: (context, state) {
        if (state is UserErrorState) {
          navigateTo(context, LoginScreen());
          var cubit = AppCubit.get(context);
          cubit.logOut(context);
        }
      },
    );
  }
}
