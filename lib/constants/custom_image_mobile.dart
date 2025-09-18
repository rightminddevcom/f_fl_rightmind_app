import 'package:flutter/material.dart';

Widget buildCustomImage(
    String url, {
      BoxFit fit = BoxFit.cover,
      double? width,
      double? height,
    }) {
  return Image.network(url, fit: fit, width: width, height: height);
}
