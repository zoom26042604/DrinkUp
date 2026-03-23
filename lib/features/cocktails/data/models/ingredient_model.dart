import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/ingredient_detail.dart';

class IngredientModel extends IngredientDetail {
  const IngredientModel({
    required super.id,
    required super.name,
    super.description,
    super.type,
    required super.isAlcoholic,
    super.abv,
    required super.imageSmallUrl,
    required super.imageMediumUrl,
    required super.imageLargeUrl,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    final name = json['strIngredient'] as String;
    final encodedName = Uri.encodeComponent(name);
    return IngredientModel(
      id: json['idIngredient'] as String,
      name: name,
      description: json['strDescription'] as String?,
      type: json['strType'] as String?,
      isAlcoholic: json['strAlcohol'] == 'Yes',
      abv: json['strABV'] as String?,
      imageSmallUrl:
          '${ApiConstants.ingredientImageBaseUrl}/$encodedName-small.png',
      imageMediumUrl:
          '${ApiConstants.ingredientImageBaseUrl}/$encodedName-medium.png',
      imageLargeUrl: '${ApiConstants.ingredientImageBaseUrl}/$encodedName.png',
    );
  }
}
