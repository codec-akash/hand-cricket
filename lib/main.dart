import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/data/repositories/game_repository_impl.dart';
import 'package:hand_cricke/domain/repositories/game_repository.dart';
import 'package:hand_cricke/screens/game_main.dart';
import 'package:hand_cricke/utils/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GameRepository>(
          create: (context) => GameRepositoryImpl(),
        ),
      ],
      child: AppProviders(
        child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            title: 'Hand Cricket',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const GameMain(),
          ),
        ),
      ),
    );
  }
}
