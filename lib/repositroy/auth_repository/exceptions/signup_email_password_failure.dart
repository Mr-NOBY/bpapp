class SignupEmailPasswordFailure {
  final String message;

  const SignupEmailPasswordFailure(
      [this.message = 'An unknown error occurred!']);

  factory SignupEmailPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupEmailPasswordFailure(
            'Please enter a stronger password');
      case 'invalid-email':
        return const SignupEmailPasswordFailure('Please enter a proper E-mail');
      case 'email-already-in-use':
        return const SignupEmailPasswordFailure(
            'An account already exists for this email');
      case 'operation-not-allowed':
        return const SignupEmailPasswordFailure('Operation is not allowed');
      case 'user-disabled':
        return const SignupEmailPasswordFailure(
            'This user has been disabled. Please contact the support');
      default:
        return const SignupEmailPasswordFailure();
    }
  }
}
