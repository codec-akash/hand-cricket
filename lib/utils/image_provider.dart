import 'package:flutter/material.dart';

class ImageWidget {
  static getImage(
    String imageName, {
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    return Image.asset(
      imageName,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
