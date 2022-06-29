import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget homeCards(Map<String, String> data) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: .7,
              image: CachedNetworkImageProvider(data['image'].toString()),
              fit: BoxFit.fill),
        ),
        child: data['title'].toString().text.xl2.semiBold.white.makeCentered(),
      ),
    ),
  );
}
