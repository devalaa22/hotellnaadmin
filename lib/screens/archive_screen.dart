import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/models/checkout_model.dart';
import 'package:edarhalfnadig/screens/archive_detail_screen.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class ArchiveBookingScreen extends StatelessWidget {
  const ArchiveBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
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
          : StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection('admin')
                  .doc(adminUid)
                  .collection("archive")
                  .where('hotelId', isEqualTo: thisCategoryUid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  cubit.archiveList = [];
                  snapshot.data.docs.forEach((element) {
                    cubit.archiveList!
                        .add(CheckoutModel.fromJson(element.data()));
                  });
                  return SafeArea(
                    child: Scaffold(
                      body: cubit.archiveList!.isEmpty
                          ? Center(
                              child: DefaultText(
                                text: 'لا توجد طلبات  في الأرشيف حتى الآن',
                                h2size: 20,
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 0, right: 0, left: 0),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          color: cubit.archiveList![index]
                                                      .isBooked ==
                                                  true
                                              ? const Color.fromARGB(
                                                  255, 8, 63, 11)
                                              : cubit.archiveList![index]
                                                          .isRefused ==
                                                      true
                                                  ? Colors.red.shade900
                                                  : Colors.amber,
                                          child: Column(
                                            children: [
                                              CheckoutDetailTile(
                                                color: Colors.white,
                                                text:
                                                    "الاسم : ${cubit.archiveList![index].name!}",
                                                icon: Icons.verified_user,
                                              ),
                                              CheckoutDetailTile(
                                                color: Colors.white,
                                                text:
                                                    "رقم الحجز : ${cubit.archiveList![index].bookId!.substring(0, 7)}",
                                                icon: Icons.book,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  defaultButton(
                                                      function: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return BaseAlertDialog(
                                                              title:
                                                                  "هل تريد الحذف",
                                                              content:
                                                                  "${cubit.archiveList![index].bookId}",
                                                              yesOnPressed: () {
                                                                cubit.deleteRoomFromAchive(
                                                                    docId: cubit
                                                                        .archiveList![
                                                                            index]
                                                                        .bookId!);
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  content: Text(
                                                                    'تم الحذف بنجاح',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displayMedium!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ));
                                                              },
                                                              noOnPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              yes: "نعم",
                                                              no: "لا",
                                                              yesColor:
                                                                  Colors.red,
                                                              noColor:
                                                                  Colors.grey,
                                                            );
                                                          },
                                                        );
                                                      },
                                                      text: 'حذف',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      color: Colors.red,
                                                      context: context),
                                                  defaultButton(
                                                      function: () {
                                                        navigateTo(
                                                          context,
                                                          ArchiveDetailScreen(
                                                            archive: cubit
                                                                    .archiveList![
                                                                index],
                                                          ),
                                                        );
                                                      },
                                                      text: 'المزيد',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      color: Colors.grey,
                                                      context: context),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                              itemCount: cubit.archiveList!.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  thickness: 1,
                                  color: Theme.of(context).primaryColor,
                                );
                              }),
                    ),
                  );
                }
              });
    });
  }
}
