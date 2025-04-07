abstract class GameRepository {
  int generateBotChoice();
  bool checkIsUserOut(int userChoice, int botChoice);
  bool checkIsGameOver(int ballsPlayed, bool isUserOut);
}
