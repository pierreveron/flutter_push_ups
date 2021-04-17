import 'package:bloc/bloc.dart';
import 'dart:async';

class TimerCubit extends Cubit<int> {
  TimerCubit() : super(0);
  Timer _timer;

  void start(int duration) {
    emit(duration);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      emit(state - 1);
    });
  }

  void stop() => _timer?.cancel();
}
