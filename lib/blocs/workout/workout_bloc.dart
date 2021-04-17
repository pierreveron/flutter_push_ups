import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push_ups/blocs/counter_cubit.dart';
import 'package:flutter_push_ups/blocs/exercise/exercise.dart';
import 'package:flutter_push_ups/blocs/timer_cubit.dart';
import 'package:flutter_push_ups/models/exercise.dart';

import 'workout_event.dart';
import 'workout_state.dart';

enum WorkoutMode { training, session }

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final ExerciseBloc exerciseBloc;
  final Exercise exercise;
  final WorkoutMode mode;
  String get name => exercise.name;
  int get pauseDuration =>
      exercise.levels[exercise.currentLevelIndex].pauseDuration;
  List<dynamic> get repsList => exercise
      .levels[exercise.currentLevelIndex].days[exercise.currentDayIndex];
  int _repsCurrentIndex = 0;
  int _total = 0;
  int _maxReps = 0;
  final TimerCubit _timerCubit = TimerCubit();
  final CounterCubit _counterCubit = CounterCubit();

  int get total => _total;
  int get maxReps => _maxReps;
  int get repsCurrentIndex => _repsCurrentIndex;
  TimerCubit get timer => _timerCubit;
  CounterCubit get counter => _counterCubit;

  WorkoutBloc(this.exerciseBloc, this.exercise, this.mode)
      : super(WorkoutInProgress()) {
    if (this.mode == WorkoutMode.training)
      resetCounter(repsList[_repsCurrentIndex]);
    _counterCubit.stream.listen((count) {
      if (count <= 0) add(WorkoutSetDone());
    });
    _timerCubit.stream.listen((time) {
      if (time <= 0) add(WorkoutTimerDone());
    });
  }

  void onPressed() {
    if (state is WorkoutInProgress) {
      if (this.mode == WorkoutMode.training)
        decrementCounter();
      else
        incrementCounter();
    } else if (state is WorkoutPauseInProgress) add(WorkoutTimerDone());
  }

  void decrementCounter() {
    _counterCubit.decrement();
    _total++;
    if (repsList[repsCurrentIndex] - _counterCubit.state > _maxReps) _maxReps++;
  }

  void incrementCounter() {
    _counterCubit.increment();
    _maxReps = ++_total;
  }

  void resetCounter(int initialCount) =>
      _counterCubit.reset(initialCount: initialCount);

  void startTimer(int duration) => _timerCubit.start(duration);
  void stopTimer() => _timerCubit.stop();

  @override
  Stream<WorkoutState> mapEventToState(WorkoutEvent event) async* {
    switch (event.runtimeType) {
      case WorkoutSetDone:
        if (_repsCurrentIndex < repsList.length - 1) {
          startTimer(pauseDuration);
          resetCounter(repsList[++_repsCurrentIndex]);
          yield WorkoutPauseInProgress();
        } else {
          Exercise updatedExercise = exercise;
          if (_maxReps > exercise.currentRecord)
            updatedExercise = updatedExercise.copyWith(record: _maxReps);
          if (mode == WorkoutMode.training) {
            if (exercise.currentLevelIndex < exercise.levels.length - 1) {
              if (exercise.currentDayIndex <
                  exercise.levels[exercise.currentLevelIndex].days.length - 1) {
                updatedExercise = updatedExercise.copyWith(
                    levelIndex: exercise.currentLevelIndex,
                    dayIndex: exercise.currentDayIndex + 1);
              } else {
                updatedExercise = updatedExercise.copyWith(
                    levelIndex: exercise.currentLevelIndex + 1, dayIndex: 0);
              }
            } else {
              if (exercise.currentDayIndex <
                  exercise.levels[exercise.currentLevelIndex].days.length - 1) {
                updatedExercise = updatedExercise.copyWith(
                    levelIndex: exercise.currentLevelIndex,
                    dayIndex: exercise.currentDayIndex + 1);
              }
            }
          }
          exerciseBloc.add(ExerciseUpdated(updatedExercise));
          yield WorkoutSuccess();
        }
        break;
      case WorkoutTimerDone:
        stopTimer();
        yield WorkoutInProgress();
        break;
      case WorkoutStopped:
        if (_maxReps > exercise.currentRecord)
          exerciseBloc
              .add(ExerciseUpdated(exercise.copyWith(record: _maxReps)));
        if (mode == WorkoutMode.training)
          yield WorkoutFailure();
        else
          yield WorkoutSuccess();
        break;
      default:
        throw UnsupportedError('Event not supported');
        break;
    }
  }

  @override
  Future<void> close() {
    _timerCubit.close();
    _counterCubit.close();
    return super.close();
  }  
}
