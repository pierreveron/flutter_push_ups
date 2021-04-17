class Exercise {
  final int id;
  final String name;
  final List<ExerciseLevel> levels;
  final ExerciseData data;

  Exercise(this.id, this.name, this.levels, this.data);

  int get currentLevelIndex => data.currentLevelIndex;

  int get currentDayIndex => data.currentDayIndex;

  int get currentRecord => data.currentRecord;

  int get currentTrainingHour => data.currentTrainingHour;

  Exercise copyWith(
      {int levelIndex, int dayIndex, int record, int trainingHour}) {
    return Exercise(
      this.id,
      this.name,
      this.levels,
      ExerciseData(
        levelIndex ?? currentLevelIndex,
        dayIndex ?? currentDayIndex,
        record ?? currentRecord,
        trainingHour ?? currentTrainingHour,
      ),
    );
  }

  Exercise.fromJson(Map<String, dynamic> json, this.data)
      : id = json['id'],
        name = json['name'],
        levels = List<ExerciseLevel>.from((json['levels'] as List)
            .map((model) => ExerciseLevel.fromJson(model)));
}

class ExerciseLevel {
  final int id;
  final int pauseDuration;
  final List<dynamic> days;

  ExerciseLevel(this.id, this.pauseDuration, this.days);

  ExerciseLevel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pauseDuration = json['pauseDuration'],
        days = json['days'];
}

class ExerciseData {
  final int currentLevelIndex;
  final int currentDayIndex;
  final int currentRecord;
  final int currentTrainingHour;

  ExerciseData(
      [this.currentLevelIndex = 0,
      this.currentDayIndex = 0,
      this.currentRecord = 0,
      this.currentTrainingHour = 8]);

  ExerciseData.fromJson(Map<String, dynamic> json)
      : currentLevelIndex = json['currentLevelIndex'],
        currentDayIndex = json['currentDayIndex'],
        currentRecord = json['currentRecord'],
        currentTrainingHour = json['currentTrainingHour'];

  Map<String, dynamic> toJson() => {
        'currentLevelIndex': currentLevelIndex,
        'currentDayIndex': currentDayIndex,
        'currentRecord': currentRecord,
        'currentTrainingHour': currentTrainingHour,
      };
}
