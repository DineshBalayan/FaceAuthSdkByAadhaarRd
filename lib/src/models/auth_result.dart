class AuthResult {
  final String status;
  final String? transactionId;
  final String? message;
  final bool otpFlowSelected;

  AuthResult({
    required this.status,
    this.transactionId,
    this.message,
    this.otpFlowSelected = false,
  });

  factory AuthResult.fromMap(Map<String, dynamic> m) {
    return AuthResult(
      status: m['status'] ?? 'error',
      transactionId: m['transactionId'],
      message: m['message'],
      otpFlowSelected: m['otpFlowSelected'] == true,
    );
  }

  Map<String, dynamic> toMap() => {
    'status': status,
    'transactionId': transactionId,
    'message': message,
    'otpFlowSelected': otpFlowSelected,
  };
}
