import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/providers/app_providers.dart';
import '../../domain/entities/cocktail.dart';

final ingredientNamesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(remoteDatasourceProvider).getIngredientNames();
});

final cocktailNamesByLetterProvider =
    FutureProvider.family<List<String>, String>((ref, letter) async {
  final results =
      await ref.read(remoteDatasourceProvider).searchByFirstLetter(letter);
  return results.map((c) => c.name).toList();
});

class Game1State {
  final Cocktail cocktail;
  final int revealedCount;
  final bool gameOver;
  final bool won;

  const Game1State({
    required this.cocktail,
    this.revealedCount = 1,
    this.gameOver = false,
    this.won = false,
  });

  int get score =>
      (cocktail.ingredients.length - revealedCount + 1)
          .clamp(0, cocktail.ingredients.length);

  Game1State copyWith({int? revealedCount, bool? gameOver, bool? won}) =>
      Game1State(
        cocktail: cocktail,
        revealedCount: revealedCount ?? this.revealedCount,
        gameOver: gameOver ?? this.gameOver,
        won: won ?? this.won,
      );
}

class Game1Notifier extends AutoDisposeAsyncNotifier<Game1State> {
  @override
  Future<Game1State> build() => _fetch();

  Future<Game1State> _fetch() async {
    final result = await ref.read(getRandomCocktailUsecaseProvider)();
    final cocktail = switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw failure,
    };
    if (cocktail.ingredients.isEmpty) return _fetch();
    debugPrint('[Game1] Answer (cocktail name): ${cocktail.name}');
    debugPrint('[Game1] Ingredients shown as hints: ${cocktail.ingredients.map((i) => i.name).join(', ')}');
    return Game1State(cocktail: cocktail);
  }

  void validate(String answer) {
    final s = state.valueOrNull;
    if (s == null || s.gameOver) return;
    final trimmed = answer.trim().toLowerCase();
    if (trimmed.isEmpty) return;
    final match = trimmed == s.cocktail.name.toLowerCase();
    if (match) {
      state = AsyncData(s.copyWith(won: true, gameOver: true));
    } else if (s.revealedCount < s.cocktail.ingredients.length) {
      state = AsyncData(s.copyWith(revealedCount: s.revealedCount + 1));
    } else {
      state = AsyncData(s.copyWith(gameOver: true));
    }
  }

  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final game1Provider =
    AsyncNotifierProvider.autoDispose<Game1Notifier, Game1State>(
  Game1Notifier.new,
);

class Game2State {
  final Cocktail cocktail;
  final bool gameOver;
  final bool won;

  const Game2State({
    required this.cocktail,
    this.gameOver = false,
    this.won = false,
  });

  Game2State copyWith({bool? gameOver, bool? won}) => Game2State(
        cocktail: cocktail,
        gameOver: gameOver ?? this.gameOver,
        won: won ?? this.won,
      );
}

class Game2Notifier extends AutoDisposeAsyncNotifier<Game2State> {
  @override
  Future<Game2State> build() => _fetch();

  Future<Game2State> _fetch() async {
    final result = await ref.read(getRandomCocktailUsecaseProvider)();
    final cocktail = switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw failure,
    };
    if (cocktail.ingredients.isEmpty || !cocktail.isAlcoholic) return _fetch();
    debugPrint('[Game2] Cocktail shown: ${cocktail.name}');
    debugPrint('[Game2] Accepted answers (any alcohol): ${cocktail.ingredients.map((i) => i.name).join(', ')}');
    return Game2State(cocktail: cocktail);
  }

  void validate(String answer) {
    final s = state.valueOrNull;
    if (s == null || s.gameOver) return;
    final trimmed = answer.trim().toLowerCase();
    if (trimmed.isEmpty) return;
    final match = s.cocktail.ingredients.any((i) {
      final name = i.name.toLowerCase();
      return name == trimmed || name.contains(trimmed) || trimmed.contains(name);
    });
    state = AsyncData(s.copyWith(gameOver: true, won: match));
  }

  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final game2Provider =
    AsyncNotifierProvider.autoDispose<Game2Notifier, Game2State>(
  Game2Notifier.new,
);

class Game3State {
  final Cocktail cocktail;
  final Set<String> realIngredients;
  final List<String> available;
  final List<String> inZone;
  final List<String> notInZone;
  final bool gameOver;
  final bool won;

