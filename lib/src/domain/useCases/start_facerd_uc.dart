import '../repository/server_repository.dart';

class StartFaceRdUseCase {
  final ServerRepository repository;

  StartFaceRdUseCase(this.repository);

  Future<String?> call(String pidOptions) {
    return repository.startFaceRD(pidOptions);
  }
}
