import 'package:cinehubapp/core/error/app_error.dart';

sealed class ProjectFormState {
  const ProjectFormState();
}

final class ProjectFormIdle extends ProjectFormState {
  const ProjectFormIdle();
}

final class ProjectFormSubmitting extends ProjectFormState {
  const ProjectFormSubmitting();
}

final class ProjectFormSuccess extends ProjectFormState {
  const ProjectFormSuccess({this.projectId});
  final String? projectId;
}

final class ProjectFormFailure extends ProjectFormState {
  const ProjectFormFailure(this.error);
  final AppError error;
}
