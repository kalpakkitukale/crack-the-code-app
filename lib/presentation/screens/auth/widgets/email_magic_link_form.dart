/// Email Magic Link Form Widget
/// Form for passwordless email authentication
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/services/secure_storage_service.dart';
import 'package:crack_the_code/presentation/providers/auth/auth_provider.dart';

/// Email magic link sign-in form
class EmailMagicLinkForm extends ConsumerStatefulWidget {
  final VoidCallback onCancel;
  final bool isJunior;

  const EmailMagicLinkForm({
    super.key,
    required this.onCancel,
    this.isJunior = false,
  });

  @override
  ConsumerState<EmailMagicLinkForm> createState() => _EmailMagicLinkFormState();
}

class _EmailMagicLinkFormState extends ConsumerState<EmailMagicLinkForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    if (_emailSent || authState.emailLinkSent) {
      return _buildEmailSentState(context, theme);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email input field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _sendMagicLink(),
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: widget.isJunior
                  ? 'parent@example.com'
                  : 'your.email@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.isJunior ? 16 : 12),
              ),
              helperText: widget.isJunior
                  ? 'Enter your parent\'s email address'
                  : null,
            ),
            style: TextStyle(fontSize: widget.isJunior ? 18 : 16),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          SizedBox(height: widget.isJunior ? 20 : 16),

          // Send link button
          FilledButton(
            onPressed: authState.isLoading ? null : _sendMagicLink,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: widget.isJunior ? 16 : 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.isJunior ? 16 : 12),
              ),
            ),
            child: authState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Send Magic Link',
                    style: TextStyle(fontSize: widget.isJunior ? 18 : 16),
                  ),
          ),

          SizedBox(height: widget.isJunior ? 16 : 12),

          // Back button
          TextButton(
            onPressed: widget.onCancel,
            child: Text(
              'Back to other options',
              style: TextStyle(fontSize: widget.isJunior ? 16 : 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSentState(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Success icon
        Container(
          width: widget.isJunior ? 80 : 64,
          height: widget.isJunior ? 80 : 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read,
            size: widget.isJunior ? 40 : 32,
            color: theme.colorScheme.primary,
          ),
        ),

        SizedBox(height: widget.isJunior ? 24 : 16),

        // Title
        Text(
          'Check your email!',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: widget.isJunior ? 24 : 22,
          ),
        ),

        const SizedBox(height: 8),

        // Description
        Text(
          'We sent a magic link to',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _emailController.text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),

        SizedBox(height: widget.isJunior ? 16 : 12),

        // Instructions
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Click the link in the email to sign in. The link expires in 1 hour.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: widget.isJunior ? 24 : 20),

        // Change email button
        OutlinedButton(
          onPressed: () {
            setState(() => _emailSent = false);
            ref.read(authNotifierProvider.notifier).resetEmailLinkState();
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: widget.isJunior ? 14 : 12,
              horizontal: 24,
            ),
          ),
          child: const Text('Use a different email'),
        ),

        const SizedBox(height: 8),

        // Back button
        TextButton(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).resetEmailLinkState();
            widget.onCancel();
          },
          child: const Text('Back to other options'),
        ),
      ],
    );
  }

  Future<void> _sendMagicLink() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    // Save email securely for later verification (when user clicks link)
    await secureStorage.write(SecureStorageKeys.pendingEmailLink, email);

    final success =
        await ref.read(authNotifierProvider.notifier).sendEmailLink(email);

    if (success && mounted) {
      setState(() => _emailSent = true);
    }
  }
}
