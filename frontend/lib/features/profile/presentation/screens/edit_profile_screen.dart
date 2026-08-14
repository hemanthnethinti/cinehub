import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/profile/domain/entities/location.dart';
import 'package:cinehubapp/features/profile/domain/entities/social_links.dart';
import 'package:cinehubapp/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:cinehubapp/features/profile/presentation/providers/profile_providers.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/skills_bottom_sheet.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:cinehubapp/shared/widgets/inputs/inputs.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _bioController;

  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;

  late final TextEditingController _websiteController;
  late final TextEditingController _linkedInController;
  late final TextEditingController _twitterController;
  late final TextEditingController _instagramController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileNotifierProvider.notifier).currentProfile;
    
    _firstNameController = TextEditingController(text: profile?.firstName ?? '');
    _lastNameController = TextEditingController(text: profile?.lastName ?? '');
    _headlineController = TextEditingController(text: profile?.headline ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');

    _cityController = TextEditingController(text: profile?.location?.city ?? '');
    _stateController = TextEditingController(text: profile?.location?.state ?? '');
    _countryController = TextEditingController(text: profile?.location?.country ?? '');

    _websiteController = TextEditingController(text: profile?.socialLinks?.website ?? '');
    _linkedInController = TextEditingController(text: profile?.socialLinks?.linkedin ?? '');
    _twitterController = TextEditingController(text: profile?.socialLinks?.twitter ?? '');
    _instagramController = TextEditingController(text: profile?.socialLinks?.instagram ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _headlineController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _websiteController.dispose();
    _linkedInController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  String? _urlValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Please enter a valid URL (e.g. https://...)';
    }
    return null;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    
    final profile = ref.read(profileNotifierProvider.notifier).currentProfile;
    if (profile == null) return;

    final newFirstName = _firstNameController.text.trim();
    final newLastName = _lastNameController.text.trim();
    final newHeadline = _headlineController.text.trim();
    final newBio = _bioController.text.trim();

    final newCity = _cityController.text.trim();
    final newState = _stateController.text.trim();
    final newCountry = _countryController.text.trim();

    final newWebsite = _websiteController.text.trim();
    final newLinkedIn = _linkedInController.text.trim();
    final newTwitter = _twitterController.text.trim();
    final newInstagram = _instagramController.text.trim();

    final hasLocationChanged = profile.location?.city != newCity ||
        profile.location?.state != newState ||
        profile.location?.country != newCountry;

    final hasSocialChanged = profile.socialLinks?.website != newWebsite ||
        profile.socialLinks?.linkedin != newLinkedIn ||
        profile.socialLinks?.twitter != newTwitter ||
        profile.socialLinks?.instagram != newInstagram;

    final params = ProfileUpdateParams(
      firstName: newFirstName != profile.firstName ? newFirstName : null,
      lastName: newLastName != profile.lastName ? newLastName : null,
      headline: newHeadline != (profile.headline ?? '') ? newHeadline : null,
      bio: newBio != (profile.bio ?? '') ? newBio : null,
      location: hasLocationChanged
          ? Location(city: newCity, state: newState, country: newCountry)
          : null,
      socialLinks: hasSocialChanged
          ? SocialLinks(
              website: newWebsite,
              linkedin: newLinkedIn,
              twitter: newTwitter,
              instagram: newInstagram,
              // Keep other existing links
              imdb: profile.socialLinks?.imdb,
              youtube: profile.socialLinks?.youtube,
              vimeo: profile.socialLinks?.vimeo,
            )
          : null,
    );

    if (!params.hasData) {
      context.pop();
      return;
    }

    ref.read(profileNotifierProvider.notifier).updateProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final isUpdating = state is ProfileUpdating;

    ref.listen<ProfileState>(
      profileNotifierProvider,
      (previous, next) {
        if (next is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error.userMessage),
              backgroundColor: AppColors.error,
            ),
          );
          ref.read(profileNotifierProvider.notifier).clearStatus();
        } else if (next is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.successMuted,
            ),
          );
          ref.read(profileNotifierProvider.notifier).clearStatus();
          if (context.canPop()) {
            context.pop();
          }
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: isUpdating ? null : () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Personal Information', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.md),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'First Name',
                      controller: _firstNameController,
                      enabled: !isUpdating,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      enabled: !isUpdating,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              
              AppTextField(
                label: 'Headline',
                hint: 'e.g. Director | Cinematographer',
                controller: _headlineController,
                enabled: !isUpdating,
                maxLength: 100,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                label: 'Bio',
                hint: 'Tell us about yourself...',
                controller: _bioController,
                enabled: !isUpdating,
                maxLines: 4,
                minLines: 3,
                maxLength: 500,
              ),
              const SizedBox(height: AppSpacing.xl),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Skills', style: AppTypography.headlineMedium),
                  TextButton(
                    onPressed: isUpdating ? null : () => SkillsBottomSheet.show(context),
                    child: const Text('Edit Skills'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Builder(builder: (context) {
                final skills = ref.watch(profileNotifierProvider.notifier).currentProfile?.skills ?? [];
                if (skills.isEmpty) {
                  return Text(
                    'No skills added yet.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                  );
                }
                return Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: skills.map((s) => Chip(
                    label: Text('${s.name} • ${s.proficiency}'),
                    backgroundColor: AppColors.surfaceElevated,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: AppTypography.caption,
                  )).toList(),
                );
              }),
              const SizedBox(height: AppSpacing.xl),

              Text('Location', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                label: 'City',
                controller: _cityController,
                enabled: !isUpdating,
              ),
              const SizedBox(height: AppSpacing.md),
              
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'State',
                      controller: _stateController,
                      enabled: !isUpdating,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Country',
                      controller: _countryController,
                      enabled: !isUpdating,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              Text('Social Links', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Website',
                hint: 'https://...',
                controller: _websiteController,
                enabled: !isUpdating,
                validator: _urlValidator,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                label: 'LinkedIn',
                hint: 'https://linkedin.com/in/...',
                controller: _linkedInController,
                enabled: !isUpdating,
                validator: _urlValidator,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                label: 'X / Twitter',
                hint: 'https://twitter.com/...',
                controller: _twitterController,
                enabled: !isUpdating,
                validator: _urlValidator,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                label: 'Instagram',
                hint: 'https://instagram.com/...',
                controller: _instagramController,
                enabled: !isUpdating,
                validator: _urlValidator,
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      label: 'Cancel',
                      onPressed: isUpdating ? null : () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: 'Save Changes',
                      isLoading: isUpdating,
                      onPressed: isUpdating ? null : _onSave,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.colossal),
            ],
          ),
        ),
      ),
    );
  }
}
