import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_push_ups/helpers/helpers.dart';
import 'package:flutter_push_ups/models/exercise.dart';

import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository exerciseRepository;
  final NotificationsHelper notificationsHelper;

  ExerciseBloc(
      {@required this.exerciseRepository, @required this.notificationsHelper})
      : super(ExerciseLoadInProgress());

  @override
  Stream<ExerciseState> mapEventToState(ExerciseEvent event) async* {
    switch (event.runtimeType) {
      case ExerciseLoaded:
        yield* _mapExerciceLoadedToState();
        break;
      case ExerciseUpdated:
        yield* _mapExerciseUpdatedToState(event);
        break;
      default:
        throw UnsupportedError('Event not supported');
        break;
    }
  }

  Stream<ExerciseState> _mapExerciceLoadedToState() async* {
    try {
      final exercises = await this.exerciseRepository.loadExercise();
      yield ExerciseLoadSuccess(exercises);
    } catch (_) {
      yield ExerciseLoadFailure();
    }
  }

  Stream<ExerciseState> _mapExerciseUpdatedToState(
      ExerciseUpdated event) async* {
    if (state is ExerciseLoadSuccess) {
      yield ExerciseLoadSuccess(event.updatedExercise);
      _saveExercise(event.updatedExercise);
      notificationsHelper.zonedScheduleNotification(
        event.updatedExercise.id,
        event.updatedExercise.name,
        event.updatedExercise.currentTrainingHour,
      );
    }
  }

  void _saveExercise(Exercise exercise) =>
      exerciseRepository.saveExerciseData(exercise.data);
}
