import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push_ups/blocs/exercise/exercise.dart';
import 'package:flutter_push_ups/palette.dart';

import 'blocs/simple_bloc_observer.dart';
import 'helpers/helpers.dart';
import 'pages/exercise_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = SimpleBlocObserver();

  runApp(
    BlocProvider(
      create: (_) {
        return ExerciseBloc(
          exerciseRepository: const ExerciseRepository(),
          notificationsHelper: NotificationsHelper(),
        )..add(ExerciseLoaded());
      },
      child: PushUpsApp(),
    ),
  );
}

class PushUpsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push-Ups',
      theme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      home: ExerciseScreen(),
    );
  }
}
