// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:edarhalfnadig/cubit/cubit.dart';
// import 'package:edarhalfnadig/cubit/states.dart';
// import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
// import 'package:edarhalfnadig/screens/web/side_menu.dart';
// import 'package:edarhalfnadig/shared/shared.dart';
// import 'package:edarhalfnadig/widgets/widgets.dart';

// class Responsive extends StatelessWidget {
//   final Widget mobile;
//   final Widget tablet;
//   final Widget desktop;

//   const Responsive({
//     Key? key,
//     required this.mobile,
//     required this.tablet,
//     required this.desktop,
//   }) : super(key: key);

// // This size work fine on my design, maybe you need some customization depends on your design

//   // This isMobile, isTablet, isDesktop helep us later
//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 650;

//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width < 890 &&
//       MediaQuery.of(context).size.width >= 650;

//   static bool isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 890;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       // If our width is more than 890 then we consider it a desktop
//       builder: (context, constraints) {
//         if (constraints.maxWidth >= 890) {
//           return desktop;
//         }
//         // If width it less then 890 and more then 650 we consider it as tablet
//         else if (constraints.maxWidth >= 650) {
//           return tablet;
//         }
//         // Or less then that we called it mobile
//         else {
//           return mobile;
//         }
//       },
//     );
//   }
// }

// class Desktop extends StatelessWidget {
//   const Desktop({Key? key, required this.widget}) : super(key: key);
//   final Widget widget;
//   @override
//   Widget build(BuildContext context) {

//     var size = MediaQuery.of(context).size;
//     return BlocConsumer<AppCubit, AppStates>(
//             listener: (context, state) {},
//             builder: (context, state) {
//         return Row(
//           children: [
//             Expanded(flex: size.width < 978 ? 160 : 100, child: widget),
//             // AppCubit.get(context).isOpen
//             true    ? Expanded(flex: size.width < 978 ? 90 : 40, child: SideMenu())
//                 : Expanded(
//                     flex: size.width < 978 ? 10 : 4,
//                     child: Container(
//                       alignment: Alignment.topCenter,
//                       width: 20,
//                       height: double.infinity,
//                       color: Theme.of(context).cardColor,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 20.0),
//                         child: IconButton(
//                             onPressed: () {
//                               // AppCubit.get(context).changeDrawer();
//                             },
//                             icon: Icon(
//                               Icons.menu,
//                               color: Theme.of(context).dividerColor,
//                             )),
//                       ),
//                     )),
//           ],
//         );
//       }
//     );
//   }
// }

// class MainResponsive extends StatelessWidget {
//   final Widget? mobile;
//   final Widget ?tablet;
//   final Widget ?desktop;
//  final PreferredSizeWidget? appBar;
//    MainResponsive({
//     Key? key,
//      this.mobile,
//      this.tablet,
//      this.desktop,
//      this.appBar,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var cubit = AppCubit.get(context);
   
//         return BlocConsumer<AppCubit, AppStates>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return Scaffold(
//                   extendBodyBehindAppBar: true,
//                   appBar:appBar!=null && Responsive.isMobile(context)||Responsive.isMobile(context)?appBar:
//                       Responsive.isDesktop(context) ?null:
//                          appBar==null?  myAppBar(AppCubit.get(context)):null
//                           ,
//                 body: Responsive(
//                     mobile: mobile??cubit.navItem[cubit.currentIndex],
//                     tablet: tablet??cubit.navItem[cubit.currentIndex],
//                     desktop: Desktop(widget: desktop??cubit.navItem[cubit.currentIndex],)),
//                 bottomNavigationBar:
//                     Responsive.isMobile(context) || Responsive.isTablet(context)
//                         ? BottomNavbar(cubit: AppCubit.get(context))
//                         : const SizedBox(),
//               );
//             });
     
//   }
// }