  const Game3State({
    required this.cocktail,
    required this.realIngredients,
    required this.available,
    this.inZone = const [],
    this.notInZone = const [],
    this.gameOver = false,
    this.won = false,
  });

  bool get allPlaced => available.isEmpty;

  Game3State copyWith({
    List<String>? available,
    List<String>? inZone,
    List<String>? notInZone,
    bool? gameOver,
    bool? won,
  }) =>
      Game3State(
        cocktail: cocktail,
        realIngredients: realIngredients,
        available: available ?? this.available,
        inZone: inZone ?? this.inZone,
        notInZone: notInZone ?? this.notInZone,
        gameOver: gameOver ?? this.gameOver,
        won: won ?? this.won,
      );
}

class Game3Notifier extends AutoDisposeAsyncNotifier<Game3State> {
  static const _decoyPool = [
    'Absinthe', 'Amaretto', 'Baileys', 'Blue Curacao', 'Bourbon',
    'Campari', 'Chambord', 'Champagne', 'Coconut cream', 'Cucumber',
    'Elderflower', 'Grenadine', 'Kahlua', 'Malibu', 'Midori',
    'Orgeat', 'Passion fruit', 'Prosecco', 'Sour mix', 'Sparkling water',
    'Strawberry', 'Watermelon', 'Apple juice', 'Celery', 'Cherry',
    'Cream', 'Ginger beer', 'Honey', 'Cinnamon', 'Vanilla extract',
  ];

  @override
  Future<Game3State> build() => _fetch();

  Future<Game3State> _fetch() async {
    final result = await ref.read(getRandomCocktailUsecaseProvider)();
    final cocktail = switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw failure,
    };
    if (cocktail.ingredients.isEmpty) return _fetch();

    final rnd = Random();
    final realNames =
        cocktail.ingredients.take(5).map((i) => i.name).toList();
    final realSet = realNames.map((n) => n.toLowerCase()).toSet();

    final decoys = (List<String>.from(_decoyPool)..shuffle(rnd))
        .where((d) => !realSet.contains(d.toLowerCase()))
        .take(4)
        .toList();

    final all = [...realNames, ...decoys]..shuffle(rnd);

    debugPrint('[Game3] Cocktail: ${cocktail.name}');
    debugPrint('[Game3] Real ingredients (IN): ${realNames.join(', ')}');
    debugPrint('[Game3] Decoys (NOT IN): ${decoys.join(', ')}');
    return Game3State(
      cocktail: cocktail,
      realIngredients: realSet,
      available: all,
    );
  }

  void _move(String ingredient, _Zone zone) {
    final s = state.valueOrNull;
    if (s == null || s.gameOver) return;
    state = AsyncData(s.copyWith(
      available: s.available.where((i) => i != ingredient).toList(),
      inZone: zone == _Zone.inZone
          ? [...s.inZone.where((i) => i != ingredient), ingredient]
          : s.inZone.where((i) => i != ingredient).toList(),
      notInZone: zone == _Zone.notInZone
          ? [...s.notInZone.where((i) => i != ingredient), ingredient]
          : s.notInZone.where((i) => i != ingredient).toList(),
    ));
  }

  void dropToIn(String ingredient) => _move(ingredient, _Zone.inZone);
  void dropToNotIn(String ingredient) => _move(ingredient, _Zone.notInZone);

  void returnToAvailable(String ingredient) {
    final s = state.valueOrNull;
    if (s == null || s.gameOver) return;
    state = AsyncData(s.copyWith(
      available: [...s.available, ingredient],
      inZone: s.inZone.where((i) => i != ingredient).toList(),
      notInZone: s.notInZone.where((i) => i != ingredient).toList(),
    ));
  }

  void validate() {
    final s = state.valueOrNull;
    if (s == null || !s.allPlaced) return;
    final correctIn = s.inZone.length == s.realIngredients.length &&
        s.inZone.every((i) => s.realIngredients.contains(i.toLowerCase()));
    state = AsyncData(s.copyWith(gameOver: true, won: correctIn));
  }

  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

enum _Zone { inZone, notInZone }

final game3Provider =
    AsyncNotifierProvider.autoDispose<Game3Notifier, Game3State>(
  Game3Notifier.new,
);

enum CardState { hidden, flipped, matched }

class MemoryCard {
  final String text;
  final int pairId;
  final CardState state;

  const MemoryCard({
    required this.text,
    required this.pairId,
    this.state = CardState.hidden,
  });

  MemoryCard withState(CardState s) =>
      MemoryCard(text: text, pairId: pairId, state: s);
}

