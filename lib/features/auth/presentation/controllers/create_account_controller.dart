import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/auth/domain/auth_validators.dart';
import 'package:perla_app/features/auth/domain/create_account_navigation_target.dart';

final createAccountControllerProvider =
    StateNotifierProvider<CreateAccountController, CreateAccountState>((ref) {
  return CreateAccountController();
});

class CreateAccountState {
  final String password;
  final String confirmPassword;
  final bool showPassword;
  final bool showConfirmPassword;

  const CreateAccountState({
    this.password = '',
    this.confirmPassword = '',
    this.showPassword = false,
    this.showConfirmPassword = false,
  });

  bool get canContinue {
    if (!AuthValidators.isPasswordValid(password)) return false;
    if (!AuthValidators.isPasswordValid(confirmPassword)) return false;
    return password == confirmPassword;
  }

  CreateAccountState copyWith({
    String? password,
    String? confirmPassword,
    bool? showPassword,
    bool? showConfirmPassword,
  }) {
    return CreateAccountState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    );
  }
}

class CreateAccountController extends StateNotifier<CreateAccountState> {
  CreateAccountController() : super(const CreateAccountState());

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value);
  }

  void onConfirmPasswordChanged(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void toggleShowConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  CreateAccountNavigationTarget onContinueTapped() {
    return CreateAccountNavigationTarget.otp;
  }
}

