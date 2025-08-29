// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/screens/settings_sacreen.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';
import 'package:edarhalfnadig/shared/shared.dart';

String? myToken;
String applicationVersion = '0.0.24';
String applicationNameAr = 'إدارة الفنادق';
String applicationNameEn = 'Fondgak';
String? adminUid;
String? thisCategoryUid;
String? type;
bool afterLoginOrRegister =
    CacheHelper.getData('afterLoginOrRegister') ?? false;

navigateAndReplacement(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigateTo(BuildContext context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

AppBar myAppBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Iconly_Broken.Setting,
          size: 25, color: Theme.of(context).dividerColor),
      onPressed: () => navigateTo(context, const SettingsScreen()),
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light),
    elevation: 0,
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
          onPressed: () {
            // open drawer function
            scaffoldKey.currentState!.openEndDrawer();
          },
          icon:
              Icon(Icons.menu_rounded, color: Theme.of(context).dividerColor)),
    ],
  );
}

Future showAboutAppDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '$applicationVersion $applicationNameAr',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Text(
                '©$applicationNameEn ${DateTime.now().year}',
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ComunicationIcons(
                  //     url: 'http://Fondgak.com',
                  //     icondata: FontAwesomeIcons.chrome),
                  const ComunicationIcons(
                      url:
                          'mailto:mailto:salembajri6@gmail.com?subject= استفسار بخصوص&body= يرجى كتابة الاستفسار الذي تريد',
                      icondata: Icons.mail),
                  ComunicationIcons(
                      url: Platform.isAndroid
                          ? "https://wa.me/967770468847"
                          : "https://api.whatsapp.com/send?phone=967770468847",
                      icondata: FontAwesomeIcons.whatsapp),
                  const ComunicationIcons(
                      url:
                          'https://www.facebook.com/pg/%D9%81%D9%86%D8%AF%D9%82%D9%83-110021575016410/groups/',
                      icondata: FontAwesomeIcons.facebook),
                  const ComunicationIcons(
                      url: 'https://instagram.com/fundqak?r=nametag',
                      icondata: FontAwesomeIcons.instagram),
                ],
              ),
              const Text(
                'تطبيق جميل ورائع يمكنك من البحث عن الفنادق والقاعات والشقق بكل سهولة',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('رجوع'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

Widget defaultButton({
  double width = double.infinity,
  double height = 45,
  bool hasIcon = false,
  IconData? icon,
  required BuildContext? context,
  Color? color,
  double? fontSize = 17,
  required Function function,
  required String text,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: MaterialButton(
          color: color ?? Theme.of(context!).dividerColor,
          onPressed: () {
            function();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasIcon)
                Icon(
                  icon ?? Icons.add,
                  color: Colors.white,
                ),
              if (hasIcon)
                const SizedBox(
                  width: 8,
                ),
              Expanded(
                child: Text(
                  text.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget cacheImage({
  required String url,
  required double width,
  required double height,
  BoxShape shape = BoxShape.rectangle,
}) {
  return CachedNetworkImageBuilder(
    url: url,
    builder: (image) {
      return Container(
        clipBehavior: Clip.hardEdge,
        width: width,
        height: height,
        decoration: url == ''
            ? BoxDecoration(
                shape: shape,
              )
            : BoxDecoration(
                shape: shape,
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
        child: url == '' ? const Center(child: Text('لا توجد صورة')) : null,
      );
    },
    // Optional Placeholder widget until image loaded from url
    placeHolder: const Center(child: CircularProgressIndicator()),
    // Optional error widget
    errorWidget: Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      decoration: url == ''
          ? BoxDecoration(
              shape: shape,
            )
          : BoxDecoration(
              shape: shape,
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
      child: url == '' ? const Center(child: Text('لا توجد صورة')) : null,
    ),
    // Optional describe your image extensions default values are; jpg, jpeg, gif and png
  );
}

void showSnackBar({
  required BuildContext context,
  required String text,
  Color color = Colors.amber,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: color,
      content: Text(
        text,
        textDirection: TextDirection.rtl,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(color: Colors.black),
      ),
    ),
  );
}

Widget defaultIconButton(
    {required IconData icon, required var function, color}) {
  return IconButton(
      onPressed: function,
      icon: Icon(
        icon,
        color: color ?? Colors.black,
      ));
}

class BookingDate extends StatelessWidget {
  const BookingDate({
    super.key,
    required this.text,
    required this.startOrEnd,
    this.taped = true,
  });

  final String text;
  final bool taped;
  final String startOrEnd;

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return InkWell(
      onTap: () {
        taped ? cubit.selectDateRange(context) : null;
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          DefaultText(
            text: text,
            color: Colors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Icon(Icons.date_range_rounded, color: Colors.white),
              const Spacer(),
              DefaultText(
                text: startOrEnd,
                color: Colors.white,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
