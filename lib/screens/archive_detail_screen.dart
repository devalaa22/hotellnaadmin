import 'package:flutter/material.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/models/checkout_model.dart';

class ArchiveDetailScreen extends StatelessWidget {
  const ArchiveDetailScreen({
    super.key,
    required this.archive,
  });
  final CheckoutModel archive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(archive.name!),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ArchiveDetailTile(
                    text: "الاسم : ${archive.name!}",
                    icon: Icons.account_circle_rounded,
                  ),
                  ArchiveDetailTile(
                    text: "اسم الحجز: ${archive.roomName!}",
                    icon: Icons.business_sharp,
                  ),
                  ArchiveDetailTile(
                    text:
                        "عدد الليالي : ${AppCubit.get(context).getDaysInBetween(
                              DateTime.parse(archive.from!),
                              DateTime.parse(archive.to!),
                            ).length - 1}",
                    icon: Icons.night_shelter,
                  ),
                  ArchiveDetailTile(
                    text:
                        "المجموع : ${archive.price! * (AppCubit.get(context).getDaysInBetween(
                              DateTime.parse(archive.from!),
                              DateTime.parse(archive.to!),
                            ).length - 1)}",
                    icon: Icons.money,
                  ),
                  ArchiveDetailTile(
                    text: "سعر الليلة: ${archive.price!}",
                    icon: Icons.attach_money,
                  ),
                  ArchiveDetailTile(
                    text: "رقم الحجز :${archive.bookId!.substring(0, 7)}",
                    icon: Icons.book_online_rounded,
                  ),
                  ArchiveDetailTile(
                    text: "رقم الدور : ${archive.level!}",
                    icon: Icons.layers,
                  ),
                  ArchiveDetailTile(
                    text: "الحالة  : ${archive.isBooked! ? 'محجوزة' : 'متاحة'}",
                    icon: Icons.book,
                  ),
                  ArchiveDetailTile(
                    text: "من تاريخ: ${archive.from!}",
                    icon: Icons.date_range_rounded,
                  ),
                  ArchiveDetailTile(
                    text: "إلى تاريخ: ${archive.to!}",
                    icon: Icons.date_range_rounded,
                  ),
                  ArchiveDetailTile(
                    text: "الموقع : ${archive.location!}",
                    icon: Icons.room,
                  ),
                  ArchiveDetailTile(
                    text: "رقم الجواز: ${archive.passport!}",
                    icon: Icons.badge_outlined,
                  ),
                  ArchiveDetailTile(
                    text: "رقم الهاتف: ${archive.phone!}",
                    icon: Icons.contact_phone_rounded,
                  ),
                  ArchiveDetailTile(
                    text: "عن  : ${archive.des}",
                    icon: Icons.info,
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
          ],
        ),
      ),
    );
  }
}

class ArchiveDetailTile extends StatelessWidget {
  const ArchiveDetailTile({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).dividerColor,
        ),
        textDirection: TextDirection.rtl,
      ),
      trailing: Icon(
        icon,
        color: Colors.red,
      ),
    );
  }
}
