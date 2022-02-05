// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halazoni_timer/l10n/l10n.dart';
import 'package:halazoni_timer/resources/display.dart';
import 'package:halazoni_timer/resources/imgaes.dart';
import 'package:halazoni_timer/timer/timer.dart';
import 'package:halazoni_timer/widgets/animated_bouncing_widget.dart';
import 'package:halazoni_timer/widgets/animated_flip_widget.dart';

const _kGap = 16.0;
const _kMinXAxis = .0;
const _kMinYAxis = .0;
final _rng = Random();

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerCubit(),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  double get randomXAxisStart =>
      _kMinXAxis +
      _rng.nextInt(
        (MediaQuery.of(context).size.width).toInt() - _kMinXAxis.toInt(),
      );
  double get randomYAxisStart =>
      _kMinYAxis +
      _rng.nextInt(
        (MediaQuery.of(context).size.height).toInt() - _kMinYAxis.toInt(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.srcOver,
              ),
              child: Image.asset(
                AppImages.backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedBouncingWidget(
            imagePath: AppImages.bouncingImage,
            xAxisStart: randomXAxisStart,
            yAxisStart: randomYAxisStart,
          ),
          AnimatedBouncingWidget(
            imagePath: AppImages.bouncingImage,
            xAxisStart: randomXAxisStart,
            yAxisStart: randomYAxisStart,
          ),
          AnimatedBouncingWidget(
            imagePath: AppImages.bouncingImage,
            xAxisStart: randomXAxisStart,
            yAxisStart: randomYAxisStart,
          ),
          AnimatedBouncingWidget(
            imagePath: AppImages.bouncingImage,
            xAxisStart: randomXAxisStart,
            yAxisStart: randomYAxisStart,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<TimerCubit, TimerState>(
                      buildWhen: (previous, current) =>
                          previous.days != current.days,
                      builder: (context, state) {
                        return _CountDownSectionWidget(
                          label: l10n.days,
                          value: state.days,
                          buildWhen: (previous, current) =>
                              previous.days != current.days,
                        );
                      },
                    ),
                    const SizedBox(width: _kGap),
                    BlocBuilder<TimerCubit, TimerState>(
                      buildWhen: (previous, current) =>
                          previous.hours != current.hours,
                      builder: (context, state) {
                        return _CountDownSectionWidget(
                          label: l10n.hours,
                          value: state.hours,
                          buildWhen: (previous, current) =>
                              previous.hours != current.hours,
                        );
                      },
                    ),
                    const SizedBox(width: _kGap),
                    BlocBuilder<TimerCubit, TimerState>(
                      buildWhen: (previous, current) =>
                          previous.minutes != current.minutes,
                      builder: (context, state) {
                        return _CountDownSectionWidget(
                          label: l10n.minutes,
                          value: state.minutes,
                          buildWhen: (previous, current) =>
                              previous.minutes != current.minutes,
                        );
                      },
                    ),
                    const SizedBox(width: _kGap),
                    BlocBuilder<TimerCubit, TimerState>(
                      buildWhen: (previous, current) =>
                          previous.seconds != current.seconds,
                      builder: (context, state) {
                        return _CountDownSectionWidget(
                          label: l10n.seconds,
                          value: state.seconds,
                          buildWhen: (previous, current) =>
                              previous.seconds != current.seconds,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      context.read<TimerCubit>().updateTimer();
    });
  }
}

class _CountDownSectionWidget extends StatelessWidget {
  const _CountDownSectionWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.buildWhen,
  }) : super(key: key);

  final num value;
  final String label;
  final bool Function(TimerState, TimerState) buildWhen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedFlipWidget(
            value: value,
            textStyle: _buildTextStyleAccordingToSize(context),
          ),
        ],
      ),
    );
  }

  TextStyle _buildTextStyleAccordingToSize(BuildContext context) {
    final _display = MediaQuery.of(context).display.size;

    switch (_display) {
      case DisplaySize.xxsmall:
        return Theme.of(context).textTheme.headline3!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            );
      case DisplaySize.xsmall:
        return Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            );
      case DisplaySize.small:
      case DisplaySize.medium:
      case DisplaySize.large:
      case DisplaySize.xlarge:
        return Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            );
    }
  }
}
