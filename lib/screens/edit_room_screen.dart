import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_states.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class EditRoomScreen extends StatelessWidget {
  EditRoomScreen({super.key, required this.room, required this.isCopy});
  final RoomModel room;
  final bool isCopy;
  final nameController = TextEditingController();
  final desController = TextEditingController();
  final newPriceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final levelController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AdminCubit adminCubit = AdminCubit.get(context);
    nameController.text = room.name == null ? '' : room.name!;
    desController.text = room.des == null ? '' : room.des!;
    newPriceController.text = room.newPrice.toString();
    oldPriceController.text = room.oldPrice.toString();
    levelController.text = room.level.toString(); 
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {
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
                      adminCubit.uploading = true;
                      adminCubit
                          .uploadFile()
                          .then((value) {
                            for (var image in adminCubit.imageUrl) {
                              room.roomImage!.add(image);
                            }
                          })
                          .then((value) => adminCubit.updateHotelRoom(
                                isCopy: isCopy,
                                name: nameController.text,
                                des: desController.text,
                                newPrice: int.parse(newPriceController.text),
                                oldPrice: int.parse(oldPriceController.text),
                                level: int.parse(levelController.text),
                                roomImage: room.roomImage!,
                                bank: room.bank!,
                                from: room.from!,
                                to: room.to!,
                                roomId: room.roomId!,
                                hotelName: adminCubit.adminModel!.name!,
                              ))
                          .then((value) {
                            adminCubit.uploading = false;
                            adminCubit.images.clear();
                            adminCubit.imageUrl.clear();
                          })
                          .then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                      Navigator.pop(context);
                    },
                    noOnPressed: () {
                      adminCubit.uploading = false;
                      adminCubit.images.clear();
                      adminCubit.imageUrl.clear();
                      Navigator.pop(context);
                    }));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Iconly_Broken.Arrow___Left_2,
                color: white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              isCopy ? 'إضافة غرفة جديدة' : 'تعديل معلومات الغرفة',
              style: TextStyle(
                color: white,
              ),
            ),
          ),
          body: room.name == null
              ? Center(
                  child: defaultButton(
                      context: context,
                      function: () {
                        // navigateTo(context, NewCtegoryScreen());
                      },
                      text: 'إضافة غرفة',
                      width: MediaQuery.of(context).size.width - 40),
                )
              : adminCubit.uploading == true
                  ? const Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'جاري التحميل',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          // value: cubit.val,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
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
                              child: room.roomImage!.isEmpty
                                  ? Center(
                                      child: DefaultText(text: 'أضف صورة'),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: room.roomImage!.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: 220,
                                              margin: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(room
                                                          .roomImage![index]),
                                                      fit: BoxFit.cover)),
                                            ),
                                            IconButton(
                                                onPressed: () =>
                                                    adminCubit.removeFromEdited(
                                                        index, room.roomImage!),
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
                                      context: context,
                                      hasIcon: true,
                                      icon: isCopy
                                          ? Icons.add_circle_outline
                                          : Iconly_Broken.Edit,
                                      function: () async {
                                        if (formKey.currentState!.validate() ==
                                                true &&
                                            room.roomImage!.isNotEmpty) {
                                          adminCubit.updateHotelRoom(
                                            isCopy: isCopy,
                                            name: nameController.text,
                                            des: desController.text,
                                            newPrice: int.parse(
                                                newPriceController.text),
                                            oldPrice: int.parse(
                                                oldPriceController.text),
                                            level:
                                                int.parse(levelController.text),
                                            roomImage: room.roomImage!,
                                            roomId: room.roomId!,
                                            hotelName:
                                                adminCubit.adminModel!.name!,
                                            bank: adminCubit
                                                .thisCategoryModel!.bank!,
                                            from: room.from ?? '',
                                            to: room.to ?? "",
                                          );

                                          showSnackBar(
                                              context: context,
                                              text: 'جاري التحميل',
                                              color: Colors.green);

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else if (room.roomImage!.isNotEmpty ||
                                            formKey.currentState!.validate() ==
                                                false) {
                                          showSnackBar(
                                              color: Colors.amber,
                                              context: context,
                                              text: 'الرجاء إكمال الحقول');
                                        } else {
                                          showSnackBar(
                                              color: Colors.amber,
                                              context: context,
                                              text: 'الرجاء إكمال الحقول');
                                        }
                                      },
                                      text: isCopy
                                          ? 'إضافة غرفة جديدة'
                                          : 'تطبيق التعديلات',
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      fontSize: 14),
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
                  if (room.roomImage!.length < 10) {
                    if (formKey.currentState!.validate() == true) {
                      adminCubit.chooseImage(false, isCamera: true);
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
                  if (room.roomImage!.length < 10) {
                    if (formKey.currentState!.validate() == true) {
                      adminCubit.chooseImage(false, isCamera: false);
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
                child: const Icon(Icons.photo_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}
