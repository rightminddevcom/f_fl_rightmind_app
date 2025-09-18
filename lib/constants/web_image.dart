import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'custom_image_mobile.dart'
if (dart.library.html) 'custom_image_web.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const CustomImage(
      this.url, {
        this.fit = BoxFit.cover,
        this.width,
        this.height,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return buildCustomImage(url, fit: fit, width: width, height: height);
  }
}
