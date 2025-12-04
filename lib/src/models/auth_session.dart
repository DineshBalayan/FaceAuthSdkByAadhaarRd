class AuthSession {
  final String transactionId;
  final String sessionToken;
  final int expiresAt;
  final Map<String, dynamic> responseData;

  AuthSession({
    required this.transactionId,
    required this.sessionToken,
    required this.expiresAt,
    required this.responseData,
  });

  factory AuthSession.fromMap(Map<String, dynamic> m) {
    return AuthSession(
      transactionId: m['transactionId'] ?? '',
      sessionToken: m['sessionToken'] ?? '',
      expiresAt: m['expiresAt'] ?? DateTime.now().millisecondsSinceEpoch,
      responseData: Map<String, dynamic>.from(m['responseData'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    'transactionId': transactionId,
    'sessionToken': sessionToken,
    'expiresAt': expiresAt,
    'responseData': responseData,
  };
}