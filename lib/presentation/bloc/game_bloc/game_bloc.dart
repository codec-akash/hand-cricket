import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_cricke/domain/entities/game_state.dart';
import 'package:hand_cricke/domain/repositories/game_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameBlocState> {
  final GameRepository _gameRepository;

  GameBloc(this._gameRepository) : super(const GameInitial()) {
    on<GameStarted>(_onGameStarted);
    on<UserChoiceMade>(_onUserChoiceMade);
    on<GameReset>(_onGameReset);
  }

  void _onGameStarted(GameStarted event, Emitter<GameBlocState> emit) {
    emit(const GameInProgress(GameState()));
  }

  void _onUserChoiceMade(UserChoiceMade event, Emitter<GameBlocState> emit) {
    if (state is! GameInProgress) return;

    final currentState = (state as GameInProgress).gameState;
    if (currentState.isGameOver) return;

    final userChoice = event.userChoice;
    final botChoice = _gameRepository.generateBotChoice();

    final isUserOut = _gameRepository.checkIsUserOut(userChoice, botChoice);
    final newBallsPlayed = currentState.ballsPlayed + 1;
    final newUserScore = isUserOut
        ? currentState.userScore
        : currentState.userScore + userChoice;

    final updatedState = currentState.copyWith(
      userChoice: userChoice,
      botChoice: botChoice,
      userScore: newUserScore,
      ballsPlayed: newBallsPlayed,
      isUserOut: isUserOut,
      isGameOver: _gameRepository.checkIsGameOver(newBallsPlayed, isUserOut),
    );

    emit(GameInProgress(updatedState));

    if (updatedState.isGameOver) {
      String outcomeMessage;
      if (updatedState.isUserOut) {
        outcomeMessage = 'OUT! Final Score: ${updatedState.userScore}';
      } else {
        outcomeMessage =
            'Innings Complete! Final Score: ${updatedState.userScore}';
      }
      emit(GameOutcome(updatedState, outcomeMessage));
    }
  }

  void _onGameReset(GameReset event, Emitter<GameBlocState> emit) {
    emit(const GameInProgress(GameState()));
  }
}
