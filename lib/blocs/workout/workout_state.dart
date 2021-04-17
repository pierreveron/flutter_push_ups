abstract class WorkoutState {
  const WorkoutState();
}

class WorkoutInProgress extends WorkoutState {}

class WorkoutPauseInProgress extends WorkoutState {}

class WorkoutSuccess extends WorkoutState {}

class WorkoutFailure extends WorkoutState {}