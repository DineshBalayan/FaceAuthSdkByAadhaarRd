import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/repository/face_auth_repository.dart';
import '../core/models/auth_result.dart';
part 'face_auth_state.dart';

class FaceAuthCubit extends Cubit<FaceAuthState> {
  final FaceAuthRepository repository;

  FaceAuthCubit(this.repository) : super(FaceAuthInitial());

  Future<void> startAuthentication() async {
    emit(FaceAuthLoading());
    try {
      final result = await repository.startAuth();
      emit(FaceAuthSuccess(result));
    } catch (e) {
      emit(FaceAuthFailure(e.toString()));
    }
  }
}
