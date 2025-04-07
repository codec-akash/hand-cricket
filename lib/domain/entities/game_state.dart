import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final int userScore;
  final int ballsPlayed;
  final int userChoice;
  final int botChoice;
  final bool isUserOut;
  final bool isGameOver;
  final List<int> runsHistory;

  const GameState({
    this.userScore = 0,
    this.ballsPlayed = 0,
    this.userChoice = 0,
    this.botChoice = 0,
    this.isUserOut = false,
    this.isGameOver = false,
    this.runsHistory = const [],
  });

  GameState copyWith({
    int? userScore,
    int? ballsPlayed,
    int? userChoice,
    int? botChoice,
    bool? isUserOut,
    bool? isGameOver,
    List<int>? runsHistory,
  }) {
    return GameState(
      userScore: userScore ?? this.userScore,
      ballsPlayed: ballsPlayed ?? this.ballsPlayed,
      userChoice: userChoice ?? this.userChoice,
      botChoice: botChoice ?? this.botChoice,
      isUserOut: isUserOut ?? this.isUserOut,
      isGameOver: isGameOver ?? this.isGameOver,
      runsHistory: runsHistory ?? this.runsHistory,
    );
  }

  @override
  List<Object?> get props => [
        userScore,
        ballsPlayed,
        userChoice,
        botChoice,
        isUserOut,
        isGameOver,
        runsHistory,
      ];
}
