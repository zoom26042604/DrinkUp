import '../../domain/entities/cocktail.dart';
import '../../domain/entities/ingredient.dart';
import '../../../../core/constants/api_constants.dart';

class CocktailModel extends Cocktail {
  const CocktailModel({
    required super.id,
    required super.name,
    super.category,
    required super.isAlcoholic,
    super.glassType,
    super.instructions,
    required super.thumbnailUrl,
    required super.ingredients,
  });

  factory CocktailModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (var i = 1; i <= 15; i++) {
      final name = json['strIngredient$i'] as String?;
      if (name == null || name.trim().isEmpty) break;
      final rawMeasure = json['strMeasure$i'] as String?;
      final measure =
          (rawMeasure?.trim().isEmpty ?? true) ? null : rawMeasure?.trim();
      ingredients.add(Ingredient(
        name: name.trim(),
        measure: measure,
        imageSmallUrl:
            '${ApiConstants.ingredientImageBaseUrl}/${Uri.encodeComponent(name.trim())}-small.png',
      ));
    }
    return CocktailModel(
      id: json['idDrink'] as String,
      name: json['strDrink'] as String,
      category: json['strCategory'] as String?,
      isAlcoholic: json['strAlcoholic'] == 'Alcoholic',
      glassType: json['strGlass'] as String?,
      instructions: json['strInstructions'] as String?,
      thumbnailUrl: json['strDrinkThumb'] as String? ?? '',
      ingredients: ingredients,
    );
  }

  factory CocktailModel.fromFilterJson(Map<String, dynamic> json) {
    return CocktailModel(
      id: json['idDrink'] as String,
      name: json['strDrink'] as String,
      thumbnailUrl: json['strDrinkThumb'] as String? ?? '',
      isAlcoholic: false,
      ingredients: const [],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'idDrink': id,
      'strDrink': name,
      'strCategory': category,
      'strAlcoholic': isAlcoholic ? 'Alcoholic' : 'Non alcoholic',
      'strGlass': glassType,
      'strInstructions': instructions,
      'strDrinkThumb': thumbnailUrl,
    };
    for (var i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i].name;
      json['strMeasure${i + 1}'] = ingredients[i].measure;
    }
    return json;
  }
}
