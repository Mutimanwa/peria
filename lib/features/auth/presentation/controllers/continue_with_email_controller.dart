import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/auth/domain/auth_validators.dart';
import 'package:perla_app/features/auth/domain/email_flow_navigation_target.dart';

final continueWithEmailControllerProvider =
    StateNotifierProvider<ContinueWithEmailController, ContinueWithEmailState>(
        (ref) {
  return ContinueWithEmailController();
});

class ContinueWithEmailState {
  final String email;

  const ContinueWithEmailState({this.email = ''});

  bool get canContinue => AuthValidators.isEmailValid(email);

  ContinueWithEmailState copyWith({String? email}) {
    return ContinueWithEmailState(email: email ?? this.email);
  }
}

class ContinueWithEmailController
    extends StateNotifier<ContinueWithEmailState> {
  ContinueWithEmailController() : super(const ContinueWithEmailState());

  void onEmailChanged(String value) {
    state = state.copyWith(email: value);
  }

  EmailFlowNavigationTarget onContinueTapped() {
    return EmailFlowNavigationTarget.createAccount;
  }
}
