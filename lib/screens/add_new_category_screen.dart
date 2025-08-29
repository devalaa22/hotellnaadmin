import 'dart:io';

import 'package:edarhalfnadig/models/model.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/screens/login_screen.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class AddNewCategoryScreen extends StatelessWidget {
  final bool isEdit;
  final CategoryModel? categoryModel;

  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final locationController = TextEditingController();
  final facebookController = TextEditingController();
  final whatsappController = TextEditingController();
  final phoneController = TextEditingController();
  final bankController = TextEditingController();
  final newPriceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AddNewCategoryScreen({super.key, required this.isEdit, this.categoryModel});

  @override
  Widget build(BuildContext context) {
    if (isEdit == false) {
      AdminCubit.get(context).servicesChecked.clear();
      AdminCubit.get(context).isOffer = false;
    }
    if (isEdit && categoryModel != null) {
      nameController.text =
          categoryModel?.name == null ? '' : categoryModel!.name!;
      locationController.text =
          categoryModel?.location == null ? '' : categoryModel!.location!;
      facebookController.text =
          categoryModel?.facebook == null ? '' : categoryModel!.facebook!;
      whatsappController.text =
          categoryModel?.whatsapp == null ? '' : categoryModel!.whatsapp!;
      phoneController.text =
          categoryModel?.callNumber == null ? '' : categoryModel!.callNumber!;
      bankController.text =
          categoryModel?.bank == null ? '' : categoryModel!.bank!;
      aboutController.text =
          categoryModel?.about == null ? '' : categoryModel!.about!;
      newPriceController.text = categoryModel?.newPrice == null
          ? newPriceController.text
          : categoryModel!.newPrice!.toString();
      oldPriceController.text = categoryModel?.oldPrice == null
          ? oldPriceController.text
          : categoryModel!.oldPrice!.toString();

      AdminCubit.get(context).isOffer = categoryModel!.isOffer ?? false;
      AdminCubit.get(context).servicesChecked =
          categoryModel == null ? [] : categoryModel!.servicesChecked!;
    }
    // show loading dialog
    showLoadingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
    }

    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      return BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if (state is UpdateMyCategoryLoadingState) {
            return showLoadingDialog();
          }
          if (state is UpdateMyCategorySuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AdminCubit adminCubit = AdminCubit.get(context);
          AppCubit appCubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              leading: const BackButton(),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (isEdit) {
                        if (formKey.currentState!.validate() == true) {
                           await adminCubit.updateCategory(
                                  callNumber: phoneController.text,
                                  isOffer: adminCubit.isOffer,
                                  name: nameController.text,
                                  about: aboutController.text,
                                  newPrice: int.parse(newPriceController.text),
                                  oldPrice: int.parse(oldPriceController.text),
                                  facebook: facebookController.text,
                                  whatsapp: whatsappController.text,
                                  location: locationController.text,
                                  imgAssetPath: categoryModel!.imgAssetPath,
                                  from: "${appCubit.getDate().start.toLocal()}"
                                      .split(' ')[0],
                                  to: "${appCubit.getDate().end.toLocal()}"
                                      .split(' ')[0],
                                  isBooked: false,
                                  servicesChecked: adminCubit.servicesChecked,
                                  category: adminCubit.adminModel!.type!,
                                  thisCategoryUid: thisCategoryUid,
                                  bank: bankController.text,
                                );
                        Navigator.pop(context);
                          showSnackBar(
                            context: context,
                            text: 'جاري التحميل',
                            color: Colors.green,
                          ); } else {
                          showSnackBar(
                              color: Colors.amber,
                              context: context,
                              text: 'الرجاء إكمال الحقول');
                        }
                      } else {
                        if (formKey.currentState!.validate() == true &&
                            adminCubit.profileImage != null) {
                         await adminCubit.addCategory(
                                  callNumber: phoneController.text,
                                  isOffer: adminCubit.isOffer,
                                  name: nameController.text,
                                  about: aboutController.text,
                                  newPrice: int.parse(newPriceController.text),
                                  oldPrice: int.parse(oldPriceController.text),
                                  facebook: facebookController.text,
                                  whatsapp: whatsappController.text,
                                  location: locationController.text,
                                  imgAssetPath: adminCubit.profileImageUrl,
                                  from: "${appCubit.getDate().start.toLocal()}"
                                      .split(' ')[0],
                                  to: "${appCubit.getDate().end.toLocal()}"
                                      .split(' ')[0],
                                  isBooked: false,
                                  servicesChecked: adminCubit.servicesChecked,
                                  category: adminCubit.adminModel!.type!,
                                  bank: bankController.text,
                                );
                          Navigator.pop(context);
                          showSnackBar(
                            context: context,
                            text: 'جاري التحميل',
                            color: Colors.green,
                          );
                        } else if (adminCubit.profileImage == null) {
                          showSnackBar(
                              color: Colors.amber,
                              context: context,
                              text: 'الرجاء اضافة صوره');
                        } else {
                          showSnackBar(
                              color: Colors.amber,
                              context: context,
                              text: 'الرجاء إكمال الحقول');
                        }
                      }

                   
                    },
                    child: Text(
                      isEdit
                          ? 'تعديل ال${adminCubit.nameWithHotel}'
                          : 'إضافة ال${adminCubit.nameWithHotel}',
                      style: TextStyle(color: white),
                    )),
              ],
              title: Text(
                isEdit
                    ? 'تعديل ال${adminCubit.nameWithHotel}'
                    : 'إضافة ${adminCubit.nameWithHotel}',
                style: TextStyle(
                  color: white,
                ),
              ),
            ),
            body: adminCubit.adminModel == null
                ? Center(
                    child: defaultButton(
                        function: () {
                          navigateAndReplacement(context, LoginScreen());
                        },
                        text: 'سجل الدخول الآن',
                        width: MediaQuery.of(context).size.width - 40,
                        context: context),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                const Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 150,
                                        ),
                                      ],
                                    )),
                                Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      radius: 64,
                                      backgroundColor:
                                          Theme.of(context).dividerColor,
                                      child: isEdit == false &&
                                              adminCubit.profileImage != null
                                          ? CircleAvatar(
                                              radius: 60,
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(adminCubit
                                                      .profileImage!.path),
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : isEdit == false &&
                                                  adminCubit.profileImage ==
                                                      null
                                              ? CircleAvatar(
                                                  radius: 60,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .dividerColor,
                                                  child: defaultIconButton(
                                                      icon: Iconly_Broken.Image,
                                                      function: () {
                                                        adminCubit
                                                            .getProfileImage(
                                                                isCamera:
                                                                    false);
                                                      },
                                                      color: white))
                                              : adminCubit.profileImage == null
                                                  ? cacheImage(
                                                      url: adminCubit
                                                          .thisCategoryModel!
                                                          .imgAssetPath!,
                                                      width: 120,
                                                      height: 120,
                                                      shape: BoxShape.circle)
                                                  : CircleAvatar(
                                                      radius: 60,
                                                      child: ClipOval(
                                                        child: Image.file(
                                                          File(adminCubit
                                                              .profileImage!
                                                              .path),
                                                          width: 120,
                                                          height: 120,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                    ),
                                    if (isEdit == false &&
                                        adminCubit.profileImage != null)
                                      CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).dividerColor,
                                          child: defaultIconButton(
                                              icon: Iconly_Broken.Image,
                                              function: () {
                                                adminCubit.getProfileImage(
                                                    isCamera: false);
                                              },
                                              color: white)),
                                    if (isEdit)
                                      CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).dividerColor,
                                          child: defaultIconButton(
                                              icon: Iconly_Broken.Image,
                                              function: () {
                                                adminCubit.getProfileImage(
                                                    isCamera: false);
                                              },
                                              color: white))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                DefaultTextField(
                                    textForUnValid:
                                        'أدخل اسم ال${adminCubit.nameWithHotel}',
                                    controller: nameController,
                                    type: TextInputType.name,
                                    text: 'اسم ال${adminCubit.nameWithHotel}',
                                    prefix: Icons.home),
                                
                                DefaultTextField(
                                    textForUnValid: 'أدخل السعر بعد الخصم',
                                    controller: newPriceController,
                                    type: TextInputType.number,
                                    isValidNumber: true,
                                    text: 'السعر بعد الخصم',
                                    prefix: Icons.price_change),

                                DefaultTextField(
                                    textForUnValid: 'أدخل السعر قبل الخصم',
                                    controller: oldPriceController,
                                    type: TextInputType.number,
                                    isValidNumber: true,
                                    text: 'السعر قبل الخصم',
                                    prefix: Icons.price_change),

                                DefaultTextField(
                                    textForUnValid: 'أدخل العنوان',
                                    controller: locationController,
                                    type: TextInputType.text,
                                    text: 'العنوان',
                                    prefix: Icons.location_on),
                                DefaultTextField(
                                    maxLines: 3,
                                    textForUnValid: 'أدخل معلومات حول المكان',
                                    controller: aboutController,
                                    type: TextInputType.text,
                                    text: 'حول المكان',
                                    prefix: Icons.info_outline),
                                DefaultTextField(
                                    maxLines: 3,
                                    textForUnValid:
                                        'أدخل معلومات الحساب البنكي',
                                    controller: bankController,
                                    type: TextInputType.text,
                                    text: 'معلومات الحساب البنكي',
                                    prefix: FontAwesomeIcons.moneyBill),
                                 
                                    CheckboxListTile(
                                    title: const Text(
                                      'إضافة للعروض',
                                      textDirection: TextDirection.rtl,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4.0), // Optionally
                                      side:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    value: adminCubit.isOffer,
                                    onChanged: (newValue) {
                                      adminCubit.setIsOffer();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                              
                                DefaultTextField(
                                    textForUnValid: 'أدخل رقم واتس أب',
                                    controller: whatsappController,
                                    isValidNumber: true,
                                    type: TextInputType.number,
                                    text: 'رقم واتس أب',
                                    prefix: FontAwesomeIcons.whatsapp),

                                // call number
                                DefaultTextField(
                                    textForUnValid: 'أدخل رقم الهاتف',
                                    controller: phoneController,
                                    isValidNumber: true,
                                    type: TextInputType.number,
                                    text: 'رقم الهاتف',
                                    prefix: Icons.phone),
                                DefaultTextField(
                                    textForUnValid: 'أدخل رابط الفيس بوك',
                                    controller: facebookController,
                                    type: TextInputType.text,
                                    text: 'رابط الفيس بوك',
                                    prefix: FontAwesomeIcons.facebook),
                                SizedBox(
                                  height: 1700,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    itemCount: adminCubit.texts.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: CheckboxListTile(
                                          title: Text(adminCubit.texts[index]),
                                          value: adminCubit.servicesChecked
                                              .contains(
                                                  adminCubit.texts[index]),
                                          onChanged: (value) {
                                            adminCubit.changeCheckBox(value!,
                                                adminCubit.texts[index]);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: () {
                    adminCubit.getProfileImage(isCamera: true);
                    // adminCubit.chooseImage(true, isCamera: true);
                  },
                  child: const Icon(Icons.add_a_photo),
                ),
                const SizedBox(
                  height: 8,
                ),
                FloatingActionButton(
                  heroTag: 'gallery',
                  onPressed: () {
                    !adminCubit.uploading
                        ? adminCubit.getProfileImage(isCamera: false)
                        : null;
                  },
                  child: const Icon(Icons.photo_rounded),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
