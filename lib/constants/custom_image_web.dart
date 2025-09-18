
import 'package:flutter/material.dart';

Widget buildCustomImage(
    String url, {
      BoxFit fit = BoxFit.cover,
      double? width,
      double? height,
    }) {
  // لازم يكون لكل URL viewType فريد
  // final viewType = url.hashCode.toString();
  //
  // // Register once
  // // ui.platformViewRegistry.registerViewFactory(
  // //   viewType,
  // //       (int viewId) => html.ImageElement()
  // //     ..src = url
  // //     ..style.objectFit = fit.toString().split('.').last,
  // // );
  //
  // return HtmlElementView(viewType: viewType);
  return SizedBox.shrink();
}
