
import '../../data/models/auth_session.dart';
import '../repository/server_repository.dart';

class AttestationUseCase {
  final ServerRepository repository;

  AttestationUseCase(this.repository);

  Future<AuthSession> call(String appId, Map<String, dynamic>? data) {
    return repository.performAttestation(appId, data);
  }
}
