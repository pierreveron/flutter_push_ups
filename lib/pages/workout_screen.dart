import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push_ups/blocs/workout/workout.dart';
import 'package:flutter_push_ups/palette.dart';

class WorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutBloc = BlocProvider.of<WorkoutBloc>(context);
    return BlocBuilder<WorkoutBloc, WorkoutState>(builder: (context, state) {
      switch (state.runtimeType) {
        case WorkoutInProgress:
        case WorkoutPauseInProgress:
          return GestureDetector(
            onTap: BlocProvider.of<WorkoutBloc>(context).onPressed,
            child: Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    if (workoutBloc.mode == WorkoutMode.training) CircleRow(),
                    Center(
                      child:
                          state is WorkoutPauseInProgress ? Timer() : Counter(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: null,
                            onLongPress: () =>
                                BlocProvider.of<WorkoutBloc>(context)
                                    .add(WorkoutStopped()),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Palette.orange),
                            ),
                            child: Text(
                              "Hold on to stop",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          break;
        case WorkoutSuccess:
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${workoutBloc.total}",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.6,
                            color: Palette.orange,
                          ),
                        ),
                        Text(
                          "${workoutBloc.name} done in total".toUpperCase(),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Previous record',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Palette.whiteTransparent,
                                      ),
                                    ),
                                    Text(
                                      '${workoutBloc.exercise.currentRecord}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Palette.whiteTransparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Max repetitions',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Palette.whiteTransparent,
                                      ),
                                    ),
                                    Text(
                                      '${workoutBloc.maxReps}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Palette.whiteTransparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.green),
                        ),
                        child: Text(
                          "Finish",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
        case WorkoutFailure:
          return Scaffold(
            backgroundColor: Colors.red,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${BlocProvider.of<WorkoutBloc>(context).total}",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.6,
                            color: Palette.orange,
                          ),
                        ),
                        Text(
                          "${BlocProvider.of<WorkoutBloc>(context).name} done in total"
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            color: Palette.orange,
                          ),
                        ),
                        Text(
                          'Try harder the next time!'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: Palette.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.green),
                        ),
                        child: Text(
                          "Finish",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        default:
          throw UnsupportedError('State not supported');
          break;
      }
    });
  }
}

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double circleWidth = mediaWidth * .6;
    WorkoutBloc workoutBloc = BlocProvider.of<WorkoutBloc>(context);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: circleWidth,
          height: circleWidth,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1),
            duration: Duration(seconds: workoutBloc.pauseDuration),
            builder: (context, value, _) => CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.green),
              backgroundColor: Palette.green.withOpacity(.4),
              value: value,
              strokeWidth: 12,
            ),
          ),
        ),
        StreamBuilder<int>(
          stream: workoutBloc.timer.stream,
          initialData: workoutBloc.pauseDuration,
          builder: (context, snapshot) {
            return Text(
              "${snapshot.data}",
              style: TextStyle(
                fontSize: circleWidth * .6,
              ),
            );
          },
        ),
      ],
    );
  }
}

class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WorkoutBloc workoutBloc = BlocProvider.of<WorkoutBloc>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<int>(
          stream: workoutBloc.counter.stream,
          initialData: workoutBloc.counter.state,
          builder: (context, snapshot) => Text(
            "${snapshot.data}",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.6,
              color: Palette.orange,
            ),
          ),
        ),
        Text(
          workoutBloc.mode == WorkoutMode.training
              ? "${workoutBloc.name} to go".toUpperCase()
              : "${workoutBloc.name} done".toUpperCase(),
          style: TextStyle(
            fontSize: 22,
            color: Palette.orange,
          ),
        ),
      ],
    );
  }
}

class CircleRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WorkoutBloc workoutBloc = BlocProvider.of<WorkoutBloc>(context);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Palette.green,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              workoutBloc.repsList.length,
              (index) => buildCircle(index, workoutBloc.repsCurrentIndex,
                  workoutBloc.repsList[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCircle(int index, int repsCurrentIndex, reps) {
    // return Container(
    //   padding: EdgeInsets.all(12),
    //   decoration: BoxDecoration(
    //     color: index < repsCurrentIndex ? Palette.green : Colors.white,
    //     shape: BoxShape.circle,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.1),
    //         spreadRadius: 1,
    //         blurRadius: 1,
    //       ),
    //     ],
    //   ),
    //   child: Text(
    //     '$reps',
    //     style: TextStyle(
    //       color: index < repsCurrentIndex ? Palette.white : Palette.green,
    //       fontSize: 24,
    //     ),
    //   ),
    // );

    return SizedBox(
      height: 42,
      width: 42,
      child: Container(
        decoration: BoxDecoration(
          color: index < repsCurrentIndex ? Palette.green : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$reps',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: index < repsCurrentIndex ? Palette.white : Palette.green,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
