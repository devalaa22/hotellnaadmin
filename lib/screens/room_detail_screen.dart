import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/models/model.dart';
import 'package:edarhalfnadig/screens/edit_room_screen.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key, required this.room});

  final List<IconData> icon = [
    Icons.room_service,
    Icons.restaurant,
    Icons.wifi,
    Icons.coffee,
    Icons.local_laundry_service,
    Icons.local_parking,
    Icons.dry_cleaning,
  ];

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    return RoomDetailScreenOne(room: room);
  }
}

class RoomDetailScreenOne extends StatelessWidget {
  RoomDetailScreenOne({super.key, required this.room});

  final List<IconData> icon = [
    Icons.room_service,
    Icons.restaurant,
    Icons.wifi,
    Icons.coffee,
    Icons.local_laundry_service,
    Icons.local_parking,
    Icons.dry_cleaning,
  ];

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(room.name!),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BaseAlertDialog(
                    title: "هل تريد الحذف",
                    content: "${room.name}",
                    yesOnPressed: () {
                      cubit.deleteRoomFromHotel(
                        roomId: room.roomId!,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'تم الحذف بنجاح',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
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
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  room.roomImage == null
                      ? Image.asset(
                          "assets/room.jpeg",
                          fit: BoxFit.cover,
                          height: 210,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Stack(
                          children: [
                            SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 400.0,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                ),
                                items: room.roomImage!.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return cacheImage(
                                        url: i,
                                        height: 410,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            Positioned(
                                bottom: 20,
                                right: 20,
                                child: CircleAvatar(
                                  child:
                                      Text(room.roomImage!.length.toString()),
                                ))
                          ],
                        ),
                  SizedBox(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        return defaultIconButton(
                            color: Theme.of(context).dividerColor,
                            icon: icon[index],
                            function: () {});
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: icon.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        RoomDetailTile(
                          text: "اسم الغرفة : ${room.name!}",
                          icon: Icons.night_shelter,
                        ),
                        RoomDetailTile(
                          text: "سعر الليلة : ${room.newPrice!}",
                          icon: Icons.attach_money,
                        ),
                        RoomDetailTile(
                          text: "السعر قبل الخصم : ${room.oldPrice!}",
                          icon: Icons.attach_money,
                        ),
                        RoomDetailTile(
                          text: "عن الغرفة : ${room.des}",
                          icon: Icons.info,
                        ),
                        RoomDetailTile(
                          text: "رقم الدور : ${room.level!}",
                          icon: Icons.layers,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: defaultButton(
                hasIcon: true,
                icon: Iconly_Broken.Edit,
                context: context,
                function: () {
                  navigateTo(
                    context,
                    EditRoomScreen(
                      isCopy: false,
                      room: room,
                    ),
                  );
                },
                text: 'تعديل معلومات الغرفة',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: defaultButton(
                hasIcon: true,
                icon: Icons.copy,
                context: context,
                function: () {
                  navigateTo(
                    context,
                    EditRoomScreen(
                      isCopy: true,
                      room: room,
                    ),
                  );
                },
                text: 'نسخ معلومات الغرفة',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class RoomDetailTile extends StatelessWidget {
  const RoomDetailTile({
    super.key,
    required this.text,
    required this.icon,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        textDirection: TextDirection.rtl,
      ),
      trailing: Icon(icon),
    );
  }
}
