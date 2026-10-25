import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../models/identification.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _service = HistoryService();

  StreamSubscription<List<Identification>>? _subscription;
  String? _userId;
  bool _disposed = false;

  List<Identification> _all = [];
  bool _isLoading = false;

  String _query = '';
  IdentificationStatus? _statusFilter;

  bool get isLoading => _isLoading;
  String get query => _query;
  IdentificationStatus? get statusFilter => _statusFilter;

  List<Identification> get all => _all;

  List<Identification> get filtered {
    Iterable<Identification> items = _all;

    if (_statusFilter != null) {
      items = items.where((i) => i.status == _statusFilter);
    }

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items.where((i) => i.results.any(
            (p) => p.mushroomName.toLowerCase().contains(q),
          ));
    }

    return items.toList();
  }

  List<Identification> recent(int count) => _all.take(count).toList();

  void bind(String userId) {
    if (_userId == userId && _subscription != null) return;
    _userId = userId;
    _isLoading = true;
    _notifyDeferred();

    _subscription?.cancel();
    _subscription = _service.watchHistory(userId).listen((items) {
      _all = items;
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

  void searchHistory(String query) {
    _query = query;
    notifyListeners();
  }

  void filterByStatus(IdentificationStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  Future<void> deleteIdentification(String id) async {
    await _service.deleteIdentification(id);
  }

  void reset() {
    if (_userId == null && _all.isEmpty && _subscription == null) return;
    _subscription?.cancel();
    _subscription = null;
    _userId = null;
    _all = [];
    _query = '';
    _statusFilter = null;
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
