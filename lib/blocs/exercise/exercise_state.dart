import 'package:flutter_push_ups/models/exercise.dart';

abstract class ExerciseState {
  const ExerciseState();
}

class ExerciseLoadInProgress extends ExerciseState {}

class ExerciseLoadSuccess extends ExerciseState {
  final Exercise exercise;

  const ExerciseLoadSuccess([this.exercise]);
}

class ExerciseLoadFailure extends ExerciseState {}