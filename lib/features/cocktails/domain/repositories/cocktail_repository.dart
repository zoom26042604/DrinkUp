// Interface abstraite du repository cocktail (contrat du domain)
// - Définit les méthodes sans implémentation
// - Retourne toujours ApiResult<T> (jamais de throw ici)
// - Méthodes :
//   - searchByName(String name) → ApiResult<List<Cocktail>>
//   - getById(String id)        → ApiResult<Cocktail>
//   - getRandom()               → ApiResult<Cocktail>
//   - filterByCategory(String)  → ApiResult<List<Cocktail>>
//   - filterByIngredient(String)→ ApiResult<List<Cocktail>>
//   - getCategories()           → ApiResult<List<String>>
//   - getFavorites()            → ApiResult<List<Cocktail>>
//   - toggleFavorite(Cocktail)  → ApiResult<bool>
