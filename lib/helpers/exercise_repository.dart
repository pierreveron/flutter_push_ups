import 'dart:convert';
import 'dart:io';
import 'package:flutter_push_ups/models/exercise.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class ExerciseRepository {
  const ExerciseRepository();

  void saveExerciseData(ExerciseData exerciseData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/exercise-data.json');
    final jsonString = jsonEncode(exerciseData);
    print(jsonString);
    file.writeAsString(jsonString);
  }

  Future<ExerciseData> _loadExerciseData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/exercises-data.json');
      final jsonString = await file.readAsString();
      final dataJson = jsonDecode(jsonString);
      final exerciseData = ExerciseData.fromJson(dataJson);
      return exerciseData;
    } catch (e) {
      return null;
    }
  }

  Future<Exercise> loadExercise() async {
    final exerciseData = await _loadExerciseData();
    final jsonString = await rootBundle.loadString('assets/training-plan.json');
    final exerciseJson = jsonDecode(jsonString);
    final exercise =
        Exercise.fromJson(exerciseJson, exerciseData ?? ExerciseData());
    return exercise;
  }
}
