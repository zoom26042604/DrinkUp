// Model de données pour un cocktail (couche data)
// - Corresponds exactement à la structure JSON de TheCocktailDB
// - Champs : idDrink, strDrink, strCategory, strAlcoholic, strGlass,
//            strInstructions, strDrinkThumb, strIngredient1..15, strMeasure1..15
// - Annoté avec @JsonSerializable() pour la génération automatique
// - Méthodes : fromJson(), toJson()
// - Méthode toEntity() pour convertir en Cocktail (domain entity)
