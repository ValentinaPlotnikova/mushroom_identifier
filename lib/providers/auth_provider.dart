import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  StreamSubscription<User?>? _authSub;

  AuthStatus _status = AuthStatus.unknown;
  User? _firebaseUser;
  AppUser? _appUser;
  bool _isLoading = false;

  AuthProvider() {
    _authSub = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user == null) {
      _appUser = null;
      _status = AuthStatus.unauthenticated;
    } else {
      _status = AuthStatus.authenticated;
      await _loadAppUser(user.uid);
    }
    notifyListeners();
  }

  Future<void> _loadAppUser(String uid) async {
    try {
      _appUser = await _firestoreService.getUser(uid);
    } catch (_) {
      _appUser = null;
    }
  }

  Future<void> refreshUser() async {
    final uid = _firebaseUser?.uid;
    if (uid != null) {
      await _loadAppUser(uid);
      notifyListeners();
    }
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final result = await _authService.signUp(email: email, password: password);
    _setLoading(false);
    return result;
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final result = await _authService.signIn(email: email, password: password);
    _setLoading(false);
    return result;
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _setLoading(false);
  }

  Future<AuthResult> deleteAccount({required String password}) async {
    _setLoading(true);
    final result = await _authService.deleteAccount(password: password);
    _setLoading(false);
    return result;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
