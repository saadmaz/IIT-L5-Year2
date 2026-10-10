class TutorialModel {
  final String title;
  final String videoId;
  final String category;
  final String summary;
  final List<String> steps;

  // ✅ Optional display enhancements
  final String? muscle;
  final String? difficulty;

  TutorialModel({
    required this.title,
    required this.videoId,
    required this.category,
    required this.summary,
    required this.steps,
    this.muscle,
    this.difficulty,
  });
}
