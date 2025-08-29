import 'package:flutter/material.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/shared/shared.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    required this.cubit,
  });
  final AppCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Iconly_Broken.Notification), label: 'طلبات الحجز'),
        BottomNavigationBarItem(
            icon: Icon(Iconly_Broken.Activity), label: 'الأرشيف'),
        BottomNavigationBarItem(
            icon: Icon(Iconly_Broken.User), label: ' الملف الشخصي'),
      ],
      currentIndex: cubit.currentIndex,
      onTap: (index) {
        cubit.changeBottomNav(index);
      },
      unselectedItemColor: Colors.grey.shade500,
    );
  }
}
