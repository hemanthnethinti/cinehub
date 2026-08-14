import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/shared/widgets/inputs/inputs.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_form_provider.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_form_state.dart';

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key, this.initialProject});

  final Project? initialProject;

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _titleController;
  late final TextEditingController _taglineController;
  late final TextEditingController _synopsisController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _coverUrlController;
  late final TextEditingController _posterUrlController;
  late final TextEditingController _genresController;

  String _type = 'short_film';
  String _status = 'draft';
  String _visibility = 'private';

  final _projectTypes = ['short_film', 'feature_film', 'documentary', 'series', 'commercial'];
  final _projectStatuses = ['draft', 'pre_production', 'production', 'post_production', 'completed', 'published', 'on_hold', 'cancelled'];
  final _visibilityOptions = ['public', 'private', 'team_only'];

  @override
  void initState() {
    super.initState();
    final p = widget.initialProject;
    _titleController = TextEditingController(text: p?.title ?? '');
    _taglineController = TextEditingController(text: p?.tagline ?? '');
    _synopsisController = TextEditingController(text: p?.synopsis ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _coverUrlController = TextEditingController(text: p?.coverUrl ?? '');
    _posterUrlController = TextEditingController(text: p?.posterUrl ?? '');
    _genresController = TextEditingController(text: p?.genres.join(', ') ?? '');
    
    if (p != null) {
      _type = p.type;
      _status = p.status;
      _visibility = p.visibility;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _taglineController.dispose();
    _synopsisController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    _posterUrlController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    final genres = _genresController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    ref.read(projectFormProvider.notifier).submit(
      id: widget.initialProject?.id,
      title: _titleController.text.trim(),
      type: _type,
      status: _status,
      visibility: _visibility,
      tagline: _taglineController.text.trim(),
      synopsis: _synopsisController.text.trim(),
      description: _descriptionController.text.trim(),
      coverUrl: _coverUrlController.text.trim(),
      posterUrl: _posterUrlController.text.trim(),
      genres: genres,
    );
  }

  String _formatEnum(String value) {
    return value.split('_').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(projectFormProvider);
    final isLoading = formState is ProjectFormSubmitting;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Core Details', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Title *',
            hint: 'e.g., The Silent Echo',
            controller: _titleController,
            enabled: !isLoading,
            validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Tagline',
            hint: 'A short catchy phrase',
            controller: _taglineController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Synopsis',
            hint: 'Brief summary of the plot',
            controller: _synopsisController,
            maxLines: 3,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Description',
            hint: 'Detailed description, cast, crew notes',
            controller: _descriptionController,
            maxLines: 5,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Classification', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          _buildDropdown('Type *', _type, _projectTypes, (v) => setState(() => _type = v!)),
          const SizedBox(height: AppSpacing.md),
          _buildDropdown('Status *', _status, _projectStatuses, (v) => setState(() => _status = v!)),
          const SizedBox(height: AppSpacing.md),
          _buildDropdown('Visibility *', _visibility, _visibilityOptions, (v) => setState(() => _visibility = v!)),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Genres',
            hint: 'Action, Drama, Sci-Fi (comma separated)',
            controller: _genresController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Media URLs', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Cover Image URL',
            hint: 'https://...',
            controller: _coverUrlController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Poster Image URL',
            hint: 'https://...',
            controller: _posterUrlController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (formState is ProjectFormFailure)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                formState.error.userMessage,
                style: AppTypography.labelMedium.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          PrimaryButton(
            label: widget.initialProject == null ? 'Create Project' : 'Save Changes',
            onPressed: isLoading ? null : _submit,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceElevated,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surfaceElevated,
              items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(_formatEnum(opt)))).toList(),
              onChanged: ref.watch(projectFormProvider) is ProjectFormSubmitting ? null : onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
