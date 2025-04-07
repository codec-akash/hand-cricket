import 'package:flutter/material.dart';
import 'package:hand_cricke/widgets/batting_scorecard.dart';
import 'package:hand_cricke/widgets/bowling_scorecard.dart';

class ScoreCard extends StatefulWidget {
  final List<int> runsHistory;
  const ScoreCard({
    super.key,
    required this.runsHistory,
  });

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: BattingScorecard(
              runsHistory: widget.runsHistory,
            ),
          ),
          Expanded(
            child: BowlingScorecard(
              ballBowled: widget.runsHistory.length,
            ),
          )
        ],
      ),
    );
  }
}
