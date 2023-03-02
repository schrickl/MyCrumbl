enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  weakPassword,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    AuthResultStatus status;
    switch (e.code) {
      case 'invalid-email':
        status = AuthResultStatus.invalidEmail;
        break;
      case 'wrong-password':
        status = AuthResultStatus.wrongPassword;
        break;
      case 'user-not-found':
        status = AuthResultStatus.userNotFound;
        break;
      case 'user-disabled':
        status = AuthResultStatus.userDisabled;
        break;
      case 'too-many-requests':
        status = AuthResultStatus.tooManyRequests;
        break;
      case 'operation-not-allowed':
        status = AuthResultStatus.operationNotAllowed;
        break;
      case 'email-already-in-use':
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case 'error-weak-password':
        status = AuthResultStatus.weakPassword;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = 'Your email address appears to be invalid.';
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = 'The password you entered is incorrect.';
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = 'User with this email doesn\'t exist.';
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = 'User with this email has been disabled.';
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = 'Too many requests. Try again later.';
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = 'Signing in with Email and Password is not enabled.';
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            'The email has already been registered. Please login or reset your password.';
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = 'The password is too weak.';
        break;
      default:
        errorMessage = 'An unknown error has occurred.';
    }

    return errorMessage;
  }
}
