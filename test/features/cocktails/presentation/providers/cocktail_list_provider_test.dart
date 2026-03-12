// Tests des providers Riverpod (CocktailListProvider)
// - Utilise ProviderContainer pour tester sans Flutter widget tree
// - Mock des UseCases injectés via override
// - Test état initial : isLoading = false, cocktails = []
// - Test searchByName : passe à isLoading=true puis met à jour cocktails
// - Test erreur : met à jour le champ error de l'état
// - Test debounce : vérifie que l'appel API n'est pas déclenché immédiatement
