import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/utils/image_path.dart';
import 'package:hand_cricke/utils/image_provider.dart';

class BowlingScorecard extends StatelessWidget {
  final int maxBalls;
  final int ballBowled;

  const BowlingScorecard({
    super.key,
    required this.ballBowled,
    this.maxBalls = 6,
  });

  @override
  Widget build(BuildContext context) {
    // Build a list of 6 widgets (one for each potential ball)
    List<Widget> runWidgets = List.generate(maxBalls, (index) {
      // If we have data for this position, show the run
      if (index < ballBowled) {
        return _buildBowledBall();
      }
      // Otherwise show an empty container for proper spacing
      return _buildEmptyItem();
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.5,
        children: runWidgets,
      ),
    );
  }

  Widget _buildBowledBall() {
    return AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 500),
        child: ballIcon());
  }

  Widget _buildEmptyItem() {
    return AnimatedOpacity(
        opacity: 0.5,
        duration: const Duration(milliseconds: 500),
        child: ballIcon());
  }

  Widget ballIcon() {
    return SizedBox(
      height: 20.h,
      width: 20.w,
      child: ImageWidget.getImage(ImagePath.ball),
    );
  }
}
