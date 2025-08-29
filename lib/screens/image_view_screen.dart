import 'package:flutter/material.dart';
import 'package:edarhalfnadig/shared/shared.dart';

class ImageViewScreen extends StatefulWidget {
  final String image;

  const ImageViewScreen({super.key, required this.image});

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Imagev(image: widget.image));
  }
}

class Imagev extends StatelessWidget {
  const Imagev({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: cacheImage(
            url: image,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2),
      ),
    );
  }
}
