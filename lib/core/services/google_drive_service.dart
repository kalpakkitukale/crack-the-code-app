/// Google Drive Service
/// Manages user data sync using Google Drive appDataFolder
library;

import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:crack_the_code/core/utils/logger.dart';

/// Service for syncing user data to Google Drive
///
/// Uses the appDataFolder space which is:
/// - Hidden from the user (not visible in their Drive)
/// - Only accessible by this app
/// - Automatically deleted when the app is uninstalled
/// - Does NOT count against user's Drive quota
class GoogleDriveService {
  drive.DriveApi? _driveApi;
  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  GoogleDriveService({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: [
                'email',
                'profile',
                drive.DriveApi.driveAppdataScope,
              ],
            );

  /// Whether the service is initialized and ready
  bool get isInitialized => _isInitialized;

  /// Whether the user is signed in with Drive access
  bool get isSignedIn => _googleSignIn.currentUser != null;

  /// Initialize the Drive API with the current user's credentials
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    final currentUser = _googleSignIn.currentUser;
    if (currentUser == null) {
      logger.warning('Cannot initialize Drive service: No user signed in');
      return false;
    }

    try {
      final auth = await currentUser.authentication;
      if (auth.accessToken == null) {
        logger.error('Cannot initialize Drive service: No access token');
        return false;
      }

      // Create authenticated HTTP client
      final authClient = _GoogleAuthClient(auth.accessToken!);
      _driveApi = drive.DriveApi(authClient);

      _isInitialized = true;
      logger.info('Google Drive service initialized');
      return true;
    } catch (e) {
      logger.error('Failed to initialize Google Drive service: $e');
      return false;
    }
  }

  /// Sign in and initialize Drive access
  Future<bool> signInAndInitialize() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user == null) {
        logger.info('Drive sign-in cancelled');
        return false;
      }

      return await initialize();
    } catch (e) {
      logger.error('Drive sign-in failed: $e');
      return false;
    }
  }

  /// Write JSON data to a file in appDataFolder
  ///
  /// [fileName] - Name of the file (e.g., "progress.json")
  /// [data] - JSON-serializable data to write
  ///
  /// Returns the file ID on success, null on failure
  Future<String?> writeFile(String fileName, Map<String, dynamic> data) async {
    final api = _driveApi;
    if (!_isInitialized || api == null) {
      logger.error('Drive service not initialized');
      return null;
    }

    try {
      final content = utf8.encode(json.encode(data));

      // Check if file already exists
      final existingFileId = await _findFileByName(fileName);

      if (existingFileId != null) {
        // Update existing file
        final media = drive.Media(
          Stream.value(content),
          content.length,
        );

        final result = await api.files.update(
          drive.File(),
          existingFileId,
          uploadMedia: media,
        );

        logger.debug('Updated Drive file: $fileName');
        return result.id;
      } else {
        // Create new file
        final file = drive.File()
          ..name = fileName
          ..parents = ['appDataFolder'];

        final media = drive.Media(
          Stream.value(content),
          content.length,
        );

        final result = await api.files.create(
          file,
          uploadMedia: media,
        );

        logger.debug('Created Drive file: $fileName');
        return result.id;
      }
    } catch (e) {
      logger.error('Failed to write Drive file $fileName: $e');
      return null;
    }
  }

  /// Read JSON data from a file in appDataFolder
  ///
  /// [fileName] - Name of the file to read
  ///
  /// Returns the parsed JSON data, or null if file doesn't exist or read fails
  Future<Map<String, dynamic>?> readFile(String fileName) async {
    final api = _driveApi;
    if (!_isInitialized || api == null) {
      logger.error('Drive service not initialized');
      return null;
    }

    try {
      final fileId = await _findFileByName(fileName);
      if (fileId == null) {
        logger.debug('Drive file not found: $fileName');
        return null;
      }

      final response = await api.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      );

      if (response is! drive.Media) {
        logger.error('Unexpected response type for Drive file: $fileName');
        return null;
      }

      final bytes = await _collectBytes(response.stream);
      final jsonString = utf8.decode(bytes);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      logger.debug('Read Drive file: $fileName');
      return data;
    } catch (e) {
      logger.error('Failed to read Drive file $fileName: $e');
      return null;
    }
  }

  /// Delete a file from appDataFolder
  ///
  /// [fileName] - Name of the file to delete
  ///
  /// Returns true if deleted successfully, false otherwise
  Future<bool> deleteFile(String fileName) async {
    final api = _driveApi;
    if (!_isInitialized || api == null) {
      logger.error('Drive service not initialized');
      return false;
    }

    try {
      final fileId = await _findFileByName(fileName);
      if (fileId == null) {
        logger.debug('Drive file not found for deletion: $fileName');
        return true; // File doesn't exist, consider success
      }

      await api.files.delete(fileId);
      logger.debug('Deleted Drive file: $fileName');
      return true;
    } catch (e) {
      logger.error('Failed to delete Drive file $fileName: $e');
      return false;
    }
  }

  /// List all files in appDataFolder
  ///
  /// Returns a map of fileName -> fileId
  Future<Map<String, String>> listFiles() async {
    final api = _driveApi;
    if (!_isInitialized || api == null) {
      logger.error('Drive service not initialized');
      return {};
    }

    try {
      final fileMap = <String, String>{};

      String? pageToken;
      do {
        final response = await api.files.list(
          spaces: 'appDataFolder',
          pageToken: pageToken,
          $fields: 'nextPageToken, files(id, name)',
        );

        for (final file in response.files ?? []) {
          final fileId = file.id;
          final fileName = file.name;
          if (fileId != null && fileName != null) {
            fileMap[fileName] = fileId;
          }
        }

        pageToken = response.nextPageToken;
      } while (pageToken != null);

      logger.debug('Listed ${fileMap.length} Drive files');
      return fileMap;
    } catch (e) {
      logger.error('Failed to list Drive files: $e');
      return {};
    }
  }

  /// Get file metadata (including modified time)
  Future<drive.File?> getFileMetadata(String fileName) async {
    final api = _driveApi;
    if (!_isInitialized || api == null) {
      return null;
    }

    try {
      final fileId = await _findFileByName(fileName);
      if (fileId == null) return null;

      final file = await api.files.get(
        fileId,
        $fields: 'id, name, modifiedTime, size',
      );

      return file as drive.File?;
    } catch (e) {
      logger.error('Failed to get Drive file metadata $fileName: $e');
      return null;
    }
  }

  /// Clear the Drive API (for sign out)
  void clear() {
    _driveApi = null;
    _isInitialized = false;
    logger.info('Google Drive service cleared');
  }

  /// Find a file by name in appDataFolder
  Future<String?> _findFileByName(String fileName) async {
    final api = _driveApi;
    if (api == null) return null;

    try {
      final response = await api.files.list(
        spaces: 'appDataFolder',
        q: "name = '$fileName'",
        $fields: 'files(id)',
      );

      final files = response.files;
      if (files == null || files.isEmpty) {
        return null;
      }

      return files.first.id;
    } catch (e) {
      logger.error('Failed to find Drive file $fileName: $e');
      return null;
    }
  }

  /// Collect bytes from a stream
  Future<List<int>> _collectBytes(Stream<List<int>> stream) async {
    final chunks = <List<int>>[];
    await for (final chunk in stream) {
      chunks.add(chunk);
    }

    final totalLength = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final bytes = List<int>.filled(totalLength, 0);
    var offset = 0;
    for (final chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    return bytes;
  }
}

/// Simple HTTP client that adds Authorization header
class _GoogleAuthClient extends http.BaseClient {
  final String _accessToken;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}
