import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/screens/edit_profile_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/register_screen.dart';
import '../providers/cocktail_providers.dart';
import '../providers/game_favorites_provider.dart';

class _LocalPhotoNotifier extends Notifier<String?> {
  static const _key = 'profile_photo_path';

  @override
  String? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_key);
  }

  Future<void> pick() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, picked.path);
    state = picked.path;
  }
}

final localPhotoProvider = NotifierProvider<_LocalPhotoNotifier, String?>(
  _LocalPhotoNotifier.new,
);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(authNotifierProvider, (prev, next) {
        if (next.error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: AppColors.noir,
            ),
          );
          ref.read(authNotifierProvider.notifier).clearError();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.beigeFonce, AppColors.rose],
        ),
      ),
      child: SafeArea(
        child: userAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.noir),
          ),
          error: (_, _) => const Center(
            child: Text('Something went wrong',
                style: TextStyle(color: AppColors.noir)),
          ),
          data: (UserEntity? user) =>
              user == null ? const _GuestView() : _buildMemberView(user),
        ),
      ),
    );
  }

  Widget _buildMemberView(UserEntity user) {
    final localPhoto = ref.watch(localPhotoProvider);
    final cocktailFavs =
        ref.watch(favoritesProvider).valueOrNull?.length ?? 0;
    final gameFavs = ref.watch(gameFavoritesProvider).length;
    final initials = _initials(user.displayName, user.email);

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: -50,
          child: Image.asset(
            'assets/images/pinkmascotte.png',
            width: 280,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
        Column(
          children: [
            _buildTopBar(user),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 130),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildAvatarSection(localPhoto, user, initials),
                    const SizedBox(height: 24),
                    _buildStatsRow(cocktailFavs, gameFavs),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopBar(UserEntity user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EditProfileScreen(),
              ),
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.beige.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.noir, width: 1.5),
              ),
              child: const Icon(Icons.settings_rounded,
                  color: AppColors.noir, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(
      String? localPhoto, UserEntity user, String initials) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => ref.read(localPhotoProvider.notifier).pick(),
          child: Stack(
            children: [
              _buildAvatar(localPhoto, user.photoUrl, initials),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.beige,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.noir, width: 1.5),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      size: 15, color: AppColors.noir),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (user.displayName != null && user.displayName!.isNotEmpty)
          Text(
            user.displayName!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
          ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.noir.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(
      String? localPhoto, String? networkPhoto, String initials) {
    if (localPhoto != null) {
      return CircleAvatar(
        radius: 56,
        backgroundImage: FileImage(File(localPhoto)),
        backgroundColor: AppColors.noir,
      );
    }
    if (networkPhoto != null) {
      return CircleAvatar(
        radius: 56,
        backgroundColor: AppColors.noir,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: networkPhoto,
            width: 112,
            height: 112,
            fit: BoxFit.cover,
            placeholder: (_, _) => _InitialsAvatar(initials: initials),
            errorWidget: (_, _, _) => _InitialsAvatar(initials: initials),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: 56,
      backgroundColor: AppColors.noir,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: AppColors.beige,
        ),
      ),
    );
  }

  Widget _buildStatsRow(int cocktailFavs, int gameFavs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
              child: _StatTile(value: '$cocktailFavs', label: 'Cocktails')),
          const SizedBox(width: 12),
          Expanded(
              child: _StatTile(value: '$gameFavs', label: 'Games')),
        ],
      ),
    );
  }

  String _initials(String? displayName, String email) {
    if (displayName != null && displayName.isNotEmpty) {
      final parts = displayName.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName[0].toUpperCase();
    }
    return email[0].toUpperCase();
  }
}

class _GuestView extends StatelessWidget {
  const _GuestView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: const BoxDecoration(
                  color: AppColors.noir,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded,
                    size: 54, color: AppColors.beige),
              ),
              const SizedBox(height: 24),
              const Text(
                'You are not signed in',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.noir,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to access your profile and track your activity.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.noir.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rose,
                    foregroundColor: AppColors.white,
                    side: const BorderSide(
                        color: AppColors.noir, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Sign In',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RegisterScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.beige,
                    foregroundColor: AppColors.noir,
                    side: const BorderSide(
                        color: AppColors.rose, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Create an account',
                      style: TextStyle(
                          fontSize: 16, color: AppColors.noir)),
                ),
              ),
            ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.beige.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.rose, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.noir.withValues(alpha: 0.65),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      color: AppColors.noir,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.beige,
          ),
        ),
      ),
    );
  }
}
