import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget tagBuilder(String heading) {
  return heading.text.gray400.xl2.semiBold.make().pSymmetric(v: 10);
}