class Game4State {
  final List<MemoryCard> cards;
  final List<int> flippedIndices;
  final int moves;
  final int matchedPairs;
  final bool gameOver;
  final bool isLocked;

  const Game4State({
    required this.cards,
    this.flippedIndices = const [],
    this.moves = 0,
    this.matchedPairs = 0,
    this.gameOver = false,
    this.isLocked = false,
  });

  int get totalPairs => cards.length ~/ 2;

  Game4State copyWith({
    List<MemoryCard>? cards,
    List<int>? flippedIndices,
    int? moves,
    int? matchedPairs,
    bool? gameOver,
    bool? isLocked,
  }) =>
      Game4State(
        cards: cards ?? this.cards,
        flippedIndices: flippedIndices ?? this.flippedIndices,
        moves: moves ?? this.moves,
        matchedPairs: matchedPairs ?? this.matchedPairs,
        gameOver: gameOver ?? this.gameOver,
        isLocked: isLocked ?? this.isLocked,
      );
}

class Game4Notifier extends AutoDisposeAsyncNotifier<Game4State> {
  @override
  Future<Game4State> build() => _fetch();

  Future<Game4State> _fetch() async {
    final usecase = ref.read(getRandomCocktailUsecaseProvider);
    final seen = <String>{};
    final cocktails = <Cocktail>[];

    final futures = List.generate(16, (_) => usecase());
    final results = await Future.wait(futures);

    for (final r in results) {
      if (cocktails.length >= 8) break;
      if (r case ApiSuccess(:final data)) {
        if (data.ingredients.isNotEmpty && !seen.contains(data.name)) {
          seen.add(data.name);
          cocktails.add(data);
        }
      }
    }

    if (cocktails.length < 4) return _fetch();

    final rnd = Random();
    final count = cocktails.length.clamp(4, 8);
    final cards = <MemoryCard>[];
    for (var i = 0; i < count; i++) {
      final c = cocktails[i];
      final ing = c.ingredients[rnd.nextInt(c.ingredients.length)].name;
      cards
        ..add(MemoryCard(text: c.name, pairId: i))
        ..add(MemoryCard(text: ing, pairId: i));
    }
    cards.shuffle(rnd);
    debugPrint('[Game4] Pairs:');
    for (var i = 0; i < count; i++) {
      final c = cocktails[i];
      final ing = cards
          .where((card) => card.pairId == i && card.text != c.name)
          .map((card) => card.text)
          .firstOrNull ?? '';
      debugPrint('[Game4]   #$i  ${c.name}  ↔  $ing');
    }
    return Game4State(cards: cards);
  }

  Future<void> flipCard(int index) async {
    final s = state.valueOrNull;
    if (s == null || s.isLocked) return;
    if (s.cards[index].state != CardState.hidden) return;

    final cards = List<MemoryCard>.from(s.cards);
    cards[index] = cards[index].withState(CardState.flipped);
    final flipped = [...s.flippedIndices, index];

    if (flipped.length == 1) {
      state = AsyncData(s.copyWith(cards: cards, flippedIndices: flipped));
      return;
    }

    final i1 = flipped[0];
    final i2 = flipped[1];
    final moves = s.moves + 1;

    if (cards[i1].pairId == cards[i2].pairId) {
      cards[i1] = cards[i1].withState(CardState.matched);
      cards[i2] = cards[i2].withState(CardState.matched);
      final matched = s.matchedPairs + 1;
      state = AsyncData(s.copyWith(
        cards: cards,
        flippedIndices: [],
        moves: moves,
        matchedPairs: matched,
        gameOver: matched == s.totalPairs,
      ));
    } else {
      state = AsyncData(s.copyWith(
        cards: cards,
        flippedIndices: flipped,
        moves: moves,
        isLocked: true,
      ));
      await Future.delayed(const Duration(milliseconds: 900));
      final cur = state.valueOrNull;
      if (cur == null) return;
      final reset = List<MemoryCard>.from(cur.cards);
      reset[i1] = reset[i1].withState(CardState.hidden);
      reset[i2] = reset[i2].withState(CardState.hidden);
      state = AsyncData(cur.copyWith(
        cards: reset,
        flippedIndices: [],
        isLocked: false,
      ));
    }
  }

  Future<void> restart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final game4Provider =
    AsyncNotifierProvider.autoDispose<Game4Notifier, Game4State>(
  Game4Notifier.new,
);
