import 'package:equatable/equatable.dart';
import 'package:hand_cricke/domain/entities/game_state.dart' as entity;

abstract class GameBlocState extends Equatable {
  const GameBlocState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameBlocState {
  const GameInitial();
}

class GameInProgress extends GameBlocState {
  final entity.GameState gameState;

  const GameInProgress(this.gameState);

  @override
  List<Object?> get props => [gameState];
}

class GameOutcome extends GameBlocState {
  final entity.GameState gameState;
  final String outcomeMessage;

  const GameOutcome(this.gameState, this.outcomeMessage);

  @override
  List<Object?> get props => [gameState, outcomeMessage];
}
