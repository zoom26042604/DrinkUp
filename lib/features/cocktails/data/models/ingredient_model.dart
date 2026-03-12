// Model de données pour un ingrédient (couche data)
// - Champs : idIngredient, strIngredient, strDescription, strType, strAlcohol, strABV
// - Annoté avec @JsonSerializable()
// - Méthodes : fromJson(), toJson()
// - Méthode toEntity() pour convertir en Ingredient (domain entity)
// - URL de l'image d'un ingrédient construite depuis le nom :
//   https://www.thecocktaildb.com/images/ingredients/{name}-Small.png
