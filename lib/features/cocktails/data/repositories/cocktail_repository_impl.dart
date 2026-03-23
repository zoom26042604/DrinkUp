import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/cocktail.dart';
import '../../domain/entities/ingredient_detail.dart';
import '../../domain/repositories/cocktail_repository.dart';
import '../datasources/cocktail_local_datasource.dart';
import '../datasources/cocktail_remote_datasource.dart';
import '../models/cocktail_model.dart';

class CocktailRepositoryImpl implements CocktailRepository {
  final CocktailRemoteDatasource _remote;
  final CocktailLocalDatasource _local;

  const CocktailRepositoryImpl(this._remote, this._local);

  @override
  Future<ApiResult<List<Cocktail>>> searchByName(String name) =>
      _remoteListCall(() => _remote.searchByName(name));

  @override
  Future<ApiResult<List<Cocktail>>> searchByFirstLetter(String letter) =>
      _remoteListCall(() => _remote.searchByFirstLetter(letter));

  @override
  Future<ApiResult<Cocktail>> getById(String id) =>
      _remoteSingleCall(() => _remote.getById(id));

  @override
  Future<ApiResult<Cocktail>> getRandom() =>
      _remoteSingleCall(() => _remote.getRandom());

  @override
  Future<ApiResult<List<Cocktail>>> filterByCategory(String category) =>
      _remoteListCall(() => _remote.filterByCategory(category));

  @override
  Future<ApiResult<List<Cocktail>>> filterByIngredient(String ingredient) =>
      _remoteListCall(() => _remote.filterByIngredient(ingredient));

  @override
  Future<ApiResult<List<Cocktail>>> filterByAlcoholic(bool alcoholic) =>
      _remoteListCall(() => _remote.filterByAlcoholic(alcoholic));

  @override
  Future<ApiResult<List<Cocktail>>> filterByGlass(String glass) =>
      _remoteListCall(() => _remote.filterByGlass(glass));

  @override
  Future<ApiResult<List<String>>> getCategories() =>
      _remoteStringListCall(() => _remote.getCategories());

  @override
  Future<ApiResult<List<String>>> getGlasses() =>
      _remoteStringListCall(() => _remote.getGlasses());

  @override
  Future<ApiResult<List<String>>> getIngredientNames() =>
      _remoteStringListCall(() => _remote.getIngredientNames());

  @override
  Future<ApiResult<List<IngredientDetail>>> searchIngredientByName(
    String name,
  ) async {
    try {
      return ApiSuccess(await _remote.searchIngredientByName(name));
    } on NotFoundException {
      return const ApiError(NotFoundFailure());
    } on DioException catch (e) {
      return ApiError(_dioFailure(e));
    } on ServerException catch (e) {
      return ApiError(ServerFailure(e.message));
    }
  }

  @override
  Future<ApiResult<IngredientDetail>> getIngredientById(String id) async {
    try {
      return ApiSuccess(await _remote.getIngredientById(id));
    } on NotFoundException {
      return const ApiError(NotFoundFailure());
    } on DioException catch (e) {
      return ApiError(_dioFailure(e));
    } on ServerException catch (e) {
      return ApiError(ServerFailure(e.message));
    }
  }

  @override
  Future<ApiResult<List<Cocktail>>> getFavorites() async {
    try {
      final models = await _local.getFavorites();
      return ApiSuccess(models);
    } on CacheException catch (e) {
      return ApiError(CacheFailure(e.message));
    }
  }

  @override
  Future<ApiResult<bool>> toggleFavorite(Cocktail cocktail) async {
    try {
      final alreadyFavorite = await _local.isFavorite(cocktail.id);
      if (alreadyFavorite) {
        await _local.removeFavorite(cocktail.id);
        return const ApiSuccess(false);
      } else {
        await _local.saveFavorite(cocktail as CocktailModel);
        return const ApiSuccess(true);
      }
    } on CacheException catch (e) {
      return ApiError(CacheFailure(e.message));
    }
  }

  Future<ApiResult<List<Cocktail>>> _remoteListCall(
    Future<List<CocktailModel>> Function() call,
  ) async {
    try {
      return ApiSuccess(await call());
    } on NotFoundException {
      return const ApiError(NotFoundFailure());
    } on DioException catch (e) {
      return ApiError(_dioFailure(e));
    } on ServerException catch (e) {
      return ApiError(ServerFailure(e.message));
    }
  }

  Future<ApiResult<Cocktail>> _remoteSingleCall(
    Future<CocktailModel> Function() call,
  ) async {
    try {
      return ApiSuccess(await call());
    } on NotFoundException {
      return const ApiError(NotFoundFailure());
    } on DioException catch (e) {
      return ApiError(_dioFailure(e));
    } on ServerException catch (e) {
      return ApiError(ServerFailure(e.message));
    }
  }

  Future<ApiResult<List<String>>> _remoteStringListCall(
    Future<List<String>> Function() call,
  ) async {
    try {
      return ApiSuccess(await call());
    } on NotFoundException {
      return const ApiError(NotFoundFailure());
    } on DioException catch (e) {
      return ApiError(_dioFailure(e));
    } on ServerException catch (e) {
      return ApiError(ServerFailure(e.message));
    }
  }

  Failure _dioFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return ServerFailure(e.message ?? 'Network error.');
  }
}
