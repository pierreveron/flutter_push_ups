import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_push_ups/helpers/exercise_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // Create a temporary directory.
    // final directory = await Directory.systemTemp.createTemp();

    // // Mock out the MethodChannel for the path_provider plugin.
    // const MethodChannel('plugins.flutter.io/path_provider')
    //     .setMockMethodCallHandler((MethodCall methodCall) async {
    //   // If you're getting the apps documents directory, return the path to the
    //   // temp directory on the test environment instead.
    //   if (methodCall.method == 'getApplicationDocumentsDirectory') {
    //     return directory.path;
    //   }
    //   return null;
    // });

    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return ".";
    });
  });

  /* Tests don't work with saved ExerciseData in the DocumentsDirectory because I don't manage to get it access with the setUpAll */
  test('Training plan deserialization works on push-ups', () async {
    var exercise = await ExerciseRepository().loadExercise();

    expect(exercise.name, equals('Push-ups'));
    expect(exercise.currentLevelIndex, equals(0));
    expect(exercise.currentDayIndex, equals(0));
  });

  test('Training plan deserialization works on levels of push-ups', () async {
    var pauseDuration = 30;
    var list = [
      [2, 3, 4, 3, 2],
      [3, 4, 4, 3, 2],
      [4, 4, 3, 5, 4],
      [5, 6, 6, 4, 4],
      [7, 6, 6, 5, 3],
      [8, 8, 6, 7, 6],
      [10, 6, 10, 8, 6],
      [12, 8, 8, 10, 8],
      [14, 10, 14, 8, 8],
      [20]
    ];
    var exercise = await ExerciseRepository().loadExercise();
    for (var j = 0; j < exercise.levels.length; j++) {
      expect(exercise.levels[j].id, equals(j));
      expect(exercise.levels[j].pauseDuration, equals(pauseDuration));
      expect(exercise.levels[j].days, equals(list));
    }
  });
}
