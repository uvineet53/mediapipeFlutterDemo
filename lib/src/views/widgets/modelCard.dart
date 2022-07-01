import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class ModelCard extends StatefulWidget {
  final String title;
  const ModelCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _ModelCardState createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  final double _width = Get.width;
  late double _radius;
  late Color _color;

  @override
  void initState() {
    super.initState();

    Timer.periodic(2.seconds, (timer) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    _color = Color.fromRGBO(
      random.nextInt(250),
      random.nextInt(250),
      random.nextInt(250),
      1,
    );

    _radius = random.nextInt(100).toDouble();
    return VxAnimatedBox(
      child: widget.title.text.semiBold.xl3.white
          .textStyle(GoogleFonts.poppins())
          .makeCentered(),
    )
        .alignCenter
        .seconds(sec: 5)
        .fastOutSlowIn
        .width(_width)
        .height(Get.height * .1)
        .color(_color)
        .withRounded(value: _radius)
        .p12
        .make();
  }
}
