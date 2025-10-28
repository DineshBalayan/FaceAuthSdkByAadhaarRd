class AuthResult {
  final String status;
  final String? message;
  final String? transactionId;

  AuthResult({
    required this.status,
    this.message,
    this.transactionId,
  });

  factory AuthResult.fromMap(Map<String, dynamic> map) {
    return AuthResult(
      status: map['status'] ?? 'unknown',
      message: map['message'],
      transactionId: map['transactionId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'status': status,
    'message': message,
    'transactionId': transactionId,
  };
}
