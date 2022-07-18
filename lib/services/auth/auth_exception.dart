// Login
class UserNotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{}

// Register
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}
class InvalidEmailAuthException implements Exception{}

// Generic
class GenericAuthException implements Exception{}
class UserNotLoggedInAuthException implements Exception{}