import 'package:edarhalfnadig/shared/components.dart'; 
import 'package:flutter/material.dart'; 
import 'package:url_launcher/url_launcher.dart';

class ComunicationIcons extends StatelessWidget {
  const ComunicationIcons({
    super.key,
    required this.url,
    required this.icondata,
  });

  final String url;

  final IconData icondata;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication, );
        } else {
          // throw 'Could not launch $url';
          showSnackBar(
            context: context,
            text: 'الرابط غير صحيح',
            color: Colors.red,
          );
        }
      },
      icon: Icon(icondata),
      color: Theme.of(context).dividerColor,
    );
  }
}
