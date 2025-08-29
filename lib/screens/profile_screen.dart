import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/screens/review_screen.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/streem_category.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {
        AdminCubit cubit = AdminCubit.get(context);
        if (state is UserLoadingState ||
            state is UpdateMyCategoryLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UploadImgessState) {
          showSnackBar(
              context: context, text: "جاري التحميل ", color: Colors.green);
        } else if (state is UpdateCategoryImageSuccessState) {
          showSnackBar(
              context: context, text: "تم التحميل بنجاح ", color: Colors.green);
        }
        if (state is NoSelectedRoomState) {
          showSnackBar(
              context: context,
              text: "يرجى تحديد صورة",
              color: Colors.amberAccent);
        }
        if (state is AddSelectedRoomState) {
          if (!state.isAdd) {
            showDialog(
                context: context,
                builder: (context) => BaseAlertDialog(
                    yesColor: Colors.green,
                    noColor: Colors.red,
                    title: "إضافة صورة",
                    content: "هل تريد اضافة هذه الصورة",
                    yes: 'نعم',
                    no: 'لا',
                    yesOnPressed: () {
                      cubit.uploading = true;
                      cubit
                          .uploadFile()
                          .then((value) {
                            for (var image in cubit.imageUrl) {
                              cubit.categoryImages!.add(image);
                            }
                          })
                          .then((value) => cubit.updateCategoryImages(
                              categoryImages: cubit.categoryImages))
                          .then((value) {
                            cubit.uploading = false;
                            cubit.images.clear();
                            cubit.imageUrl.clear();
                          });
                      Navigator.pop(context);
                    },
                    noOnPressed: () {
                      cubit.uploading = false;
                      cubit.images.clear();
                      cubit.imageUrl.clear();
                      Navigator.pop(context);
                    }));
          }
        }
      },
      builder: (context, state) {
        AdminCubit cubit = AdminCubit.get(context);

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(type!)
                .where('adminUid', isEqualTo: adminUid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: defaultButton(
                      function: () {
                        navigateTo(
                            context, AddNewCategoryScreen(isEdit: false));
                        cubit.clearOldProfileImage();
                      },
                      text: 'إضافة بيانات',
                      width: MediaQuery.of(context).size.width - 20,
                      context: context),
                );
              }
              if (snapshot.hasData == false) {
                return Center(
                  child: defaultButton(
                      function: () {
                        navigateTo(
                            context,
                            AddNewCategoryScreen(
                              isEdit: false,
                            ));
                        cubit.clearOldProfileImage();
                      },
                      text: 'إضافة بيانات',
                      width: MediaQuery.of(context).size.width - 20,
                      context: context),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<CategoryModel> categories = [];
                for (var element in snapshot.data!.docs) {
                  categories.add(CategoryModel.fromJson(
                      element.data() as Map<String, dynamic>));
                }

                return Scaffold(
                  body: categories.isEmpty
                      ? Center(
                          child: defaultButton(
                              function: () {
                                navigateTo(
                                    context,
                                    AddNewCategoryScreen(
                                      isEdit: false,
                                    ));
                                cubit.clearOldProfileImage();
                              },
                              text: 'إضافة ${cubit.nameWithHotel}',
                              width: MediaQuery.of(context).size.width - 20,
                              context: context),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 230,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Container(
                                        height: 190,
                                        width: double.infinity,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withAlpha(123),
                                      ),
                                    ),
                                    categories[cubit.categoryIndex]
                                                    .imgAssetPath ==
                                                null ||
                                            categories[cubit.categoryIndex]
                                                    .imgAssetPath ==
                                                ''
                                        ? Stack(
                                            alignment:
                                                AlignmentDirectional.bottomEnd,
                                            children: [
                                              CircleAvatar(
                                                radius: 64,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                child:
                                                    const Text('لا توجد صورة'),
                                              ),
                                            ],
                                          )
                                        : InkWell(
                                            onTap: () {
                                              navigateTo(
                                                  context,
                                                  ImageViewScreen(
                                                    image: categories[
                                                            cubit.categoryIndex]
                                                        .imgAssetPath!,
                                                  ));
                                            },
                                            child: Stack(
                                              alignment: AlignmentDirectional
                                                  .bottomEnd,
                                              children: [
                                                CircleAvatar(
                                                  radius: 64,
                                                  backgroundColor: Theme.of(
                                                          context)
                                                      .scaffoldBackgroundColor,
                                                  child: cacheImage(
                                                      url:
                                                          '${categories[cubit.categoryIndex].imgAssetPath}',
                                                      width: 120,
                                                      height: 120,
                                                      shape: BoxShape.circle),
                                                ),
                                              ],
                                            )),
                                  ],
                                ),
                              ),
                              Text(
                                '${categories[cubit.categoryIndex].name}',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Text(
                                '${categories[cubit.categoryIndex].location}',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  defaultButton(
                                      hasIcon: true,
                                      icon: Iconly_Broken.Edit_Square,
                                      function: () {
                                        navigateTo(
                                            context,
                                            AddNewCategoryScreen(
                                              isEdit: true,
                                              categoryModel: categories[
                                                  cubit.categoryIndex],
                                            ));
                                        cubit.clearOldProfileImage();
                                      },
                                      text: 'عدل الملف الشخصي',
                                      width: type == 'hotels'
                                          ? MediaQuery.of(context).size.width /
                                              2.2
                                          : MediaQuery.of(context).size.width -
                                              40,
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      context: context),
                                  if (cubit.adminModel!.type == 'hotels')
                                    defaultButton(
                                        hasIcon: true,
                                        icon: Icons.add_circle_outline,
                                        function: () {
                                          navigateTo(
                                            context,
                                            AddNewRoomScreen(),
                                          );
                                        },
                                        text: 'إضافة غرفة جديدة',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        fontSize: 14,
                                        context: context),
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              StreamBuilder<Object>(
                                  stream: type == 'hotels'
                                      ? FirebaseFirestore.instance
                                          .collection(type!)
                                          .doc(adminUid)
                                          .collection('reviews')
                                          .snapshots()
                                      : FirebaseFirestore.instance
                                          .collection(type!)
                                          .doc(thisCategoryUid)
                                          .collection('reviews')
                                          .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    // get the data from the snapshot
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      cubit.thisReviews = [];
                                      snapshot.data.docs.forEach((element) {
                                        cubit.thisReviews.add(
                                            ReviewModel.fromJson(
                                                element.data()));
                                      });

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                              icon: const Icon(
                                                  Icons.arrow_back_ios_new),
                                              label: Text(
                                                'كل التقييمات',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              ),
                                              onPressed: () {
                                                navigateTo(
                                                    context,
                                                    ReviewScreen(
                                                      reviews:
                                                          cubit.thisReviews,
                                                    ));
                                              },
                                            ),
                                            SmoothStarRating(
                                              rating: cubit.getRating(
                                                  thisReviews:
                                                      cubit.thisReviews),
                                              color: Colors.amber,
                                              borderColor: mainColor,
                                              filledIconData: Icons.star,
                                              halfFilledIconData:
                                                  Icons.star_half,
                                              defaultIconData:
                                                  Icons.star_border,
                                              starCount: 5,
                                              allowHalfRating: false,
                                              spacing: 2.0,
                                              onRatingChanged: (value) async {},
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ComunicationIcons(
                                              url: Platform.isAndroid
                                                  ? "https://wa.me/967${categories[cubit.categoryIndex].whatsapp}"
                                                  : "https://api.whatsapp.com/send?phone=967${categories[cubit.categoryIndex].whatsapp}",
                                              icondata:
                                                  FontAwesomeIcons.whatsapp),
                                          ComunicationIcons(
                                              url:
                                                  '${categories[cubit.categoryIndex].facebook}',
                                              icondata:
                                                  FontAwesomeIcons.facebook),
                                        ],
                                      ),
                                      // 'sms:+39 348 060 888?body=hello%20there'
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        leading: const Icon(
                                            Iconly_Broken.Tick_Square),
                                        title: DefaultText(
                                          text: "معلومات الحساب البنكي",
                                          isHedline6: true,
                                          isStart: true,
                                        ),
                                        initiallyExpanded: false,
                                        children: [
                                          Text(
                                            '${categories[cubit.categoryIndex].bank}',
                                            textDirection: TextDirection.rtl,
                                            maxLines: 3,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        leading: const Icon(
                                            Iconly_Broken.Tick_Square),
                                        title: DefaultText(
                                          text: "الخدمات",
                                          isHedline6: true,
                                          isStart: true,
                                        ),
                                        initiallyExpanded: false,
                                        children: [
                                          Wrap(
                                            spacing: 3,
                                            textDirection: TextDirection.rtl,
                                            children: cubit.servicesChecked
                                                .map(
                                                  (e) => Chip(
                                                      label: Text(
                                                    e,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  )),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        leading: const Icon(
                                            Iconly_Broken.Info_Circle),
                                        title: DefaultText(
                                          text: "حول",
                                          isHedline6: true,
                                          isStart: true,
                                        ),
                                        initiallyExpanded: false,
                                        childrenPadding:
                                            const EdgeInsets.all(8),
                                        children: [
                                          Text(
                                            '${categories[cubit.categoryIndex].about}',
                                            textDirection: TextDirection.rtl,
                                            maxLines: 3,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    if (type == 'hotels')
                                      StreemCategory(
                                        isOffer: false,
                                        categoryModel:
                                            categories[cubit.categoryIndex],
                                        collection: 'rooms',
                                      ),
                                    if (type == 'departments')
                                      StreemCategory(
                                        isOffer: false,
                                        categoryModel:
                                            categories[cubit.categoryIndex],
                                        collection: 'pics',
                                      ),
                                    if (type == 'floors')
                                      StreemCategory(
                                        isOffer: false,
                                        categoryModel:
                                            categories[cubit.categoryIndex],
                                        collection: 'pics',
                                      ),
                                    StreemCategory(
                                      isOffer: true,
                                      categoryModel:
                                          categories[cubit.categoryIndex],
                                      collection:
                                          type == 'hotels' ? 'rooms' : 'pics',
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    defaultButton(
                                        hasIcon: true,
                                        icon: Iconly_Broken.Delete,
                                        function: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BaseAlertDialog(
                                                title:
                                                    "هل تريد حذف ${categories[cubit.categoryIndex].name}",
                                                content: " سيتم الحذف نهائيا",
                                                yesOnPressed: () {
                                                  cubit.deleteCategory(
                                                      category: categories[
                                                          cubit.categoryIndex]);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      'تم الحذف بنجاح',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
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
                                        text:
                                            'حذف ${categories[cubit.categoryIndex].name}',
                                        color: Colors.red,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        fontSize: 14,
                                        context: context),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  floatingActionButton: type != 'hotels' &&
                          cubit.thisCategoryModel != null &&
                          categories.isNotEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'camera',
                              onPressed: () {
                                if (cubit.images.length < 10) {
                                  !cubit.uploading
                                      ? cubit.chooseImage(false, isCamera: true)
                                      : null;
                                } else {
                                  showSnackBar(
                                      color: Colors.amberAccent,
                                      context: context,
                                      text:
                                          'اقصى عدد من الصور يمكن إضافتها 10');
                                }
                              },
                              child: const Icon(Icons.add_a_photo),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FloatingActionButton(
                              heroTag: 'gallery',
                              onPressed: () {
                                if (cubit.images.length < 10) {
                                  !cubit.uploading
                                      ? cubit.chooseImage(false,
                                          isCamera: false)
                                      : null;
                                } else {
                                  showSnackBar(
                                      color: Colors.amberAccent,
                                      context: context,
                                      text:
                                          'اقصى عدد من الصور يمكن إضافتها 10');
                                }
                              },
                              child: const Icon(Icons.photo_rounded),
                            ),
                          ],
                        )
                      : null,
                );
              }
            });
      },
    );
  }
}
