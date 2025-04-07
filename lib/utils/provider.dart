import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_cricke/domain/repositories/game_repository.dart';
import 'package:hand_cricke/presentation/bloc/game_bloc/game_bloc.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameBloc>(
          create: (context) => GameBloc(
            RepositoryProvider.of<GameRepository>(context),
          ),
        ),
      ],
      child: child,
    );
  }
}
