import '../repository/server_repository.dart';

class CheckRdInstalledUseCase {
  final ServerRepository repository;

  CheckRdInstalledUseCase(this.repository);

  Future<bool> call(String packageName) {
    return repository.isRdAppInstalled(packageName);
  }
}
