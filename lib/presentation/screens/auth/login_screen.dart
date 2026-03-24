/// Login Screen
/// Main authentication screen with Google, Apple, and Email sign-in options
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/presentation/providers/auth/auth_provider.dart';
import 'package:streamshaala/presentation/screens/auth/widgets/google_sign_in_button.dart';
import 'package:streamshaala/presentation/screens/auth/widgets/apple_sign_in_button.dart';
import 'package:streamshaala/presentation/screens/auth/widgets/email_magic_link_form.dart';

/// Login screen with multiple authentication options
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _showEmailForm = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isJunior = SegmentConfig.isJunior;
    final theme = Theme.of(context);

    // Listen for auth errors
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    // Listen for successful authentication
    ref.listen(authStateChangesProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && context.mounted) {
          // User is authenticated, navigate to home
          // The redirect handler will check onboarding status
          context.go('/home');
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isJunior ? 32 : 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and App Name
                  _buildHeader(context, isJunior),

                  SizedBox(height: isJunior ? 48 : 40),

                  // Welcome Text
                  _buildWelcomeText(context, isJunior),

                  SizedBox(height: isJunior ? 40 : 32),

                  // Auth buttons or loading
                  if (authState.isLoading && !_showEmailForm)
                    _buildLoadingState(context)
                  else
                    _buildAuthOptions(context, authState, isJunior),

                  SizedBox(height: isJunior ? 32 : 24),

                  // Terms and Privacy
                  _buildTermsText(context, isJunior),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isJunior) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;

    return Column(
      children: [
        // App Icon
        Container(
          width: isJunior ? 100 : 80,
          height: isJunior ? 100 : 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(isJunior ? 24 : 20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            isJunior ? Icons.rocket_launch : Icons.school,
            size: isJunior ? 48 : 40,
            color: theme.colorScheme.primary,
          ),
        ),

        const SizedBox(height: 16),

        // App Name
        Text(
          settings.appName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context, bool isJunior) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          isJunior ? 'Welcome, Explorer!' : 'Welcome Back',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          isJunior
              ? 'Sign in to start your learning adventure'
              : 'Sign in to continue your studies',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Signing in...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildAuthOptions(
    BuildContext context,
    dynamic authState,
    bool isJunior,
  ) {
    final showAppleSignIn = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Google Sign-In (Primary - works everywhere)
        GoogleSignInButton(
          onPressed: _signInWithGoogle,
          isJunior: isJunior,
          isLoading: authState.isLoading,
        ),

        SizedBox(height: isJunior ? 16 : 12),

        // Apple Sign-In (iOS/macOS only)
        if (showAppleSignIn) ...[
          AppleSignInButton(
            onPressed: _signInWithApple,
            isJunior: isJunior,
            isLoading: authState.isLoading,
          ),
          SizedBox(height: isJunior ? 16 : 12),
        ],

        // Divider with "or"
        _buildDivider(context),

        SizedBox(height: isJunior ? 16 : 12),

        // Email Magic Link option
        if (_showEmailForm)
          EmailMagicLinkForm(
            onCancel: () => setState(() => _showEmailForm = false),
            isJunior: isJunior,
          )
        else
          OutlinedButton.icon(
            onPressed: () => setState(() => _showEmailForm = true),
            icon: const Icon(Icons.email_outlined),
            label: Text(
              'Continue with Email',
              style: TextStyle(
                fontSize: isJunior ? 18 : 16,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: isJunior ? 16 : 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isJunior ? 16 : 12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(color: theme.colorScheme.outlineVariant),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: theme.colorScheme.outlineVariant),
        ),
      ],
    );
  }

  Widget _buildTermsText(BuildContext context, bool isJunior) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'By signing in, you agree to our Terms of Service and Privacy Policy',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  Future<void> _signInWithApple() async {
    await ref.read(authNotifierProvider.notifier).signInWithApple();
  }
}
