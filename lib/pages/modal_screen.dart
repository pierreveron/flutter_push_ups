import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push_ups/blocs/exercise/exercise.dart';
import 'package:flutter_push_ups/blocs/modal_cubit.dart';
import 'package:flutter_push_ups/models/exercise.dart';
import 'package:flutter_push_ups/palette.dart';

class ModalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .93,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            left: 31,
            top: 0,
            bottom: 0,
            child: _buildVerticalBar(),
          ),
          DaysList(),
          ModalTop(),
          Positioned(
            top: 8,
            child: _buildModalTopCursor(),
          ),
        ],
      ),
    );
  }
}

class DaysList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, levelIndex) {
        return BlocBuilder<ModalCubit, int>(
          builder: (context, levelIndex) {
            final ExerciseBloc exercisesBloc =
                BlocProvider.of<ExerciseBloc>(context);
            final Exercise exercise =
                (exercisesBloc.state as ExerciseLoadSuccess).exercise;
            final ExerciseLevel level = exercise.levels[levelIndex];
            return Container(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 100, bottom: 80),
                itemCount: level.days.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 42,
                          width: 42,
                          child: Container(
                            decoration: BoxDecoration(
                              color: index < exercise.currentDayIndex &&
                                      exercise.currentLevelIndex == levelIndex
                                  ? Palette.green
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                ),
                              ],
                              border: index == exercise.currentDayIndex &&
                                      exercise.currentLevelIndex == levelIndex
                                  ? Border.all(color: Palette.orange, width: 4)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: index < exercise.currentDayIndex &&
                                          exercise.currentLevelIndex ==
                                              levelIndex
                                      ? Palette.whiteTransparent
                                      : Palette.green,
                                  fontSize: 21,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showMyDialog(
                                context, exercise, levelIndex, index),
                            child: Container(
                              padding: index == exercise.currentDayIndex &&
                                      exercise.currentLevelIndex == levelIndex
                                  ? EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10)
                                  : EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(6),
                                border: index == exercise.currentDayIndex &&
                                        exercise.currentLevelIndex == levelIndex
                                    ? Border.all(
                                        color: Palette.orange, width: 2)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    level.days[index].join("-"),
                                    style: TextStyle(
                                        color: Palette.whiteTransparent,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    level.days[index]
                                        .reduce(
                                            (value, element) => value + element)
                                        .toString(),
                                    style: TextStyle(
                                        color: Palette.whiteTransparent,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 16,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> _showMyDialog(
    BuildContext context, Exercise exercise, int levelIndex, int index) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change exercise progression'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'You are going to change your progression to the day ${index + 1} of the level ${levelIndex + 1}'),
              Text('Are you sure to do it?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Change'),
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<ExerciseBloc>(context).add(ExerciseUpdated(
                  exercise.copyWith(levelIndex: levelIndex, dayIndex: index)));
            },
          ),
        ],
      );
    },
  );
}

class ModalTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModalCubit, int>(
      builder: (context, levelIndex) {
        final ExerciseBloc exercisesBloc =
            BlocProvider.of<ExerciseBloc>(context);
        final Exercise exercise =
            (exercisesBloc.state as ExerciseLoadSuccess).exercise;
        final ExerciseLevel level = exercise.levels[levelIndex];
        return Container(
          padding: EdgeInsets.only(top: 20, left: 64, right: 12, bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: [
                0.05,
                0.6,
                1.0,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: exercise.levels.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () =>
                          BlocProvider.of<ModalCubit>(context).update(index),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 18)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            level.id == index
                                ? Palette.green
                                : Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: levelIndex == index
                                  ? Palette.white
                                  : Theme.of(context).unselectedWidgetColor,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "Level ${index + 1}",
                        style: TextStyle(
                          fontSize: 18,
                          color: levelIndex == index
                              ? Palette.white
                              : Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Number of reps',
                      style: TextStyle(
                        color: Palette.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Total',
                      style: TextStyle(color: Palette.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildVerticalBar() {
  return Container(
    height: double.infinity,
    width: 4,
    color: Palette.green,
  );
}

Widget _buildModalTopCursor() {
  return Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: Palette.whiteTransparent,
    ),
  );
}
