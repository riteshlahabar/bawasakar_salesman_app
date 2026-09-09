/// Transport/protocol level failure raised by the API layer.
///
/// Carries the HTTP status so callers can branch on it without re-parsing the
/// response, and exposes named predicates instead of forcing every call site
/// to remember magic numbers.
class ApiException implements Exception {
  const ApiException(this.message, this.statusCode, this.body);

  final String message;
  final int statusCode;
  final Map<String, dynamic> body;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isValidation => statusCode == 422;

  bool get isRateLimited => statusCode == 429;

  bool get isServerError => statusCode >= 500;

  /// Field-keyed validation messages returned by Laravel's 422 responses.
  Map<String, List<String>> get fieldErrors {
    final errors = body['errors'];
    if (errors is! Map) return const {};
    return errors.map(
      (key, value) => MapEntry(
        key.toString(),
        value is Iterable
            ? value.map((item) => item.toString()).toList()
            : <String>[value.toString()],
      ),
    );
  }

  @override
  String toString() => message;
}
