import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/utils/image_provider.dart';

class RunButtons extends StatelessWidget {
  final String run;
  final Function()? onTap;
  const RunButtons({
    super.key,
    required this.run,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        child: ImageWidget.getImage(
          run,
          height: 100.h,
          width: 100.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
