import 'package:flutter_push_ups/models/exercise.dart';

abstract class ExerciseEvent {
  const ExerciseEvent();
}

class ExerciseLoaded extends ExerciseEvent {}

class ExerciseUpdated extends ExerciseEvent {
  final Exercise updatedExercise;

  const ExerciseUpdated(this.updatedExercise);
}
