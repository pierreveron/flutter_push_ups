import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_push_ups/blocs/exercise/exercise.dart';
import 'package:flutter_push_ups/blocs/modal_cubit.dart';
import 'package:flutter_push_ups/blocs/workout/workout.dart';
import 'package:flutter_push_ups/models/exercise.dart';
import 'package:flutter_push_ups/palette.dart';

import 'modal_screen.dart';
import 'workout_screen.dart';

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case ExerciseLoadSuccess:
            double mediaWidth = MediaQuery.of(context).size.width;
            double buttonsWidth = mediaWidth * .8;
            double circleWidth = mediaWidth * .6;
            final exercise = (state as ExerciseLoadSuccess).exercise;
            return Scaffold(
              appBar: AppBar(
                title: Text(exercise.name.toUpperCase()),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.alarm),
                  iconSize: 30,
                  tooltip: 'open time picker',
                  onPressed: () => showMaterialNumberPicker(
                    context: context,
                    title: "Select your training hour",
                    maxNumber: 23,
                    minNumber: 0,
                    selectedNumber: exercise.currentTrainingHour,
                    onChanged: (newTrainingHour) =>
                        BlocProvider.of<ExerciseBloc>(context).add(
                            ExerciseUpdated(exercise.copyWith(
                                trainingHour: newTrainingHour))),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    iconSize: 30,
                    tooltip: 'open Modal',
                    onPressed: () => _showModal(context, exercise),
                  ),
                ],
              ),
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 26.0),
                        child: Text(
                          "Level ${exercise.currentLevelIndex + 1}",
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                            width: circleWidth,
                            height: circleWidth,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Palette.green),
                              backgroundColor: Palette.green.withOpacity(.4),
                              value: exercise.currentDayIndex /
                                  exercise.levels[exercise.currentLevelIndex]
                                      .days.length
                                      .toDouble(),
                              strokeWidth: 12,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${exercise.currentDayIndex + 1}",
                                  style: Theme.of(context).textTheme.headline4),
                              Container(
                                height: 2,
                                width: 30,
                                color: Palette.orange,
                              ),
                              Text(
                                  "${exercise.levels[exercise.currentLevelIndex].days.length}",
                                  style: Theme.of(context).textTheme.headline5),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 26.0),
                        child: Text(
                          'Current record: ${exercise.currentRecord}',
                        ),
                      ),
                      SizedBox(height: 40),
                      buildButtons(buttonsWidth, exercise, context),
                    ],
                  ),
                ),
              ),
            );

            break;
          case ExerciseLoadInProgress:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return Scaffold(
              body: Center(
                child: Text('Sorry there has been an error during loading'),
              ),
            );
        }
      },
    );
  }

  Future _showModal(BuildContext context, Exercise exercise) {
    return showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (context) {
        return BlocProvider<ModalCubit>(
          create: (_) => ModalCubit(exercise.currentLevelIndex),
          child: ModalScreen(),
        );
      },
    );
  }

  void _startWorkout(
      BuildContext context, Exercise exercise, WorkoutMode mode) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider<WorkoutBloc>(
          create: (context) => WorkoutBloc(
            BlocProvider.of<ExerciseBloc>(context),
            exercise,
            mode,
          ),
          child: WorkoutScreen(),
        ),
      ),
    );
  }

  Column buildButtons(
      double buttonsWidth, Exercise exercise, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: buttonsWidth,
          child: ElevatedButton(
            onPressed: () =>
                _startWorkout(context, exercise, WorkoutMode.training),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Palette.orange),
            ),
            child: Text(
              "Start training now",
            ),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: buttonsWidth,
          child: ElevatedButton(
            onPressed: () =>
                _startWorkout(context, exercise, WorkoutMode.session),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Palette.green),
            ),
            child: Text(
              "Just go for a record",
            ),
          ),
        ),
      ],
    );
  }
}
