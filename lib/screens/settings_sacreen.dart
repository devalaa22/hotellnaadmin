import 'dart:io';

import 'package:edarhalfnadig/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:edarhalfnadig/cubit/states.dart';
import 'package:edarhalfnadig/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات'),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 4,
              ),
              SettingsTile(
                  isSwitched: true,
                  isSwitching: cubit.isDark,
                  title: 'الوضع الليلي',
                  onTap: () {
                    cubit.changeMode();
                  }),
              SettingsTile(
                  icon: Icons.star_border_rounded,
                  title: 'تقييم التطبيق',
                  onTap: () async {
                    // if (!await launch(
                    //     'https://play.google.com/store/apps/details?id=com.hdev.kmsarf')) {}
                  }),
              SettingsTile(
                icon: Icons.share,
                title: 'مشاركة التطبيق',
                onTap: () {
                  // Share.share(
                  //     "إن كنت بحاجة لمتابعة أسعار صرف الدولار والعملات الأجنبية في الجمهورية اليمنية مقابل بعض العملات الاجنبية المتداولة لحظة بلحظة فإن هذا التطبيق سيكون خيارك الأمثل   \n\nلمعرفة المزيد قم بتحميل تطبيق ' كم الصرف ' لاسعار الصرف من متجر جوجل بلاي على الرابط ادناه : https://play.google.com/store/apps/details?id=com.hdev.kmsarf");
                },
              ),
              SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'تسجيل الخروج',
                  onTap: () {
                    cubit.logOut(context);
                  }),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      DefaultText(
                        text: 'إدارة الفنادق',
                        color: Theme.of(context).dividerColor,
                      ),
                      DefaultText(
                        text: applicationVersion,
                        isHedline6: true,
                        color: Theme.of(context).dividerColor,
                      ),
                      DefaultText(
                        text: '©$applicationNameEn ${DateTime.now().year}',
                        isHedline6: true,
                        color: Theme.of(context).dividerColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                 // ComunicationIcons(
                  //     url: 'http://Fondgak.com',
                  //     icondata: FontAwesomeIcons.chrome),
                  const ComunicationIcons(
                      url:
                          'mailto:mailto:salembajri6@gmail.com?subject= استفسار بخصوص&body= يرجى كتابة الاستفسار الذي تريد',
                      icondata:  Icons.mail),
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
                      Text(
                        'تطبيق جميل ورائع يمكنك من البحث عن الفنادق والقاعات والشقق بكل سهولة',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ],
                  ))
            ],
          )),
        );
      },
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool? isSwitched;
  final bool? isSwitching;
  final void Function(bool)? toggleSwitch;
  final void Function()? onTap;

  const SettingsTile(
      {super.key,
      required this.title,
      this.isSwitched = false,
      this.icon,
      this.isSwitching,
      this.toggleSwitch,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.only(top: 8.0),
      onPressed: onTap,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: Theme.of(context).dividerColor,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: isSwitched!
                ? Switch(
                    trackColor: WidgetStateProperty.all(isSwitching!
                        ? Colors.green.shade100
                        : Colors.grey.shade100),
                    thumbColor: WidgetStateProperty.all(
                        isSwitching! ? Colors.green : Colors.grey),
                    onChanged: toggleSwitch,
                    value: isSwitching!,
                  )
                : Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
