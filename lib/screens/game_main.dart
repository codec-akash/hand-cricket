import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:hand_cricke/presentation/bloc/game_bloc/game_event.dart';
import 'package:hand_cricke/presentation/bloc/game_bloc/game_state.dart';
import 'package:hand_cricke/utils/image_path.dart';
import 'package:hand_cricke/utils/image_provider.dart';
import 'package:hand_cricke/widgets/run_buttons.dart';
import 'package:rive/rive.dart';
import 'package:hand_cricke/widgets/game_timer.dart';

class GameMain extends StatefulWidget {
  const GameMain({super.key});

  @override
  State<GameMain> createState() => _GameMainState();
}

class _GameMainState extends State<GameMain> {
  List<String> runList = [
    ImagePath.one,
    ImagePath.two,
    ImagePath.three,
    ImagePath.four,
    ImagePath.five,
    ImagePath.six,
  ];

  late final GameBloc _gameBloc;
  StateMachineController? _controllerLeft;
  StateMachineController? _controllerRight;
  SMINumber? numberInputLeft;
  SMINumber? numberInputRight;
  bool _isLeftInitialized = false;
  bool _isRightInitialized = false;

  @override
  void initState() {
    super.initState();
    _gameBloc = context.read<GameBloc>();
    _gameBloc.add(const GameStarted());
  }

  void _onRiveInitLeft(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);

      try {
        final input =
            controller.inputs.firstWhere((input) => input.name == 'Input');
        numberInputLeft = input as SMINumber;
      } catch (e) {
        debugPrint('Error getting left input: $e');
      }

      numberInputLeft?.value = 0.0;
      _controllerLeft = controller;
      setState(() {
        _isLeftInitialized = true;
      });
    }
  }

  void _onRiveInitRight(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      try {
        final input =
            controller.inputs.firstWhere((input) => input.name == 'Input');
        numberInputRight = input as SMINumber;
      } catch (e) {
        debugPrint('Error getting right input: $e');
      }

      numberInputRight?.value = 0.0;
      _controllerRight = controller;
      setState(() {
        _isRightInitialized = true;
      });
    }
  }

  void _onRunButtonTapped(int index) {
    if (!_isLeftInitialized || !_isRightInitialized) {
      return;
    }

    // Add 1 to index to get the actual run value (1-6)
    int runValue = index + 1;

    // Update the game state via BLoC
    _gameBloc.add(UserChoiceMade(runValue));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameBlocState>(
      listener: (context, state) {
        if (state is GameOutcome) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.outcomeMessage)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child:
                  ImageWidget.getImage(ImagePath.background, fit: BoxFit.cover),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<GameBloc, GameBlocState>(
                  builder: (context, state) {
                    if (state is GameInProgress || state is GameOutcome) {
                      final gameState = state is GameInProgress
                          ? state.gameState
                          : (state as GameOutcome).gameState;

                      // Update the Rive animations
                      if (_isLeftInitialized &&
                          _isRightInitialized &&
                          gameState.userChoice != 0) {
                        numberInputLeft?.value =
                            gameState.userChoice.toDouble();
                        numberInputRight?.value =
                            gameState.botChoice.toDouble();
                      }

                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: AssetImage(ImagePath.background),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 150.h,
                            width: 250.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'User: ${gameState.userScore}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..scale(-1.0, 1.0, 1.0),
                                          child: RiveAnimation.asset(
                                            RivePath.handCricket,
                                            onInit: _onRiveInitLeft,
                                            fit: BoxFit.contain,
                                            stateMachines: const [
                                              'State Machine 1'
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Bot',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: RiveAnimation.asset(
                                          RivePath.handCricket,
                                          onInit: _onRiveInitRight,
                                          fit: BoxFit.contain,
                                          stateMachines: const [
                                            'State Machine 1'
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Balls: ${gameState.ballsPlayed}/6',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage(ImagePath.background),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 150.h,
                        width: 250.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..scale(-1.0, 1.0, 1.0),
                                child: RiveAnimation.asset(
                                  RivePath.handCricket,
                                  onInit: _onRiveInitLeft,
                                  fit: BoxFit.contain,
                                  stateMachines: const ['State Machine 1'],
                                ),
                              ),
                            ),
                            Expanded(
                              child: RiveAnimation.asset(
                                RivePath.handCricket,
                                onInit: _onRiveInitRight,
                                fit: BoxFit.contain,
                                stateMachines: const ['State Machine 1'],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20.h),
                GameTimer(
                  durationInSeconds: 20,
                  onTimerComplete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Time's up!")),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                BlocBuilder<GameBloc, GameBlocState>(
                  builder: (context, state) {
                    final bool isGameOver = state is GameOutcome ||
                        (state is GameInProgress && state.gameState.isGameOver);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 30.w,
                              mainAxisSpacing: 30.h,
                            ),
                            itemBuilder: (context, index) => RunButtons(
                              run: runList[index],
                              onTap: isGameOver
                                  ? null
                                  : () => _onRunButtonTapped(index),
                            ),
                            itemCount: runList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                        if (isGameOver) ...[
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () => _gameBloc.add(const GameReset()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 15.h),
                            ),
                            child: const Text(
                              'Play Again',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerLeft?.dispose();
    _controllerRight?.dispose();
    super.dispose();
  }
}
