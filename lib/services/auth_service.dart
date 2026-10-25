import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants.dart';
import '../l10n/app_localizations.dart';
import '../models/app_user.dart';
import '../models/user_settings.dart';
import 'firebase_service.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? errorCode;
  final User? user;

  const AuthResult({
    required this.success,
    this.errorMessage,
    this.errorCode,
    this.user,
  });

  String? localizedError(AppLocalizations l10n) {
    if (success) return null;

    switch (errorCode) {
      case 'email-already-in-use':
        return l10n.authEmailAlreadyInUse;
      case 'invalid-email':
        return l10n.authInvalidEmail;
      case 'weak-password':
        return l10n.authWeakPassword;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.authInvalidCredentials;
      case 'user-disabled':
        return l10n.authUserDisabled;
      case 'too-many-requests':
        return l10n.authTooManyRequests;
      case 'requires-recent-login':
        return l10n.authRequiresRecentLogin;
      case 'network-request-failed':
        return l10n.authNetworkError;
      case 'operation-not-allowed':
        return l10n.authOperationNotAllowed;
      case 'user-token-expired':
      case 'invalid-user-token':
        return l10n.authSessionExpired;
      case 'no-user':
        return l10n.authNotAuthenticated;
      case 'user-creation-failed':
        return l10n.authUserCreationFailed;
      default:
        return l10n.authUnexpectedError;
    }
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseService.instance.auth;
  final FirebaseFirestore _db = FirebaseService.instance.firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return const AuthResult(
          success: false,
          errorCode: 'user-creation-failed',
          errorMessage: 'Не удалось создать пользователя',
        );
      }

      final appUser = AppUser(
        uid: user.uid,
        email: email.trim(),
        createdAt: DateTime.now(),
      );

      await _db
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(appUser.toMap());

      await _db
          .collection(AppConstants.settingsCollection)
          .doc(user.uid)
          .set(const UserSettings().toMap());

      return AuthResult(
        success: true,
        user: user,
      );
    } on FirebaseAuthException catch (e) {
      return _firebaseFailure(e);
    } catch (_) {
      return _unexpectedFailure();
    }
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return AuthResult(
        success: true,
        user: credential.user,
      );
    } on FirebaseAuthException catch (e) {
      return _firebaseFailure(e);
    } catch (_) {
      return _unexpectedFailure();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<AuthResult> deleteAccount({
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null || user.email == null) {
        return const AuthResult(
          success: false,
          errorCode: 'no-user',
          errorMessage: 'Пользователь не авторизован',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await _deleteUserData(user.uid);

      await user.delete();

      return const AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return _firebaseFailure(e);
    } catch (_) {
      return _unexpectedFailure();
    }
  }

  Future<void> _deleteUserData(String uid) async {
    final batch = _db.batch();

    batch.delete(
      _db.collection(AppConstants.usersCollection).doc(uid),
    );

    batch.delete(
      _db.collection(AppConstants.settingsCollection).doc(uid),
    );

    final favorites = await _db
        .collection(AppConstants.favoritesCollection)
        .where('userId', isEqualTo: uid)
        .get();

    for (final doc in favorites.docs) {
      batch.delete(doc.reference);
    }

    final identifications = await _db
        .collection(AppConstants.identificationsCollection)
        .where('userId', isEqualTo: uid)
        .get();

    for (final doc in identifications.docs) {
      final predictions = await doc.reference
          .collection(AppConstants.predictionsSubcollection)
          .get();

      for (final prediction in predictions.docs) {
        batch.delete(prediction.reference);
      }

      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  AuthResult _firebaseFailure(FirebaseAuthException exception) {
    return AuthResult(
      success: false,
      errorCode: exception.code,
      errorMessage: _mapAuthError(exception),
    );
  }

  AuthResult _unexpectedFailure() {
    return const AuthResult(
      success: false,
      errorCode: 'unexpected',
      errorMessage: 'Произошла непредвиденная ошибка',
    );
  }

  String _mapAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'email-already-in-use':
        return 'Этот email уже зарегистрирован';
      case 'invalid-email':
        return 'Некорректный email';
      case 'weak-password':
        return 'Слишком слабый пароль';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Неверный email или пароль';
      case 'user-disabled':
        return 'Аккаунт заблокирован';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      case 'requires-recent-login':
        return 'Требуется повторный вход для этой операции';
      case 'network-request-failed':
        return 'Ошибка подключения к сети';
      case 'operation-not-allowed':
        return 'Операция не разрешена';
      case 'user-token-expired':
      case 'invalid-user-token':
        return 'Срок действия сеанса истёк. Войдите снова';
      default:
        return 'Ошибка аутентификации';
    }
  }
}
