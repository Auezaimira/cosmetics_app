class Recommendations {
  final String id;
  final String categoryId;
  final String productName;
  final String description;
  final String imageURL;
  final String? skinType;
  final String? hairType;
  final String specialConditions;
  final List<String> ethicalPreferences;
  final List<String> skinConcern;
  final List<String> ingredients;
  final List<String> purpose;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String brand;

  Recommendations(
      {required this.id,
      required this.categoryId,
      required this.productName,
      required this.description,
      required this.ingredients,
      required this.imageURL,
      required this.skinType,
      required this.ethicalPreferences,
      required this.skinConcern,
      required this.hairType,
      required this.specialConditions,
      required this.purpose,
      required this.createdAt,
      required this.updatedAt,
      required this.brand});

  factory Recommendations.fromJson(Map<String, dynamic> json) {
    return Recommendations(
      id: json['id'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      description: json['description'],
      imageURL: json['imageURL'],
      skinType: json['skinType'],
      ethicalPreferences: List<String>.from(json['ethicalPreferences'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      skinConcern: List<String>.from(json['skinConcern'] ?? []),
      purpose: List<String>.from(json['purpose'] ?? []),
      hairType: json['hairType'],
      specialConditions: json['specialConditions'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      brand: json['brand'] ?? '',
    );
  }
}
