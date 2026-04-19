import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/auth/data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;
  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });
  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  AuthNotifier(this._repository) : super(const AuthState());

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      // Listen to auth changes
      _repository.authStateChanges().listen((user) {
        if (mounted) {
          state = state.copyWith(
            user: user,
            isLoading: false,
            error: null,
          );
        }
      });
      // Get current user immediately
      final currentUser = await _repository.getCurrentUser();
      if (mounted) {
        state = state.copyWith(
          user: currentUser,
          isLoading: false,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> signInAnonymously() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.signInAnonymously();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
