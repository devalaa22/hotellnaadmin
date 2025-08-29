import 'package:edarhalfnadig/screens/add_new_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class AddNewRoomScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final desController = TextEditingController();
  final newPriceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final levelController = TextEditingController();
  final List<String> roomImage = [];

  final formKey = GlobalKey<FormState>();

  AddNewRoomScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AdminCubit adminCubit = AdminCubit.get(context);
        AppCubit appCubit = AppCubit.get(context);

        var from = "${appCubit.getDate().start.toLocal()}".split(' ')[0] ==
                "${appCubit.initalDateRange.start.toLocal()}".split(' ')[0]
            ? adminCubit.thisCategoryModel?.from
            : "${appCubit.selectedDateRange!.start.toLocal()}".split(' ')[0];
        var to = "${appCubit.getDate().end.toLocal()}".split(' ')[0] ==
                "${appCubit.initalDateRange.end.toLocal()}".split(' ')[0]
            ? adminCubit.thisCategoryModel?.to
            : "${appCubit.selectedDateRange!.end.toLocal()}".split(' ')[0];
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            leading: adminCubit.uploading
                ? const SizedBox()
                : IconButton(
                    icon: Icon(
                      Iconly_Broken.Arrow___Left_2,
                      color: white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      adminCubit.images.clear();
                      adminCubit.imageUrl.clear();
                    },
                  ),
            title: Text(
              'إضافة غرفة جديدة',
              style: TextStyle(
                color: white,
              ),
            ),
          ),
          body: adminCubit.categoryModel == null
              ? Center(
                  child: defaultButton(
                      function: () {
                        navigateTo(
                            context,
                            AddNewCategoryScreen(
                              isEdit: false,
                            ));
                      },
                      text: 'إضافة فندق جديد',
                      width: MediaQuery.of(context).size.width - 40,
                      context: context),
                )
              : adminCubit.uploading
                  ? const Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.green,
                        )
                      ],
                    ))
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: adminCubit.images.isEmpty
                                  ? Center(
                                      child: DefaultText(text: 'أضف صورا الآن'))
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: adminCubit.images.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: 220,
                                              margin: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: MemoryImage(
                                                          adminCubit
                                                              .images[index]),
                                                      fit: BoxFit.cover)),
                                            ),
                                            IconButton(
                                                onPressed: () => adminCubit
                                                    .removeFromSelected(index),
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
                                                ))
                                          ],
                                        );
                                      }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  DefaultTextField(
                                      textForUnValid: 'أدخل الاسم',
                                      controller: nameController,
                                      type: TextInputType.name,
                                      text: 'الاسم',
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
                                  // SettingsTile(
                                  //   isSwitched: true,
                                  //   isSwitching: adminCubit.isOffer,
                                  //   title: 'إضافة للعروض',
                                  //   onTap: () {
                                  //     adminCubit.setIsOffer();
                                  //   }),
                                  DefaultTextField(
                                      textForUnValid: 'أدخل معلومات حول الغرفة',
                                      controller: desController,
                                      type: TextInputType.text,
                                      text: 'حول الغرفة',
                                      prefix: Iconly_Broken.Info_Circle),
                                  DefaultTextField(
                                      isValidNumber: true,
                                      textForUnValid: 'أدخل رقم الدور',
                                      controller: levelController,
                                      type: TextInputType.text,
                                      text: 'رقم الدور',
                                      prefix: Icons.arrow_circle_up),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  defaultButton(
                                      hasIcon: true,
                                      icon: Icons.add_circle_outline,
                                      function: () async {
                                        if (adminCubit.images.isNotEmpty &&
                                            formKey.currentState!.validate() ==
                                                true) {
                                          adminCubit.uploading = true;
                                          await adminCubit
                                              .uploadFile()
                                              .whenComplete(
                                                () async => await adminCubit
                                                    .addHotelRoom(
                                                  name: nameController.text,
                                                  des: desController.text,
                                                  newPrice: int.parse(
                                                      newPriceController.text),
                                                  oldPrice: int.parse(
                                                      newPriceController.text),
                                                  level: int.parse(
                                                      levelController.text),
                                                  roomImage:
                                                      adminCubit.imageUrl,
                                                  from: from!,
                                                  hotelName: adminCubit
                                                      .thisCategoryModel!.name!,
                                                  to: to!,
                                                  bank: adminCubit
                                                      .thisCategoryModel!.bank!, 
                                                ),
                                              );

                                          Navigator.of(context).pop();
                                          showSnackBar(
                                              context: context,
                                              text: 'جاري التحميل',
                                              color: Colors.green);
                                        } else if (adminCubit.images.isEmpty &&
                                            formKey.currentState!.validate() ==
                                                false) {
                                          showSnackBar(
                                              color: Colors.amber,
                                              context: context,
                                              text:
                                                  'الرجاء إكمال الحقول واضافة صور');
                                        } else if (adminCubit.images.isEmpty &&
                                            formKey.currentState!.validate() ==
                                                true) {
                                          showSnackBar(
                                              color: Colors.amber,
                                              context: context,
                                              text: 'الرجاء اضافة صور');
                                        } else {
                                          showSnackBar(
                                              color: Colors.amber,
                                              context: context,
                                              text: 'الرجاء إكمال الحقول');
                                        }
                                      },
                                      text: 'إضافة غرفة جديدة',
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      fontSize: 14,
                                      context: context),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
          floatingActionButton:!adminCubit.uploading? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'camera',
                onPressed: () {
                  if (adminCubit.images.length < 10) {
                    if (formKey.currentState!.validate() == true) {
                      adminCubit.chooseImage(true, isCamera: true);
                    } else {
                      showSnackBar(
                          context: context,
                          text: "يرجى تحديد صورة",
                          color: Colors.amberAccent);
                    }
                  } else {
                    showSnackBar(
                        color: Colors.amberAccent,
                        context: context,
                        text: 'اقصى عدد من الصور يمكن إضافتها 10');
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
                  if (adminCubit.images.length < 10) {
                    !adminCubit.uploading
                        ? adminCubit.chooseImage(true, isCamera: false)
                        : null;
                  } else {
                    showSnackBar(
                        color: Colors.amberAccent,
                        context: context,
                        text: 'اقصى عدد من الصور يمكن إضافتها 10');
                  }
                },
                child: const Icon(Icons.photo_rounded),
              ),
            ],
          ):null,
        );
      },
    );
  }
}
