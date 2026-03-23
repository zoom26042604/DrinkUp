import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/cocktail_model.dart';

abstract interface class CocktailLocalDatasource {
  Future<List<CocktailModel>> getFavorites();
  Future<void> saveFavorite(CocktailModel cocktail);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
}

class CocktailLocalDatasourceImpl implements CocktailLocalDatasource {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  const CocktailLocalDatasourceImpl(this._prefs);

  @override
  Future<List<CocktailModel>> getFavorites() async {
    try {
      final jsonList = _prefs.getStringList(_favoritesKey) ?? [];
      return jsonList
          .map((e) => CocktailModel.fromJson(
                jsonDecode(e) as Map<String, dynamic>,
              ))
          .toList();
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> saveFavorite(CocktailModel cocktail) async {
    try {
      final jsonList = _prefs.getStringList(_favoritesKey) ?? [];
      if (!jsonList.any((e) {
        final map = jsonDecode(e) as Map<String, dynamic>;
        return map['idDrink'] == cocktail.id;
      })) {
        jsonList.add(jsonEncode(cocktail.toJson()));
        await _prefs.setStringList(_favoritesKey, jsonList);
      }
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    try {
      final jsonList = _prefs.getStringList(_favoritesKey) ?? [];
      jsonList.removeWhere((e) {
        final map = jsonDecode(e) as Map<String, dynamic>;
        return map['idDrink'] == id;
      });
      await _prefs.setStringList(_favoritesKey, jsonList);
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<bool> isFavorite(String id) async {
    try {
      final jsonList = _prefs.getStringList(_favoritesKey) ?? [];
      return jsonList.any((e) {
        final map = jsonDecode(e) as Map<String, dynamic>;
        return map['idDrink'] == id;
      });
    } catch (_) {
      throw const CacheException();
    }
  }
}
