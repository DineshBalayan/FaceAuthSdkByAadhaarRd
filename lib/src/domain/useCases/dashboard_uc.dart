import 'package:dartz/dartz.dart';
import '../../data/models/dashboard_request.dart';
import '../../helper/core_use_case.dart';
import '../../helper/error/failure.dart';
import '../entities/dashboard_entity.dart';
import '../repository/server_repository.dart';

class DashboardUseCase extends CoreUseCase<DashboardEntity, DashboardRequest> {
  final ServerRepository repository;

  DashboardUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardEntity>> call({
    required DashboardRequest param,
  }) {
    return repository.dashboardLoad(param);
  }
}
