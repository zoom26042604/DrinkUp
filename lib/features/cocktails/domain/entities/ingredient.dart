class Ingredient {
  final String name;
  final String? measure;
  final String imageSmallUrl;

  const Ingredient({
    required this.name,
    this.measure,
    required this.imageSmallUrl,
  });
}
