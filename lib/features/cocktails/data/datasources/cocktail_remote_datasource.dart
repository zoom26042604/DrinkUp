import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cocktail_model.dart';

abstract interface class CocktailRemoteDatasource {
  Future<List<CocktailModel>> searchByName(String name);
  Future<List<CocktailModel>> searchByFirstLetter(String letter);
  Future<CocktailModel> getById(String id);
  Future<CocktailModel> getRandom();
  Future<List<CocktailModel>> filterByCategory(String category);
  Future<List<CocktailModel>> filterByIngredient(String ingredient);
  Future<List<CocktailModel>> filterByAlcoholic(bool alcoholic);
  Future<List<CocktailModel>> filterByGlass(String glass);
  Future<List<String>> getCategories();
  Future<List<String>> getGlasses();
  Future<List<String>> getIngredientNames();
}

class CocktailRemoteDatasourceImpl implements CocktailRemoteDatasource {
  final Dio _dio;
  const CocktailRemoteDatasourceImpl(this._dio);

  @override
  Future<List<CocktailModel>> searchByName(String name) async {
    final response = await _dio.get(
      ApiConstants.searchEndpoint,
      queryParameters: {'s': name},
    );
    return _parseDrinkList(response.data);
  }

  @override
  Future<List<CocktailModel>> searchByFirstLetter(String letter) async {
    final response = await _dio.get(
      ApiConstants.searchEndpoint,
      queryParameters: {'f': letter},
    );
    return _parseDrinkList(response.data);
  }

  @override
  Future<CocktailModel> getById(String id) async {
    final response = await _dio.get(
      ApiConstants.lookupEndpoint,
      queryParameters: {'i': id},
    );
    final drinks = response.data['drinks'] as List?;
    if (drinks == null || drinks.isEmpty) throw const NotFoundException();
    return CocktailModel.fromJson(drinks.first as Map<String, dynamic>);
  }

  @override
  Future<CocktailModel> getRandom() async {
    final response = await _dio.get(ApiConstants.randomEndpoint);
    final drinks = response.data['drinks'] as List?;
    if (drinks == null || drinks.isEmpty) throw const NotFoundException();
    return CocktailModel.fromJson(drinks.first as Map<String, dynamic>);
  }

  @override
  Future<List<CocktailModel>> filterByCategory(String category) async {
    final response = await _dio.get(
      ApiConstants.filterEndpoint,
      queryParameters: {'c': category},
    );
    return _parseFilterList(response.data);
  }

  @override
  Future<List<CocktailModel>> filterByIngredient(String ingredient) async {
    final response = await _dio.get(
      ApiConstants.filterEndpoint,
      queryParameters: {'i': ingredient},
    );
    return _parseFilterList(response.data);
  }

  @override
  Future<List<CocktailModel>> filterByAlcoholic(bool alcoholic) async {
    final response = await _dio.get(
      ApiConstants.filterEndpoint,
      queryParameters: {'a': alcoholic ? 'Alcoholic' : 'Non_Alcoholic'},
    );
    return _parseFilterList(response.data);
  }

  @override
  Future<List<CocktailModel>> filterByGlass(String glass) async {
    final response = await _dio.get(
      ApiConstants.filterEndpoint,
      queryParameters: {'g': glass},
    );
    return _parseFilterList(response.data);
  }

  @override
  Future<List<String>> getCategories() => _getList('c');

  @override
  Future<List<String>> getGlasses() => _getList('g');

  @override
  Future<List<String>> getIngredientNames() => _getList('i');

  Future<List<String>> _getList(String param) async {
    final response = await _dio.get(
      ApiConstants.listEndpoint,
      queryParameters: {param: 'list'},
    );
    final drinks = response.data['drinks'] as List?;
    if (drinks == null) return [];
    final key = switch (param) {
      'c' => 'strCategory',
      'g' => 'strGlass',
      'i' => 'strIngredient1',
      _ => throw ServerException('Unknown list parameter: $param'),
    };
    return drinks
        .map((e) => (e as Map<String, dynamic>)[key] as String)
        .toList();
  }

  List<CocktailModel> _parseDrinkList(dynamic data) {
    final drinks = data['drinks'] as List?;
    if (drinks == null) throw const NotFoundException();
    return drinks
        .map((e) => CocktailModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<CocktailModel> _parseFilterList(dynamic data) {
    final drinks = data['drinks'] as List?;
    if (drinks == null) throw const NotFoundException();
    return drinks
        .map((e) => CocktailModel.fromFilterJson(e as Map<String, dynamic>))
        .toList();
  }
}
