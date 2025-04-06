import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/utils/image_path.dart';
import 'package:hand_cricke/utils/image_provider.dart';
import 'package:hand_cricke/widgets/game_card.dart';
import 'package:hand_cricke/widgets/run_buttons.dart';
import 'package:rive/rive.dart';

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
  StateMachineController? _controllerLeft;
  StateMachineController? _controllerRight;
  SMINumber? numberInputLeft;
  SMINumber? numberInputRight;
  bool _isLeftInitialized = false;
  bool _isRightInitialized = false;

  void _onRiveInitLeft(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);

      // Try getting the input directly from inputs list
      try {
        final input =
            controller.inputs.firstWhere((input) => input.name == 'Input');
        numberInputLeft = input as SMINumber;
        debugPrint('Got numberInputLeft directly: ${numberInputLeft != null}');
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

      // Try getting the input directly from inputs list
      try {
        final input =
            controller.inputs.firstWhere((input) => input.name == 'Input');
        numberInputRight = input as SMINumber;
        debugPrint(
            'Got numberInputRight directly: ${numberInputRight != null}');
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

  void updateNumber(int index) {
    if (!_isLeftInitialized || !_isRightInitialized) {
      debugPrint('Controllers not fully initialized yet');
      debugPrint('Left initialized: $_isLeftInitialized');
      debugPrint('Right initialized: $_isRightInitialized');
      return;
    }

    int animationNumber = index + 1;
    debugPrint('Updating animation number to: $animationNumber');

    if (numberInputLeft == null || numberInputRight == null) {
      debugPrint('numberInputLeft: ${numberInputLeft != null}');
      debugPrint('numberInputRight: ${numberInputRight != null}');
      return;
    }

    numberInputLeft?.value = animationNumber.toDouble();
    numberInputRight?.value = animationNumber.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child:
                ImageWidget.getImage(ImagePath.background, fit: BoxFit.cover),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const GameCard(),
              SizedBox(
                height: 200.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 30.w,
                    mainAxisSpacing: 30.h,
                  ),
                  itemBuilder: (context, index) => RunButtons(
                    run: runList[index],
                    onTap: () => updateNumber(index),
                  ),
                  itemCount: runList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ],
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
