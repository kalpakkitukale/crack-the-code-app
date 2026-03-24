import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Privacy Policy Screen
/// Displays the app's privacy policy
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last updated
            Text(
              'Last updated: December 2024',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Introduction
            _buildSection(
              context,
              title: 'Introduction',
              content:
                  'Crack the Code ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.',
            ),

            // Information We Collect
            _buildSection(
              context,
              title: 'Information We Collect',
              content:
                  'Crack the Code is designed with privacy in mind. We collect minimal information necessary to provide you with a great learning experience:\n\n'
                  '• Local Progress Data: Your video watch history, quiz attempts, and progress are stored locally on your device only.\n'
                  '• App Usage: We may collect anonymous usage statistics to improve the app (e.g., crash reports, feature usage).\n'
                  '• No Personal Information: We do not collect, store, or transmit personal information such as your name, email, or contact details.',
            ),

            // How We Use Your Information
            _buildSection(
              context,
              title: 'How We Use Your Information',
              content:
                  'The information we collect is used to:\n\n'
                  '• Provide and maintain the app functionality\n'
                  '• Track your learning progress locally on your device\n'
                  '• Improve app performance and user experience\n'
                  '• Identify and fix bugs or crashes\n\n'
                  'Your learning data (watch history, quiz scores, progress) never leaves your device and is not shared with anyone.',
            ),

            // Data Storage
            _buildSection(
              context,
              title: 'Data Storage',
              content:
                  'All your learning data is stored locally on your device using secure SQLite databases. We do not use cloud storage or external servers for your personal learning data. This means:\n\n'
                  '• Your data stays on your device\n'
                  '• No third-party servers have access to your learning history\n'
                  '• You have full control over your data\n'
                  '• If you uninstall the app, all local data is removed',
            ),

            // Third-Party Services
            _buildSection(
              context,
              title: 'Third-Party Services',
              content:
                  'Crack the Code uses YouTube\'s API Services to display educational videos. When you watch videos through our app:\n\n'
                  '• You are subject to YouTube\'s Terms of Service and Privacy Policy\n'
                  '• Video playback may send data to YouTube/Google\n'
                  '• We do not control or have access to data collected by YouTube\n\n'
                  'We may also use anonymous analytics services (like Firebase Analytics) to understand how users interact with the app, but this data is aggregated and does not identify individual users.',
            ),

            // Your Rights
            _buildSection(
              context,
              title: 'Your Rights',
              content:
                  'You have the right to:\n\n'
                  '• Access your data: All data is stored locally and accessible through the app\n'
                  '• Delete your data: Uninstalling the app removes all local data\n'
                  '• Opt-out: You can disable analytics in app settings (if available)',
            ),

            // Children\'s Privacy
            _buildSection(
              context,
              title: 'Children\'s Privacy',
              content:
                  'Crack the Code is designed for students of all ages. We do not knowingly collect personal information from children. All data is stored locally on the device, and no personal information is transmitted to our servers.',
            ),

            // Changes to This Policy
            _buildSection(
              context,
              title: 'Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by updating the "Last updated" date at the top of this policy.',
            ),

            // Contact Us
            _buildSection(
              context,
              title: 'Contact Us',
              content:
                  'If you have any questions about this Privacy Policy, please contact us at:\n\n'
                  'Email: support@crackthecode.app',
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // YouTube Terms Link
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'YouTube Terms of Service',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By using this app, you agree to YouTube\'s Terms of Service.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // TODO: Open YouTube Terms of Service in browser
                      // launch('https://www.youtube.com/t/terms');
                    },
                    child: const Text('View YouTube Terms'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
