import 'ingredient.dart';

class Cocktail {
  final String id;
  final String name;
  final String? category;
  final bool isAlcoholic;
  final String? glassType;
  final String? instructions;
  final String thumbnailUrl;
  final List<Ingredient> ingredients;

  const Cocktail({
    required this.id,
    required this.name,
    this.category,
    required this.isAlcoholic,
    this.glassType,
    this.instructions,
    required this.thumbnailUrl,
    required this.ingredients,
  });
}
