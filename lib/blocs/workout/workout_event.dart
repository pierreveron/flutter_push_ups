abstract class WorkoutEvent {
  const WorkoutEvent();
}

class WorkoutSetDone extends WorkoutEvent {}

class WorkoutTimerDone extends WorkoutEvent {}

class WorkoutStopped extends WorkoutEvent {}
