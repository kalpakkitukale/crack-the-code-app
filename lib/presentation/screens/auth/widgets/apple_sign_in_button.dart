/// Apple Sign-In Button Widget
/// Styled button for Apple authentication (iOS/macOS)
library;

import 'package:flutter/material.dart';

/// Apple Sign-In button with Apple branding
class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isJunior;
  final bool isLoading;

  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isJunior = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        elevation: 2,
        padding: EdgeInsets.symmetric(
          vertical: isJunior ? 16 : 14,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isJunior ? 16 : 12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.black : Colors.white,
                ),
              ),
            )
          else
            Icon(
              Icons.apple,
              size: 24,
              color: isDark ? Colors.black : Colors.white,
            ),
          const SizedBox(width: 12),
          Text(
            'Continue with Apple',
            style: TextStyle(
              fontSize: isJunior ? 18 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
