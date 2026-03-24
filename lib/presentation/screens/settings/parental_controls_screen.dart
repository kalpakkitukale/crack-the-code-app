// Parental Controls Screen
// Allows parents to set up and manage parental controls for the Junior app

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/parental/parental_settings.dart';
import 'package:streamshaala/presentation/providers/parental/parental_controls_provider.dart';

/// Parental Controls Screen - Entry point
class ParentalControlsScreen extends ConsumerWidget {
  const ParentalControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parentalControlsProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If parental controls not set up, show setup screen
    if (!state.settings.isEnabled) {
      return const _SetupScreen();
    }

    // If not in parent mode, show PIN entry
    if (!state.isParentMode) {
      return const _PinEntryScreen();
    }

    // Show parent dashboard
    return const _ParentDashboardScreen();
  }
}

/// Setup Screen - First time setup for parental controls
class _SetupScreen extends ConsumerStatefulWidget {
  const _SetupScreen();

  @override
  ConsumerState<_SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<_SetupScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Parent Controls'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon and description
              Icon(
                Icons.family_restroom,
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Protect Your Child',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Set up a 4-digit PIN to access parental controls. '
                'This will allow you to set screen time limits and '
                'content restrictions.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // PIN fields
              _PinField(
                controller: _pinController,
                label: 'Create PIN',
                hint: 'Enter 4-digit PIN',
                obscure: _obscurePin,
                onToggleObscure: () {
                  setState(() => _obscurePin = !_obscurePin);
                },
              ),
              const SizedBox(height: 16),
              _PinField(
                controller: _confirmPinController,
                label: 'Confirm PIN',
                hint: 'Re-enter PIN',
                obscure: _obscureConfirm,
                onToggleObscure: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),
              const SizedBox(height: 32),

              // Setup button
              FilledButton.icon(
                onPressed: _setupParentalControls,
                icon: const Icon(Icons.lock_outline),
                label: const Text('Enable Parental Controls'),
              ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setupParentalControls() async {
    final pin = _pinController.text;
    final confirmPin = _confirmPinController.text;

    if (pin.length != 4) {
      _showError('PIN must be 4 digits');
      return;
    }

    if (pin != confirmPin) {
      _showError('PINs do not match');
      return;
    }

    final success = await ref
        .read(parentalControlsProvider.notifier)
        .setupParentalControls(pin);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parental controls enabled'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else if (mounted) {
      final error = ref.read(parentalControlsProvider).error;
      _showError(error ?? 'Failed to set up parental controls');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
}

/// PIN Entry Screen - Authenticate parent
class _PinEntryScreen extends ConsumerStatefulWidget {
  const _PinEntryScreen();

  @override
  ConsumerState<_PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<_PinEntryScreen> {
  final _pinController = TextEditingController();
  bool _obscure = true;
  bool _isVerifying = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(parentalControlsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Access'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                state.isPinLocked ? Icons.lock_clock : Icons.lock_outline,
                size: 64,
                color: state.isPinLocked ? AppTheme.errorColor : colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                state.isPinLocked ? 'PIN Entry Locked' : 'Enter Parent PIN',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.isPinLocked
                    ? 'Too many failed attempts.\nTry again in ${state.lockoutRemainingMinutes} minutes.'
                    : 'Enter your 4-digit PIN to access parental controls',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: state.isPinLocked ? AppTheme.errorColor : colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // PIN field
              _PinField(
                controller: _pinController,
                label: 'PIN',
                hint: 'Enter PIN',
                obscure: _obscure,
                onToggleObscure: () {
                  setState(() => _obscure = !_obscure);
                },
                autofocus: !state.isPinLocked,
                onSubmitted: state.isPinLocked ? null : (_) => _verifyPin(),
              ),
              const SizedBox(height: 24),

              // Submit button
              FilledButton(
                onPressed: state.isPinLocked || _isVerifying ? null : _verifyPin,
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue'),
              ),

              if (state.failedPinAttempts > 0 && !state.isPinLocked) ...[
                const SizedBox(height: 16),
                Text(
                  '${state.remainingPinAttempts} attempts remaining before lockout.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.warningColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 24),
              TextButton(
                onPressed: _showForgotPinDialog,
                child: const Text('Forgot PIN?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPin() async {
    final pin = _pinController.text;

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a 4-digit PIN'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    final result = await ref
        .read(parentalControlsProvider.notifier)
        .enterParentMode(pin);

    if (!mounted) return;

    setState(() => _isVerifying = false);

    switch (result) {
      case PinVerificationResult.success:
        // Navigation handled by parent widget watching state
        break;
      case PinVerificationResult.incorrect:
        _pinController.clear();
        // Error message shown via state
        break;
      case PinVerificationResult.lockedOut:
        _pinController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(parentalControlsProvider).error ?? 'Account locked'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        break;
    }
  }

  void _showForgotPinDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a method to reset your parental controls PIN:',
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Send reset email'),
              subtitle: const Text('We\'ll send a PIN reset link to your registered email'),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(dialogContext);
                _sendPinResetEmail();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Reset all settings'),
              subtitle: const Text('Clear PIN and all parental control settings'),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(dialogContext);
                _confirmResetAllSettings();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _sendPinResetEmail() {
    // Get user email from auth state
    final userEmail = ref.read(parentalControlsProvider).userEmail;

    if (userEmail == null || userEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email associated with this account. Please use the reset option.'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    // Show confirmation and send email
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Email Sent'),
        content: Text(
          'A PIN reset link has been sent to $userEmail.\n\n'
          'Please check your inbox and follow the instructions to reset your PIN.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // TODO: Actually send the reset email via Firebase Auth or backend
    // For now, we just show the dialog. In production, integrate with:
    // - Firebase Auth password reset (if PIN is tied to account)
    // - Custom backend endpoint for PIN reset tokens
  }

  void _confirmResetAllSettings() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset All Settings?'),
        content: const Text(
          'This will:\n'
          '• Remove your PIN\n'
          '• Clear all time limits\n'
          '• Remove content filters\n\n'
          'You\'ll need to set up parental controls again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              // Reset all parental control settings
              ref.read(parentalControlsProvider.notifier).resetAllSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Parental controls have been reset'),
                ),
              );
              context.pop(); // Return to previous screen
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

/// Parent Dashboard Screen - Manage settings
class _ParentDashboardScreen extends ConsumerWidget {
  const _ParentDashboardScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(parentalControlsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Controls'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(parentalControlsProvider.notifier).exitParentMode();
            context.pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(parentalControlsProvider.notifier).exitParentMode();
            },
            child: const Text('Lock'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today's usage card
          _UsageSummaryCard(state: state),
          const SizedBox(height: 12),

          // View Full Dashboard button
          OutlinedButton.icon(
            onPressed: () => context.push('/parent-dashboard'),
            icon: const Icon(Icons.dashboard),
            label: const Text('View Full Dashboard'),
          ),
          const SizedBox(height: 24),

          // Screen Time Section
          _buildSectionHeader(context, 'Screen Time'),
          _ScreenTimeLimitTile(state: state),
          _ShowTimerTile(state: state),
          const Divider(height: 32),

          // Content Controls Section
          _buildSectionHeader(context, 'Content Controls'),
          _DifficultyFilterTile(state: state),
          const Divider(height: 32),

          // Account Section
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change PIN'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePinDialog(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.no_accounts, color: colorScheme.error),
            title: Text(
              'Disable Parental Controls',
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => _showDisableDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showChangePinDialog(BuildContext context, WidgetRef ref) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              decoration: const InputDecoration(labelText: 'Current PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              decoration: const InputDecoration(labelText: 'New PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await ref
                  .read(parentalControlsProvider.notifier)
                  .changePin(oldPinController.text, newPinController.text);

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN changed successfully')),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showDisableDialog(BuildContext context, WidgetRef ref) {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Parental Controls?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This will remove all parental control restrictions. '
              'Enter your PIN to confirm.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              decoration: const InputDecoration(labelText: 'PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            onPressed: () async {
              final success = await ref
                  .read(parentalControlsProvider.notifier)
                  .disableParentalControls(pinController.text);

              if (success && context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context); // Also close settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Parental controls disabled')),
                );
              }
            },
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }
}

/// Usage Summary Card
class _UsageSummaryCard extends StatelessWidget {
  final ParentalControlsState state;

  const _UsageSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final usage = state.usage;
    final limit = state.settings.screenTimeLimit;

    final progress = usage.usagePercentage(limit);
    final remaining = state.remainingMinutes;

    Color progressColor;
    if (progress >= 0.9) {
      progressColor = AppTheme.errorColor;
    } else if (progress >= 0.7) {
      progressColor = AppTheme.warningColor;
    } else {
      progressColor = AppTheme.successColor;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "Today's Usage",
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${usage.minutesUsed} min used',
                  style: theme.textTheme.headlineSmall,
                ),
                if (limit.hasLimit)
                  Text(
                    remaining > 0 ? '$remaining min left' : 'Limit reached',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: remaining > 0
                          ? colorScheme.onSurfaceVariant
                          : AppTheme.errorColor,
                      fontWeight:
                          remaining <= 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),
            if (limit.hasLimit) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(progressColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Limit: ${limit.displayName}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (usage.wasExtended) ...[
              const SizedBox(height: 8),
              Chip(
                label: const Text('Time extended today'),
                backgroundColor: AppTheme.warningLight100,
                side: BorderSide.none,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Screen Time Limit Tile
class _ScreenTimeLimitTile extends ConsumerWidget {
  final ParentalControlsState state;

  const _ScreenTimeLimitTile({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.hourglass_top),
      title: const Text('Daily Time Limit'),
      subtitle: Text(state.settings.screenTimeLimit.displayName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLimitPicker(context, ref),
    );
  }

  void _showLimitPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Daily Time Limit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...ScreenTimeLimit.values.map((limit) => RadioListTile<ScreenTimeLimit>(
                  title: Text(limit.displayName),
                  value: limit,
                  groupValue: state.settings.screenTimeLimit,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(parentalControlsProvider.notifier)
                          .updateScreenTimeLimit(value);
                      Navigator.pop(context);
                    }
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Show Timer to Child Tile
class _ShowTimerTile extends ConsumerWidget {
  final ParentalControlsState state;

  const _ShowTimerTile({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      secondary: const Icon(Icons.visibility),
      title: const Text('Show Timer to Child'),
      subtitle: const Text('Display remaining time in the app'),
      value: state.settings.showTimerToChild,
      onChanged: (value) {
        ref
            .read(parentalControlsProvider.notifier)
            .toggleShowTimerToChild(value);
      },
    );
  }
}

/// Difficulty Filter Tile
class _DifficultyFilterTile extends ConsumerWidget {
  final ParentalControlsState state;

  const _DifficultyFilterTile({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.tune),
      title: const Text('Content Difficulty'),
      subtitle: Text(state.settings.difficultyFilter.displayName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showFilterPicker(context, ref),
    );
  }

  void _showFilterPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Content Difficulty Filter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...DifficultyFilter.values.map((filter) => RadioListTile<DifficultyFilter>(
                  title: Text(filter.displayName),
                  subtitle: Text(filter.description),
                  value: filter,
                  groupValue: state.settings.difficultyFilter,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(parentalControlsProvider.notifier)
                          .updateDifficultyFilter(value);
                      Navigator.pop(context);
                    }
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// PIN Input Field Widget
class _PinField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  const _PinField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscure,
    required this.onToggleObscure,
    this.autofocus = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.dialpad),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleObscure,
          tooltip: obscure ? 'Show PIN' : 'Hide PIN',
        ),
        counterText: '',
      ),
      keyboardType: TextInputType.number,
      obscureText: obscure,
      maxLength: 4,
      autofocus: autofocus,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: onSubmitted,
    );
  }
}
