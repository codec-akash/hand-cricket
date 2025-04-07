import 'dart:math';
import 'package:hand_cricke/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final Random _random = Random();

  @override
  int generateBotChoice() {
    // Generate a random number between 1 and 6
    return _random.nextInt(6) + 1;
  }

  @override
  bool checkIsUserOut(int userChoice, int botChoice) {
    // User is out if both chose the same number
    return userChoice == botChoice && userChoice != 0;
  }

  @override
  bool checkIsGameOver(int ballsPlayed, bool isUserOut) {
    // Game is over if 6 balls have been played or user is out
    return ballsPlayed >= 6 || isUserOut;
  }
}
