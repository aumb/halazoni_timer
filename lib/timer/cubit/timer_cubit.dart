// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState.initial());

  void updateTimer() {
    var microseconds = state.differenceDuration.inMicroseconds;

    final days = microseconds ~/ Duration.microsecondsPerDay;
    microseconds = microseconds.remainder(Duration.microsecondsPerDay);

    final hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    if (microseconds < 0) microseconds = -microseconds;

    final minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    // final minutesPadding = minutes < 10 ? '0' : '';

    final seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    emit(
      state.copyWith(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      ),
    );
  }
}
