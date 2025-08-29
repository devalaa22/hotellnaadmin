import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/shared/shared.dart';
import 'package:edarhalfnadig/widgets/drawer.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      final cubit = AppCubit.get(context);
      return Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: myAppBar(context, scaffoldKey),
        endDrawer: myDrawer(
          cubit: cubit,
          context: context,
        ),
        body: cubit.navItem[cubit.currentIndex],
        bottomNavigationBar: BottomNavbar(
          cubit: cubit,
        ),
      );
    });
  }
}
