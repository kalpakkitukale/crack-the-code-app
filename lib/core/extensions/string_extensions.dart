/// Extension methods for String to add utility functions
extension StringExtensions on String {
  /// Capitalize first letter of string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is a valid email
  /// Uses a permissive regex that allows most valid email formats:
  /// - Allows dots, plus signs, underscores, hyphens in local part
  /// - Allows subdomains in domain part
  /// - Supports TLDs of any length (2+ characters)
  /// - Allows numeric-only domain parts (except TLD)
  bool get isValidEmail {
    // Basic sanity checks first
    if (length < 5 || length > 254) return false; // Min: a@b.cc, Max: RFC 5321
    if (!contains('@')) return false;

    // More permissive regex that handles most valid emails
    // Allows: letters, numbers, dots, plus, hyphen, underscore in local part
    // Domain: letters, numbers, dots, hyphens
    // TLD: 2+ letters
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Truncate string to specified length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Remove all whitespace from string
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is null or empty
  bool get isNullOrEmpty => trim().isEmpty;

  /// Parse string to int safely
  int? get toIntOrNull => int.tryParse(this);

  /// Parse string to double safely
  double? get toDoubleOrNull => double.tryParse(this);

  /// Convert string to slug format (lowercase with hyphens)
  String get toSlug =>
      toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').trim();

  /// Remove HTML tags from string
  String get removeHtmlTags => replaceAll(RegExp(r'<[^>]*>'), '');

  /// Count words in string
  int get wordCount => trim().split(RegExp(r'\s+')).length;

  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Reverse string
  String get reverse => split('').reversed.join('');
}

/// Extension for nullable String
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this?.trim().isEmpty ?? true;

  /// Get value or default
  String orDefault(String defaultValue) => this ?? defaultValue;

  /// Safely get first character
  String? get firstChar => this?.isNotEmpty == true ? this![0] : null;
}
