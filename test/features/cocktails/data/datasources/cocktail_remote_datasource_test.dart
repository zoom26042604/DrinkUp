import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:drinkup/core/errors/exceptions.dart';
import 'package:drinkup/features/cocktails/data/datasources/cocktail_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CocktailRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = CocktailRemoteDatasourceImpl(mockDio);
  });

  String fixture(String name) =>
      File('test/fixtures/$name').readAsStringSync();

  group('searchByName', () {
    test('returns list of CocktailModel on 200', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: jsonDecode(fixture('cocktail_fixture.json')),
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await datasource.searchByName('margarita');

      expect(result, isNotEmpty);
      expect(result.first.name, 'Margarita');
      expect(result.first.ingredients.length, 4);
    });

    test('throws NotFoundException when drinks is null', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: jsonDecode(fixture('cocktail_not_found_fixture.json')),
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      expect(
        () => datasource.searchByName('xyzunknown'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('throws ServerException on DioException', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.searchByName('margarita'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getRandom', () {
    test('returns a CocktailModel', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: jsonDecode(fixture('cocktail_fixture.json')),
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await datasource.getRandom();
      expect(result.id, '11007');
    });
  });

  group('filterByCategory', () {
    test('returns partial CocktailModel list from filter endpoint', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: jsonDecode(fixture('cocktail_filter_fixture.json')),
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await datasource.filterByCategory('Cocktail');
      expect(result.length, 2);
      expect(result.first.ingredients, isEmpty);
    });
  });
}
