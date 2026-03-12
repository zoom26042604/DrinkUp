// UseCase : filtrage des cocktails (catégorie, ingrédient, alcool/sans alcool)
// - Paramètre : FilterCocktailsParams { FilterType type, String value }
// - FilterType enum : byCategory, byIngredient, byAlcoholic
// - Délègue au repository selon le type de filtre
// - Retourne ApiResult<List<Cocktail>>
