class Project {
  final String info;
  final String size;
  final int budget;

  Project({
    required this.info,
    required this.size,
    required this.budget,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      info: json['info'],
      size: json['size'],
      budget: json['budget'],
    );
  }
}
