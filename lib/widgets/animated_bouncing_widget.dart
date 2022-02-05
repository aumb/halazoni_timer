import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedBouncingWidget extends StatelessWidget {
  const AnimatedBouncingWidget({
    Key? key,
    required this.imagePath,
    this.xAxisStart = .0,
    this.yAxisStart = .0,
  }) : super(key: key);

  final String imagePath;
  final double xAxisStart;
  final double yAxisStart;

  @override
  Widget build(BuildContext context) {
    return _AnimatedBouncingWidget(
      imagePath: imagePath,
      xAxisStart: xAxisStart,
      yAxisStart: yAxisStart,
    );
  }
}

class _AnimatedBouncingWidget extends StatefulWidget {
  const _AnimatedBouncingWidget({
    Key? key,
    required this.imagePath,
    this.xAxisStart = .0,
    this.yAxisStart = .0,
  }) : super(key: key);

  final String imagePath;
  final double xAxisStart;
  final double yAxisStart;

  @override
  _AnimatedBouncingWidgetState createState() => _AnimatedBouncingWidgetState();
}

class _AnimatedBouncingWidgetState extends State<_AnimatedBouncingWidget> {
  final _logoKey = GlobalKey();
  late Timer _updateTimer;
  var _x = .0, _y = .0, _dx = 1, _dy = 1;

  @override
  void initState() {
    super.initState();
    _x = widget.xAxisStart;
    _y = widget.yAxisStart;
    _scheduleUpdate();
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  void _update() {
    final availableSize =
            (context.findRenderObject()! as RenderBox).constraints,
        logoSize =
            (_logoKey.currentContext!.findRenderObject()! as RenderBox).size;

    if (availableSize.maxWidth < _x + logoSize.width) {
      _dx = -1;
    } else if (_x < 0) {
      _dx = 1;
    }
    if (availableSize.maxHeight < _y + logoSize.height) {
      _dy = -1;
    } else if (_y < 0) {
      _dy = 1;
    }

    setState(() {
      _x += _dx * 15;
      _y += _dy * 15;
    });
  }

  void _scheduleUpdate() {
    _updateTimer = Timer.periodic(
      const Duration(milliseconds: 74),
      (timer) => _update(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          AnimatedPositioned(
            top: _y,
            left: _x,
            duration: const Duration(milliseconds: 74),
            child: Image.asset(
              widget.imagePath,
              key: _logoKey,
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
