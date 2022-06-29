import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget homeHeader() {
  return VStack([
    "Hey there".text.white.xl3.semiBold.textStyle(GoogleFonts.poppins()).make(),
    "Welcome home!".text.white.xl4.bold.textStyle(GoogleFonts.poppins()).make(),
  ]);
}
