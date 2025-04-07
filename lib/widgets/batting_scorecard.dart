import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BattingScorecard extends StatelessWidget {
  final List<int> runsHistory;
  final int maxBalls;

  const BattingScorecard({
    super.key,
    required this.runsHistory,
    this.maxBalls = 6,
  });

  @override
  Widget build(BuildContext context) {
    // Build a list of 6 widgets (one for each potential ball)
    List<Widget> runWidgets = List.generate(maxBalls, (index) {
      // If we have data for this position, show the run
      if (index < runsHistory.length) {
        return _buildRunItem(runsHistory[index]);
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

  Widget _buildRunItem(int run) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      child: Center(
        child: Text(
          '$run',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
    );
  }
}
