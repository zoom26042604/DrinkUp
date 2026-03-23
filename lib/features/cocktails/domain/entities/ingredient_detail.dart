class IngredientDetail {
  final String id;
  final String name;
  final String? description;
  final String? type;
  final bool isAlcoholic;
  final String? abv;
  final String imageSmallUrl;
  final String imageMediumUrl;
  final String imageLargeUrl;

  const IngredientDetail({
    required this.id,
    required this.name,
    this.description,
    this.type,
    required this.isAlcoholic,
    this.abv,
    required this.imageSmallUrl,
    required this.imageMediumUrl,
    required this.imageLargeUrl,
  });
}
