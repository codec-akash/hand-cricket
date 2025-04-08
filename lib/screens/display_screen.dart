import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  final Widget bodyWidget;
  final Function? onCloseCallBack;
  const DisplayScreen({
    super.key,
    required this.bodyWidget,
    this.onCloseCallBack,
  });

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.onCloseCallBack == null) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      body: widget.bodyWidget,
    );
  }
}
