import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/favorite.dart';
import '../services/favorites_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();

  StreamSubscription<List<Favorite>>? _subscription;
  String? _userId;
  List<Favorite> _favorites = [];
  bool _isLoading = false;
  bool _disposed = false;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Set<String> get favoriteMushroomIds =>
      _favorites.map((f) => f.mushroomId).toSet();

  void bind(String userId) {
    if (_userId == userId && _subscription != null) return;
    _userId = userId;
    _isLoading = true;
    _notifyDeferred();

    _subscription?.cancel();
    _subscription = _service.watchFavorites(userId).listen((items) {
      _favorites = items;
      _isLoading = false;
      notifyListeners();
    }, onError: (_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void _notifyDeferred() {
    Future.microtask(() {
      if (!_disposed) notifyListeners();
    });
  }

  Stream<List<Favorite>> getFavorites(String userId) =>
      _service.watchFavorites(userId);

  bool isFavorite(String mushroomId) =>
      _favorites.any((f) => f.mushroomId == mushroomId);

  Future<void> addToFavorites(String mushroomId) async {
    final uid = _userId;
    if (uid == null) return;
    await _service.addToFavorites(uid, mushroomId);
  }

  Future<void> removeFromFavorites(String mushroomId) async {
    final uid = _userId;
    if (uid == null) return;
    await _service.removeFromFavorites(uid, mushroomId);
  }

  Future<void> toggleFavorite(String mushroomId) async {
    if (isFavorite(mushroomId)) {
      await removeFromFavorites(mushroomId);
    } else {
      await addToFavorites(mushroomId);
    }
  }

  void reset() {
    if (_userId == null && _favorites.isEmpty && _subscription == null) {
      return;
    }
    _subscription?.cancel();
    _subscription = null;
    _userId = null;
    _favorites = [];
    _isLoading = false;
    _notifyDeferred();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
