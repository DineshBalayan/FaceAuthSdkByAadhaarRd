class IntegrityCache {
  final bool isVerified;
  final int validTillMillis;
  final String integrityHash;

  IntegrityCache({
    required this.isVerified,
    required this.validTillMillis,
    required this.integrityHash,
  });

  factory IntegrityCache.fromMap(Map<String, dynamic> m) {
    return IntegrityCache(
      isVerified: m['isVerified'] ?? false,
      validTillMillis: m['validTillMillis'] ?? 0,
      integrityHash: m['integrityHash'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'isVerified': isVerified,
    'validTillMillis': validTillMillis,
    'integrityHash': integrityHash,
  };

  bool get isFresh => DateTime.now().millisecondsSinceEpoch < validTillMillis;
}
