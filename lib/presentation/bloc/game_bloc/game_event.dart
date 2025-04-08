import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  const GameStarted();
}

class UserChoiceMade extends GameEvent {
  final int userChoice;

  const UserChoiceMade(this.userChoice);

  @override
  List<Object?> get props => [userChoice];
}

class TimerExpired extends GameEvent {
  const TimerExpired();
}

class GameReset extends GameEvent {
  const GameReset();
}
