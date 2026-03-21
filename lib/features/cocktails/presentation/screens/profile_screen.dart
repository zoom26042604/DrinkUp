import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/google_logo.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/screens/edit_profile_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/register_screen.dart';

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
    final authState = ref.watch(authNotifierProvider);

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
          error: (err, _) => const Center(child: Text('Something went wrong')),
          data: (user) {
            if (user == null) {
              return _GuestView();
            }

            final initials = _initials(user.displayName, user.email);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.noir,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.beige,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (user.displayName != null && user.displayName!.isNotEmpty)
                    Text(
                      user.displayName!,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.noir,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.noir.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.beige.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'My Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.noir,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.edit_rounded,
                                  color: AppColors.rose, size: 20),
                              tooltip: 'Edit profile',
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    currentDisplayName: user.displayName,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.person_rounded,
                          label: 'Username',
                          value: user.displayName?.isNotEmpty == true
                              ? user.displayName!
                              : 'Not set',
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.email_rounded,
                          label: 'Email',
                          value: user.email,
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: AppColors.rose, thickness: 0.5),
                        const SizedBox(height: 16),
                        const Text(
                          'Connected accounts',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.noir,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (user.isGoogleLinked)
                          Row(
                            children: [
                              const GoogleLogo(size: 28),
                              const SizedBox(width: 10),
                              const Text(
                                'Google account linked',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.noir,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.link_off_rounded,
                                  color: AppColors.rose,
                                  size: 20,
                                ),
                                tooltip: 'Unlink Google',
                                onPressed: () =>
                                    _confirmUnlinkGoogle(context, ref),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : () => ref
                                      .read(authNotifierProvider.notifier)
                                      .linkWithGoogle(),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.beige,
                                foregroundColor: AppColors.noir,
                                side: const BorderSide(
                                    color: AppColors.rose, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: AppColors.noir,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const GoogleLogo(size: 20),
                                        const SizedBox(width: 8),
                                        const Text('Link Google account'),
                                      ],
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmSignOut(context, ref),
                      icon: const Icon(Icons.logout_rounded,
                          color: AppColors.noir),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 16, color: AppColors.noir),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.beige,
                        side:
                            const BorderSide(color: AppColors.rose, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
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

  Future<void> _confirmUnlinkGoogle(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.beige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Unlink Google',
            style: TextStyle(color: AppColors.noir)),
        content: const Text(
          'Are you sure you want to unlink your Google account?',
          style: TextStyle(color: AppColors.noir),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child:
                const Text('Cancel', style: TextStyle(color: AppColors.noir)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose,
              foregroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.noir, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).unlinkGoogle();
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.beige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            const Text('Sign Out', style: TextStyle(color: AppColors.noir)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.noir),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child:
                const Text('Cancel', style: TextStyle(color: AppColors.noir)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose,
              foregroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.noir, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }
}

class _GuestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 52,
            backgroundColor: AppColors.noir,
            child:
                Icon(Icons.person_rounded, size: 52, color: AppColors.beige),
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
            'Sign in to access your account and track your activity.',
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
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.noir, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text('Sign In', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.beige,
                foregroundColor: AppColors.noir,
                side: const BorderSide(color: AppColors.rose, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Create an account',
                style: TextStyle(fontSize: 16, color: AppColors.noir),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.noir, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.noir.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.noir,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
