// lib/core/providers/app_state.dart

import 'package:flutter/foundation.dart';

/// Global application state
/// Manages app-wide concerns like loading, errors, navigation
class AppState extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _currentRoute;
  Map<String, dynamic> _cache = {};

  // ==========================================
  // GETTERS
  // ==========================================

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentRoute => _currentRoute;

  // ==========================================
  // LOADING STATE
  // ==========================================

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<T> withLoading<T>(Future<T> Function() action) async {
    setLoading(true);
    try {
      final result = await action();
      setLoading(false);
      return result;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      rethrow;
    }
  }

  // ==========================================
  // ERROR STATE
  // ==========================================

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ==========================================
  // NAVIGATION STATE
  // ==========================================

  void setCurrentRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  // ==========================================
  // CACHE MANAGEMENT
  // ==========================================

  T? getCached<T>(String key) {
    return _cache[key] as T?;
  }

  void setCached<T>(String key, T value) {
    _cache[key] = value;
  }

  void clearCache() {
    _cache.clear();
    notifyListeners();
  }

  void removeCached(String key) {
    _cache.remove(key);
    notifyListeners();
  }

  // ==========================================
  // RESET
  // ==========================================

  void reset() {
    _isLoading = false;
    _error = null;
    _currentRoute = null;
    _cache.clear();
    notifyListeners();
  }
}
