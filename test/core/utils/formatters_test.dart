import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    group('formatDuration', () {
      test('formats negative seconds as 00:00', () {
        expect(Formatters.formatDuration(-10), '00:00');
      });

      test('formats zero seconds correctly', () {
        expect(Formatters.formatDuration(0), '00:00');
      });

      test('formats seconds only (less than 1 minute)', () {
        expect(Formatters.formatDuration(45), '00:45');
      });

      test('formats minutes and seconds (less than 1 hour)', () {
        expect(Formatters.formatDuration(125), '02:05');
        expect(Formatters.formatDuration(600), '10:00');
      });

      test('formats hours, minutes, and seconds', () {
        expect(Formatters.formatDuration(3665), '01:01:05');
        expect(Formatters.formatDuration(7200), '02:00:00');
      });

      test('pads single digits with zero', () {
        expect(Formatters.formatDuration(5), '00:05');
        expect(Formatters.formatDuration(65), '01:05');
      });
    });

    group('formatDurationHuman', () {
      test('formats seconds only', () {
        expect(
          Formatters.formatDurationHuman(const Duration(seconds: 45)),
          '45s',
        );
      });

      test('formats minutes and seconds', () {
        expect(
          Formatters.formatDurationHuman(const Duration(minutes: 5, seconds: 30)),
          '5m 30s',
        );
      });

      test('formats hours and minutes (drops seconds)', () {
        expect(
          Formatters.formatDurationHuman(const Duration(hours: 2, minutes: 15, seconds: 30)),
          '2h 15m',
        );
      });

      test('handles zero duration', () {
        expect(
          Formatters.formatDurationHuman(Duration.zero),
          '0s',
        );
      });
    });

    group('formatCompactNumber', () {
      test('formats numbers less than 1000 as-is', () {
        expect(Formatters.formatCompactNumber(0), '0');
        expect(Formatters.formatCompactNumber(500), '500');
        expect(Formatters.formatCompactNumber(999), '999');
      });

      test('formats thousands with K suffix', () {
        expect(Formatters.formatCompactNumber(1000), '1K');
        expect(Formatters.formatCompactNumber(1500), '1.5K');
        expect(Formatters.formatCompactNumber(15000), '15K');
        expect(Formatters.formatCompactNumber(999999), '1000.0K');
      });

      test('formats millions with M suffix', () {
        expect(Formatters.formatCompactNumber(1000000), '1M');
        expect(Formatters.formatCompactNumber(1500000), '1.5M');
        expect(Formatters.formatCompactNumber(25000000), '25M');
      });

      test('formats billions with B suffix', () {
        expect(Formatters.formatCompactNumber(1000000000), '1B');
        expect(Formatters.formatCompactNumber(1500000000), '1.5B');
      });
    });

    group('formatPercentage', () {
      test('formats with no decimals by default', () {
        expect(Formatters.formatPercentage(85.7), '86%');
        expect(Formatters.formatPercentage(100.0), '100%');
      });

      test('formats with specified decimals', () {
        expect(Formatters.formatPercentage(85.7, decimals: 1), '85.7%');
        expect(Formatters.formatPercentage(85.75, decimals: 2), '85.75%');
      });

      test('handles zero percentage', () {
        expect(Formatters.formatPercentage(0.0), '0%');
      });
    });

    group('formatFileSize', () {
      test('formats bytes', () {
        expect(Formatters.formatFileSize(500), '500 B');
      });

      test('formats kilobytes', () {
        expect(Formatters.formatFileSize(1024), '1.0 KB');
        expect(Formatters.formatFileSize(2560), '2.5 KB');
      });

      test('formats megabytes', () {
        expect(Formatters.formatFileSize(1024 * 1024), '1.0 MB');
        expect(Formatters.formatFileSize(5 * 1024 * 1024), '5.0 MB');
      });

      test('formats gigabytes', () {
        expect(Formatters.formatFileSize(1024 * 1024 * 1024), '1.0 GB');
        expect(Formatters.formatFileSize(3 * 1024 * 1024 * 1024), '3.0 GB');
      });
    });

    group('formatPhoneNumber', () {
      test('formats 10-digit Indian phone number', () {
        expect(Formatters.formatPhoneNumber('9876543210'), '98765 43210');
      });

      test('returns phone as-is if not 10 digits', () {
        expect(Formatters.formatPhoneNumber('123456789'), '123456789');
        expect(Formatters.formatPhoneNumber('12345678901'), '12345678901');
      });
    });

    group('formatStudyTime', () {
      test('formats minutes only (less than 1 hour)', () {
        expect(Formatters.formatStudyTime(30), '30 min');
        expect(Formatters.formatStudyTime(59), '59 min');
      });

      test('formats hours only (exact hours)', () {
        expect(Formatters.formatStudyTime(60), '1 hr');
        expect(Formatters.formatStudyTime(120), '2 hr');
      });

      test('formats hours and minutes', () {
        expect(Formatters.formatStudyTime(90), '1 hr 30 min');
        expect(Formatters.formatStudyTime(145), '2 hr 25 min');
      });

      test('handles zero minutes', () {
        expect(Formatters.formatStudyTime(0), '0 min');
      });
    });

    group('formatProgress', () {
      test('formats progress as percentage', () {
        expect(Formatters.formatProgress(0.85), '85%');
        expect(Formatters.formatProgress(1.0), '100%');
        expect(Formatters.formatProgress(0.0), '0%');
      });

      test('rounds to nearest integer', () {
        expect(Formatters.formatProgress(0.857), '85%');
        expect(Formatters.formatProgress(0.855), '85%');
      });
    });

    group('getYoutubeThumbnail', () {
      test('generates thumbnail URL with default quality', () {
        expect(
          Formatters.getYoutubeThumbnail('dQw4w9WgXcQ'),
          'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
        );
      });

      test('generates thumbnail URL with specified quality', () {
        expect(
          Formatters.getYoutubeThumbnail('dQw4w9WgXcQ', quality: 'maxresdefault'),
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        );
      });
    });

    group('getYoutubeWatchUrl', () {
      test('generates correct YouTube watch URL', () {
        expect(
          Formatters.getYoutubeWatchUrl('dQw4w9WgXcQ'),
          'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        );
      });
    });
  });
}
