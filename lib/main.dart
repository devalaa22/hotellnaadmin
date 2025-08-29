import 'dart:io';

import 'package:edarhalfnadig/shared/hand.dart';
import 'package:edarhalfnadig/shared/notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/login_cubit/login_cubit.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/cubit/admin_cubit/admin_cubit.dart';
import 'package:edarhalfnadig/firebase_options.dart';
import 'package:edarhalfnadig/screens/screens.dart';
import 'package:edarhalfnadig/shared/shared.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
     if (notification != null && android != null) {
      LocalNotificationService.display(message);
    }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ---------- Firebase Messaging ----------
  LocalNotificationService.initialize();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
 
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      LocalNotificationService.display(message);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
              child: Material(
                color: Colors.transparent,
                child: AlertDialog(
                  title: Text(event.notification!.title ??
                      ''), // To display the title it is optional
                  content: Text(event.notification!.body ?? ''),
                ),
              ),
            ));
  });
 myToken = await messaging.getToken();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData('isDark') ?? false;
  bool showOnBoard = CacheHelper.getData('ShowOnBoard') ?? true;
  bool afterLoginOrRegister =
      CacheHelper.getData('afterLoginOrRegister') ?? false;
  Bloc.observer = MyBlocObserver();
  adminUid = CacheHelper.getData('adminUid') ?? '';
  thisCategoryUid = CacheHelper.getData('thisCategoryUid') ?? '';
  type = CacheHelper.getData('type') ?? '';

  Widget widget = showOnBoard == true
      ? const OnBoardingScreen()
      : adminUid == null || adminUid == ''
          ? LoginScreen()
          : HomeScreen();

  runApp(MyApp(
      startWidget: widget,
      isDark: isDark,
      afterLoginOrRegister: afterLoginOrRegister));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final bool? afterLoginOrRegister;
  final Widget startWidget;

  const MyApp({
    super.key,
    this.isDark,
    this.afterLoginOrRegister,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) {
          if (afterLoginOrRegister == false) {
            return AdminCubit();
          } else {
            return AdminCubit()
              ..getAdminData()
              ..getNames()
              ..getMyCategory();
          }
        }),
        BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeMode(fromCache: isDark)
              ..stream
              ..getAllOnBoardings()),
        BlocProvider(
          create: (context) => LoginCubit()..getAllAdmins(),
        ),
      ],
      child: BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
        var cubit = AppCubit.get(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: startWidget,
          themeMode: cubit.appMode,
          theme: darkMode(),
          darkTheme: lightMode(),
        );
      }),
    );
  }
}
