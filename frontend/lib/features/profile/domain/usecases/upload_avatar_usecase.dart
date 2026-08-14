import 'dart:io';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/profile/domain/repositories/profile_repository.dart';

class UploadAvatarUseCase {
  const UploadAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<String>> call(File file) async {
    return _repository.uploadAvatar(file);
  }
}
