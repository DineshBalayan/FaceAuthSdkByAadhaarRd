class AuthSession {
  final String transactionId;
  final String sessionToken;
  final int expiresAt; // epoch millis

  AuthSession({
    required this.transactionId,
    required this.sessionToken,
    required this.expiresAt,
  });

  factory AuthSession.fromMap(Map<String, dynamic> m) {
    return AuthSession(
      transactionId: m['transactionId'] ?? '',
      sessionToken: m['sessionToken'] ?? '',
      expiresAt: m['expiresAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() => {
    'transactionId': transactionId,
    'sessionToken': sessionToken,
    'expiresAt': expiresAt,
  };
}
