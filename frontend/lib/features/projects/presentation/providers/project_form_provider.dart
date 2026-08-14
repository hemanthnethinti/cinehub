import 'package:cinehubapp/features/projects/presentation/providers/project_providers.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final projectFormProvider = AutoDisposeNotifierProvider<ProjectFormNotifier, ProjectFormState>(
  ProjectFormNotifier.new,
);

class ProjectFormNotifier extends AutoDisposeNotifier<ProjectFormState> {
  @override
  ProjectFormState build() => const ProjectFormIdle();

  Future<void> submit({
    String? id, // If id is provided, we update, else we create
    required String title,
    required String type,
    required String status,
    required String visibility,
    String? tagline,
    String? synopsis,
    String? description,
    List<String>? genres,
    String? coverUrl,
    String? posterUrl,
  }) async {
    state = const ProjectFormSubmitting();

    final data = <String, dynamic>{
      'title': title,
      'type': type,
      'status': status,
      'visibility': visibility,
      if (tagline != null && tagline.isNotEmpty) 'tagline': tagline,
      if (synopsis != null && synopsis.isNotEmpty) 'synopsis': synopsis,
      if (description != null && description.isNotEmpty) 'description': description,
      if (genres != null && genres.isNotEmpty) 'genres': genres,
      if (coverUrl != null && coverUrl.isNotEmpty) 'coverImage': coverUrl,
      if (posterUrl != null && posterUrl.isNotEmpty) 'poster': posterUrl,
    };

    final result = id != null
        ? await ref.read(updateProjectUseCaseProvider).call(id, data)
        : await ref.read(createProjectUseCaseProvider).call(data);

    result.when(
      success: (project) {
        state = ProjectFormSuccess(projectId: project.id);
        ref.invalidate(projectsNotifierProvider);
        if (id != null) ref.invalidate(projectDetailProvider(id));
      },
      failure: (error) {
        state = ProjectFormFailure(error);
      },
    );
  }
}
