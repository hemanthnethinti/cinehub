import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/portfolio/presentation/providers/portfolio_providers.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';


class PortfolioEditorScreen extends ConsumerStatefulWidget {
  const PortfolioEditorScreen({super.key, this.id});
  
  final String? id;

  @override
  ConsumerState<PortfolioEditorScreen> createState() => _PortfolioEditorScreenState();
}

class _PortfolioEditorScreenState extends ConsumerState<PortfolioEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPublished = true;

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.id != 'new') {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await ref.read(getPortfolioItemUseCaseProvider).call(widget.id!);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      result.when(
        success: (data) {
          _titleController.text = data.title;
          _descController.text = data.description;
          _categoryController.text = data.category;
          setState(() {
            _isPublished = data.isPublished;
          });
        },
        failure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.userMessage)));
        },
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final data = {
      'title': _titleController.text,
      'description': _descController.text,
      'category': _categoryController.text,
      'isPublished': _isPublished,
      'tags': ['cinematography', 'short-film'], // Mock tags, as tag input is complex
      'media': [
        {'url': 'https://example.com/placeholder.jpg', 'type': 'image'}
      ] // Mock media
    };

    final isNew = widget.id == null || widget.id == 'new';
    
    final result = isNew 
        ? await ref.read(createPortfolioItemUseCaseProvider).call(data)
        : await ref.read(updatePortfolioItemUseCaseProvider).call(widget.id!, data);

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        ref.read(portfolioListProvider.notifier).refresh();
        if (!isNew && widget.id != null) {
          ref.invalidate(portfolioDetailProvider(widget.id!));
        }
        context.pop();
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.userMessage)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(widget.id == 'new' ? 'Create Portfolio' : 'Edit Portfolio', style: AppTypography.headlineSmall),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: ShimmerBox(width: double.infinity, height: double.infinity))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.textTertiary),
                        SizedBox(height: AppSpacing.sm),
                        Text('Add Media (Placeholder)', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      hintText: 'e.g., Short Film, Commercial',
                    ),
                    controller: _categoryController,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    controller: _descController,
                    maxLines: 5,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SwitchListTile.adaptive(
                    title: const Text('Published', style: AppTypography.bodyLarge),
                    subtitle: const Text('Make this item visible to the public'),
                    value: _isPublished,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _isPublished = val),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
