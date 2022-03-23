part of 'timer_cubit.dart';

class TimerState extends Equatable {
  const TimerState({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory TimerState.initial() {
    return const TimerState(
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0,
    );
  }

  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  static DateTime get _arrivalDate => DateTime(2022, DateTime.april, 18, 7, 45);
  static DateTime get _currentDate => DateTime.now();
  Duration get differenceDuration {
    if (_arrivalDate.isAfter(_currentDate)) {
      return _arrivalDate.difference(_currentDate);
    } else {
      return _currentDate.difference(_currentDate);
    }
  }

  TimerState copyWith({
    int? days,
    int? hours,
    int? minutes,
    int? seconds,
  }) {
    return TimerState(
      days: days ?? this.days,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }

  @override
  List<Object?> get props => [
        days,
        hours,
        minutes,
        seconds,
      ];
}
