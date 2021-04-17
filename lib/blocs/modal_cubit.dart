import 'package:bloc/bloc.dart';

class ModalCubit extends Cubit<int> {
  ModalCubit(int initialLevelIndex) : super(initialLevelIndex);

  void update(int levelIndex) => emit(levelIndex);
}
