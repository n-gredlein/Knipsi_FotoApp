class Rating {
  final stars;
  final userId;

  Rating({required this.stars, required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'userId': userId,
    };
  }

  Rating.fromJson(Map<String, dynamic> ratingMap)
      : stars = ratingMap["stars"],
        userId = ratingMap["userId"];
}
