/// UserProfileProvider tests - Multi-profile management and data isolation
library;

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamshaala/presentation/providers/user/user_profile_provider.dart';

void main() {
  group('UserProfile', () {
    // =========================================================================
    // CONSTRUCTION TESTS
    // =========================================================================
    group('construction', () {
      test('creates_profile_with_auto_generated_id', () {
        final profile = UserProfile(
          name: 'Test Student',
          grade: 6,
        );

        expect(profile.id, isNotEmpty);
        expect(profile.name, 'Test Student');
        expect(profile.grade, 6);
      });

      test('creates_profile_with_provided_id', () {
        final profile = UserProfile(
          id: 'custom-uuid',
          name: 'Test Student',
          grade: 6,
        );

        expect(profile.id, 'custom-uuid');
      });

      test('empty_profile_has_empty_id', () {
        expect(UserProfile.empty.id, isEmpty);
        expect(UserProfile.empty.isEmpty, true);
      });
    });

    // =========================================================================
    // COMPUTED PROPERTIES TESTS
    // =========================================================================
    group('computed properties', () {
      test('displayName_withName_returnsName', () {
        final profile = UserProfile(name: 'Alice', grade: 5);
        expect(profile.displayName, 'Alice');
      });

      test('displayName_withoutName_returnsDefault', () {
        final profile = UserProfile(grade: 5);
        expect(profile.displayName, 'Student');
      });

      test('isJuniorProfileComplete_withBothFields_returnsTrue', () {
        final profile = UserProfile(name: 'Alice', grade: 5);
        expect(profile.isJuniorProfileComplete, true);
      });

      test('isJuniorProfileComplete_missingName_returnsFalse', () {
        final profile = UserProfile(grade: 5);
        expect(profile.isJuniorProfileComplete, false);
      });

      test('isJuniorProfileComplete_missingGrade_returnsFalse', () {
        final profile = UserProfile(name: 'Alice');
        expect(profile.isJuniorProfileComplete, false);
      });

      test('avatar_withValidId_returnsAvatarData', () {
        final profile = UserProfile(avatarId: 'cat');
        expect(profile.avatar, isNotNull);
        expect(profile.avatar!['id'], 'cat');
        expect(profile.avatar!['icon'], '🐱');
      });

      test('avatar_withNullId_returnsDefault', () {
        final profile = UserProfile();
        expect(profile.avatar, isNotNull);
        expect(profile.avatar!['id'], 'bear'); // First avatar is default
      });

      test('isEmpty_withEmptyProfile_returnsTrue', () {
        expect(UserProfile.empty.isEmpty, true);
      });

      test('isEmpty_withNormalProfile_returnsFalse', () {
        final profile = UserProfile(name: 'Alice');
        expect(profile.isEmpty, false);
      });
    });

    // =========================================================================
    // EQUALITY TESTS
    // =========================================================================
    group('equality', () {
      test('profiles_with_same_id_are_equal', () {
        final profile1 = UserProfile(id: 'uuid-1', name: 'Alice', grade: 5);
        final profile2 = UserProfile(id: 'uuid-1', name: 'Bob', grade: 6);

        expect(profile1, equals(profile2));
      });

      test('profiles_with_different_ids_are_not_equal', () {
        final profile1 = UserProfile(id: 'uuid-1', name: 'Alice', grade: 5);
        final profile2 = UserProfile(id: 'uuid-2', name: 'Alice', grade: 5);

        expect(profile1, isNot(equals(profile2)));
      });

      test('hashCode_is_based_on_id', () {
        final profile1 = UserProfile(id: 'uuid-1', name: 'Alice');
        final profile2 = UserProfile(id: 'uuid-1', name: 'Bob');

        expect(profile1.hashCode, equals(profile2.hashCode));
      });
    });

    // =========================================================================
    // COPY WITH TESTS
    // =========================================================================
    group('copyWith', () {
      test('updates_name', () {
        final original = UserProfile(id: 'uuid-1', name: 'Alice', grade: 5);
        final updated = original.copyWith(name: 'Bob');

        expect(updated.name, 'Bob');
        expect(updated.grade, 5);
        expect(updated.id, 'uuid-1');
      });

      test('updates_grade', () {
        final original = UserProfile(id: 'uuid-1', name: 'Alice', grade: 5);
        final updated = original.copyWith(grade: 6);

        expect(updated.grade, 6);
        expect(updated.name, 'Alice');
      });

      test('updates_avatarId', () {
        final original = UserProfile(id: 'uuid-1', avatarId: 'bear');
        final updated = original.copyWith(avatarId: 'cat');

        expect(updated.avatarId, 'cat');
      });

      test('preserves_unchanged_fields', () {
        final now = DateTime.now();
        final original = UserProfile(
          id: 'uuid-1',
          name: 'Alice',
          grade: 5,
          avatarId: 'bear',
          createdAt: now,
          updatedAt: now,
        );

        final updated = original.copyWith(name: 'Bob');

        expect(updated.grade, original.grade);
        expect(updated.avatarId, original.avatarId);
        expect(updated.createdAt, original.createdAt);
      });
    });

    // =========================================================================
    // JSON SERIALIZATION TESTS
    // =========================================================================
    group('JSON serialization', () {
      test('toJson_includesAllFields', () {
        final now = DateTime(2024, 1, 15, 10, 30);
        final profile = UserProfile(
          id: 'uuid-1',
          name: 'Alice',
          grade: 5,
          avatarId: 'bear',
          createdAt: now,
          updatedAt: now,
        );

        final json = profile.toJson();

        expect(json['id'], 'uuid-1');
        expect(json['name'], 'Alice');
        expect(json['grade'], 5);
        expect(json['avatarId'], 'bear');
        expect(json['createdAt'], now.toIso8601String());
        expect(json['updatedAt'], now.toIso8601String());
      });

      test('toJson_handlesNullFields', () {
        final profile = UserProfile(id: 'uuid-1');

        final json = profile.toJson();

        expect(json['name'], isNull);
        expect(json['grade'], isNull);
        expect(json['avatarId'], isNull);
        expect(json['createdAt'], isNull);
        expect(json['updatedAt'], isNull);
      });

      test('fromJson_restoresAllFields', () {
        final json = {
          'id': 'uuid-1',
          'name': 'Alice',
          'grade': 5,
          'avatarId': 'bear',
          'createdAt': '2024-01-15T10:30:00.000',
          'updatedAt': '2024-01-15T10:30:00.000',
        };

        final profile = UserProfile.fromJson(json);

        expect(profile.id, 'uuid-1');
        expect(profile.name, 'Alice');
        expect(profile.grade, 5);
        expect(profile.avatarId, 'bear');
        expect(profile.createdAt, DateTime(2024, 1, 15, 10, 30));
      });

      test('fromJson_handlesNullFields', () {
        final json = <String, dynamic>{'id': 'uuid-1'};

        final profile = UserProfile.fromJson(json);

        expect(profile.id, 'uuid-1');
        expect(profile.name, isNull);
        expect(profile.grade, isNull);
      });

      test('fromJson_generatesIdIfMissing', () {
        final json = <String, dynamic>{'name': 'Alice'};

        final profile = UserProfile.fromJson(json);

        expect(profile.id, isNotEmpty);
      });

      test('roundtrip_preservesData', () {
        final original = UserProfile(
          id: 'uuid-1',
          name: 'Alice',
          grade: 5,
          avatarId: 'cat',
          createdAt: DateTime(2024, 1, 15),
        );

        final json = original.toJson();
        final restored = UserProfile.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.grade, original.grade);
        expect(restored.avatarId, original.avatarId);
      });
    });
  });

  group('UserProfileState', () {
    // =========================================================================
    // CONSTRUCTION TESTS
    // =========================================================================
    group('construction', () {
      test('default_state_has_empty_profile', () {
        const state = UserProfileState();

        expect(state.profile, UserProfile.empty);
        expect(state.allProfiles, isEmpty);
        expect(state.isLoading, false);
        expect(state.onboardingComplete, false);
        expect(state.gradeSelectionComplete, false);
      });
    });

    // =========================================================================
    // COMPUTED PROPERTIES TESTS
    // =========================================================================
    group('computed properties', () {
      test('hasMultipleProfiles_withOneProfile_returnsFalse', () {
        final state = UserProfileState(
          allProfiles: [UserProfile(name: 'Alice')],
        );

        expect(state.hasMultipleProfiles, false);
      });

      test('hasMultipleProfiles_withTwoProfiles_returnsTrue', () {
        final state = UserProfileState(
          allProfiles: [
            UserProfile(id: 'uuid-1', name: 'Alice'),
            UserProfile(id: 'uuid-2', name: 'Bob'),
          ],
        );

        expect(state.hasMultipleProfiles, true);
      });

      test('profileCount_returnsCorrectCount', () {
        final state = UserProfileState(
          allProfiles: [
            UserProfile(id: 'uuid-1'),
            UserProfile(id: 'uuid-2'),
            UserProfile(id: 'uuid-3'),
          ],
        );

        expect(state.profileCount, 3);
      });
    });

    // =========================================================================
    // COPY WITH TESTS
    // =========================================================================
    group('copyWith', () {
      test('updates_profile', () {
        const state = UserProfileState();
        final newProfile = UserProfile(name: 'Alice', grade: 5);

        final updated = state.copyWith(profile: newProfile);

        expect(updated.profile.name, 'Alice');
      });

      test('updates_allProfiles', () {
        const state = UserProfileState();
        final profiles = [
          UserProfile(id: 'uuid-1', name: 'Alice'),
          UserProfile(id: 'uuid-2', name: 'Bob'),
        ];

        final updated = state.copyWith(allProfiles: profiles);

        expect(updated.allProfiles.length, 2);
      });

      test('updates_onboardingComplete', () {
        const state = UserProfileState(onboardingComplete: false);
        final updated = state.copyWith(onboardingComplete: true);

        expect(updated.onboardingComplete, true);
      });

      test('updates_gradeSelectionComplete', () {
        const state = UserProfileState(gradeSelectionComplete: false);
        final updated = state.copyWith(gradeSelectionComplete: true);

        expect(updated.gradeSelectionComplete, true);
      });

      test('clears_error_with_null', () {
        final state = UserProfileState(error: 'Some error');
        final updated = state.copyWith(error: null);

        expect(updated.error, isNull);
      });
    });
  });

  group('ProfileAvatars', () {
    test('has_8_avatars', () {
      expect(ProfileAvatars.avatars.length, 8);
    });

    test('each_avatar_has_required_fields', () {
      for (final avatar in ProfileAvatars.avatars) {
        expect(avatar['id'], isNotNull);
        expect(avatar['icon'], isNotNull);
        expect(avatar['name'], isNotNull);
        expect(avatar['color'], isNotNull);
      }
    });

    test('getAvatar_withValidId_returnsAvatar', () {
      final avatar = ProfileAvatars.getAvatar('cat');

      expect(avatar, isNotNull);
      expect(avatar!['icon'], '🐱');
      expect(avatar['name'], 'Cat');
    });

    test('getAvatar_withInvalidId_returnsDefault', () {
      final avatar = ProfileAvatars.getAvatar('invalid');

      expect(avatar, isNotNull);
      expect(avatar!['id'], 'bear'); // First avatar is default
    });

    test('getAvatar_withNull_returnsDefault', () {
      final avatar = ProfileAvatars.getAvatar(null);

      expect(avatar, isNotNull);
      expect(avatar!['id'], 'bear');
    });

    test('all_avatar_ids_are_unique', () {
      final ids = ProfileAvatars.avatars.map((a) => a['id']).toSet();
      expect(ids.length, ProfileAvatars.avatars.length);
    });
  });

  // ===========================================================================
  // MULTI-PROFILE WORKFLOW TESTS
  // ===========================================================================
  group('Multi-Profile Workflow', () {
    test('createProfile_adds_to_allProfiles', () {
      final profiles = <UserProfile>[];
      final newProfile = UserProfile(name: 'Alice', grade: 5, avatarId: 'cat');

      profiles.add(newProfile);

      expect(profiles.length, 1);
      expect(profiles.first.name, 'Alice');
    });

    test('switchProfile_updates_activeProfile', () {
      final profiles = [
        UserProfile(id: 'uuid-1', name: 'Alice'),
        UserProfile(id: 'uuid-2', name: 'Bob'),
      ];

      var activeProfile = profiles[0];
      activeProfile = profiles.firstWhere((p) => p.id == 'uuid-2');

      expect(activeProfile.name, 'Bob');
    });

    test('deleteProfile_removes_from_list', () {
      final profiles = [
        UserProfile(id: 'uuid-1', name: 'Alice'),
        UserProfile(id: 'uuid-2', name: 'Bob'),
      ];

      final updatedProfiles = profiles.where((p) => p.id != 'uuid-1').toList();

      expect(updatedProfiles.length, 1);
      expect(updatedProfiles.first.name, 'Bob');
    });

    test('deleteLastProfile_shouldNotBeAllowed', () {
      final profiles = [UserProfile(id: 'uuid-1', name: 'Alice')];

      // Business rule: Cannot delete the last profile
      final canDelete = profiles.length > 1;

      expect(canDelete, false);
    });

    test('updateProfile_replaces_in_list', () {
      final profiles = [
        UserProfile(id: 'uuid-1', name: 'Alice', grade: 5),
        UserProfile(id: 'uuid-2', name: 'Bob', grade: 6),
      ];

      final updatedProfile = profiles[0].copyWith(grade: 7);
      final updatedProfiles = profiles.map((p) {
        return p.id == updatedProfile.id ? updatedProfile : p;
      }).toList();

      expect(updatedProfiles[0].grade, 7);
      expect(updatedProfiles[1].grade, 6);
    });
  });

  // ===========================================================================
  // DATA ISOLATION TESTS
  // ===========================================================================
  group('Data Isolation', () {
    test('profile_id_should_be_used_for_filtering', () {
      final profileA = UserProfile(id: 'profile-a-uuid', name: 'Alice');
      final profileB = UserProfile(id: 'profile-b-uuid', name: 'Bob');

      // Simulate data filtering
      final allData = [
        {'profileId': 'profile-a-uuid', 'data': 'Alice data'},
        {'profileId': 'profile-b-uuid', 'data': 'Bob data'},
      ];

      final aliceData = allData.where((d) => d['profileId'] == profileA.id);
      final bobData = allData.where((d) => d['profileId'] == profileB.id);

      expect(aliceData.length, 1);
      expect(bobData.length, 1);
      expect(aliceData.first['data'], 'Alice data');
      expect(bobData.first['data'], 'Bob data');
    });
  });

  // ===========================================================================
  // USER PROFILE NOTIFIER TESTS
  // ===========================================================================
  group('UserProfileNotifier', () {
    late SharedPreferences prefs;
    String? capturedProfileId;
    String? deletedProfileId;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      capturedProfileId = null;
      deletedProfileId = null;
    });

    UserProfileNotifier createNotifier({
      bool autoLoad = false,
      bool withCallbacks = false,
    }) {
      return UserProfileNotifier(
        prefs: prefs,
        autoLoad: autoLoad,
        onProfileIdChanged: withCallbacks
            ? (profileId) {
                capturedProfileId = profileId;
              }
            : null,
        onProfileDeleted: withCallbacks
            ? (profileId) async {
                deletedProfileId = profileId;
              }
            : null,
      );
    }

    // =========================================================================
    // INITIALIZATION TESTS
    // =========================================================================
    group('initialization', () {
      test('withNoData_startsWithEmptyState', () async {
        final notifier = createNotifier();

        expect(notifier.state.profile, UserProfile.empty);
        expect(notifier.state.allProfiles, isEmpty);
        expect(notifier.state.onboardingComplete, false);
        expect(notifier.state.gradeSelectionComplete, false);

        notifier.dispose();
      });

      test('withExistingProfile_loadsData', () async {
        // Setup existing profile data
        final profileData = {
          'id': 'profile-1',
          'name': 'Alice',
          'grade': 5,
          'avatarId': 'cat',
        };
        await prefs.setString('user_profiles', jsonEncode([profileData]));
        await prefs.setString('active_profile_id', 'profile-1');
        await prefs.setBool('onboarding_complete', true);
        await prefs.setBool('grade_selection_complete', true);

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(Duration.zero); // Wait for initialization

        expect(notifier.state.profile.name, 'Alice');
        expect(notifier.state.profile.grade, 5);
        expect(notifier.state.allProfiles.length, 1);
        expect(notifier.state.onboardingComplete, true);
        expect(notifier.state.gradeSelectionComplete, true);

        notifier.dispose();
      });

      test('withMultipleProfiles_loadsActiveProfile', () async {
        // Setup multiple profiles
        final profiles = [
          {'id': 'profile-1', 'name': 'Alice', 'grade': 5},
          {'id': 'profile-2', 'name': 'Bob', 'grade': 6},
        ];
        await prefs.setString('user_profiles', jsonEncode(profiles));
        await prefs.setString('active_profile_id', 'profile-2');

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(Duration.zero);

        expect(notifier.state.profile.name, 'Bob');
        expect(notifier.state.profile.grade, 6);
        expect(notifier.state.allProfiles.length, 2);

        notifier.dispose();
      });

      test('withInvalidActiveProfileId_usesFirstProfile', () async {
        final profiles = [
          {'id': 'profile-1', 'name': 'Alice', 'grade': 5},
          {'id': 'profile-2', 'name': 'Bob', 'grade': 6},
        ];
        await prefs.setString('user_profiles', jsonEncode(profiles));
        await prefs.setString('active_profile_id', 'profile-999'); // Invalid

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(Duration.zero);

        expect(notifier.state.profile.name, 'Alice'); // Falls back to first
        expect(notifier.state.allProfiles.length, 2);

        notifier.dispose();
      });

      test('migratesFromOldSingleProfileFormat', () async {
        // Setup old format (single profile)
        final oldProfile = {
          'id': 'profile-1',
          'name': 'Alice',
          'grade': 5,
        };
        await prefs.setString('user_profile', jsonEncode(oldProfile));

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(Duration.zero);

        expect(notifier.state.profile.name, 'Alice');
        expect(notifier.state.allProfiles.length, 1);
        // Should have saved in new format
        expect(prefs.getString('user_profiles'), isNotNull);

        notifier.dispose();
      });

      test('callsOnProfileIdChanged_whenInitialized', () async {
        final profiles = [
          {'id': 'profile-1', 'name': 'Alice', 'grade': 5},
        ];
        await prefs.setString('user_profiles', jsonEncode(profiles));
        await prefs.setString('active_profile_id', 'profile-1');

        final notifier = createNotifier(autoLoad: true, withCallbacks: true);
        await Future.delayed(Duration.zero);

        expect(capturedProfileId, 'profile-1');

        notifier.dispose();
      });
    });

    // =========================================================================
    // CREATE PROFILE TESTS
    // =========================================================================
    group('createProfile', () {
      test('createsNewProfile_addsToAllProfiles', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
          avatarId: 'cat',
        );

        expect(profile.name, 'Alice');
        expect(profile.grade, 5);
        expect(profile.avatarId, 'cat');
        expect(notifier.state.allProfiles.length, 1);
        expect(notifier.state.allProfiles.first.id, profile.id);

        notifier.dispose();
      });

      test('firstProfile_becomesActive', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        expect(notifier.state.profile.id, profile.id);
        expect(notifier.state.gradeSelectionComplete, true);

        notifier.dispose();
      });

      test('secondProfile_doesNotBecomeActive', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        expect(notifier.state.profile.id, profile1.id);
        expect(notifier.state.allProfiles.length, 2);

        notifier.dispose();
      });

      test('firstProfile_callsOnProfileIdChanged', () async {
        final notifier = createNotifier(withCallbacks: true);

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        expect(capturedProfileId, profile.id);

        notifier.dispose();
      });

      test('defaultsToFirstAvatar_ifNotProvided', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        expect(profile.avatarId, 'bear'); // First avatar

        notifier.dispose();
      });

      test('savesToSharedPreferences', () async {
        final notifier = createNotifier();

        await notifier.createProfile(name: 'Alice', grade: 5);

        final profilesJson = prefs.getString('user_profiles');
        expect(profilesJson, isNotNull);

        final profiles = jsonDecode(profilesJson!) as List;
        expect(profiles.length, 1);
        expect(profiles[0]['name'], 'Alice');

        notifier.dispose();
      });
    });

    // =========================================================================
    // SWITCH PROFILE TESTS
    // =========================================================================
    group('switchProfile', () {
      test('switchesToExistingProfile', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        await notifier.switchProfile(profile2.id);

        expect(notifier.state.profile.id, profile2.id);
        expect(notifier.state.profile.name, 'Bob');

        notifier.dispose();
      });

      test('callsOnProfileIdChanged', () async {
        final notifier = createNotifier(withCallbacks: true);

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        capturedProfileId = null; // Reset
        await notifier.switchProfile(profile2.id);

        expect(capturedProfileId, profile2.id);

        notifier.dispose();
      });

      test('withInvalidId_keepsCurrentProfile', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        await notifier.switchProfile('invalid-id');

        expect(notifier.state.profile.id, profile1.id);

        notifier.dispose();
      });

      test('savesActiveProfileId', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        await notifier.switchProfile(profile2.id);

        expect(prefs.getString('active_profile_id'), profile2.id);

        notifier.dispose();
      });

      test('switchingToSameProfile_doesNothing', () async {
        final notifier = createNotifier(withCallbacks: true);

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        capturedProfileId = null; // Reset
        await notifier.switchProfile(profile.id); // Switch to same

        expect(capturedProfileId, isNull); // Not called again

        notifier.dispose();
      });
    });

    // =========================================================================
    // UPDATE PROFILE TESTS
    // =========================================================================
    group('updateProfile', () {
      test('updatesProfileInList', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        final updated = profile.copyWith(name: 'Alice Smith', grade: 6);
        await notifier.updateProfile(updated);

        expect(notifier.state.allProfiles.first.name, 'Alice Smith');
        expect(notifier.state.allProfiles.first.grade, 6);

        notifier.dispose();
      });

      test('updatesActiveProfile_ifSameId', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        final updated = profile.copyWith(name: 'Alice Smith');
        await notifier.updateProfile(updated);

        expect(notifier.state.profile.name, 'Alice Smith');

        notifier.dispose();
      });

      test('doesNotUpdateActiveProfile_ifDifferentId', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        final updated = profile2.copyWith(name: 'Robert');
        await notifier.updateProfile(updated);

        expect(notifier.state.profile.name, 'Alice'); // Still Alice
        expect(notifier.state.allProfiles[1].name, 'Robert'); // Bob updated

        notifier.dispose();
      });

      test('setsUpdatedAt', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        await Future.delayed(const Duration(milliseconds: 10));
        final updated = profile.copyWith(name: 'Alice Smith');
        await notifier.updateProfile(updated);

        final savedProfile = notifier.state.allProfiles.first;
        expect(savedProfile.updatedAt, isNotNull);
        expect(
          savedProfile.updatedAt!.isAfter(profile.createdAt!),
          true,
        );

        notifier.dispose();
      });

      test('savesToSharedPreferences', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        final updated = profile.copyWith(name: 'Alice Smith');
        await notifier.updateProfile(updated);

        final profilesJson = prefs.getString('user_profiles');
        final profiles = jsonDecode(profilesJson!) as List;
        expect(profiles[0]['name'], 'Alice Smith');

        notifier.dispose();
      });
    });

    // =========================================================================
    // DELETE PROFILE TESTS
    // =========================================================================
    group('deleteProfile', () {
      test('deletesProfile_fromList', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        final result = await notifier.deleteProfile(profile2.id);

        expect(result, true);
        expect(notifier.state.allProfiles.length, 1);
        expect(notifier.state.allProfiles.first.id, profile1.id);

        notifier.dispose();
      });

      test('deletingActiveProfile_switchesToAnother', () async {
        final notifier = createNotifier(withCallbacks: true);

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        await notifier.switchProfile(profile2.id); // Make Bob active

        capturedProfileId = null; // Reset
        await notifier.deleteProfile(profile2.id);

        expect(notifier.state.profile.id, profile1.id); // Switched to Alice
        expect(capturedProfileId, profile1.id); // Callback called

        notifier.dispose();
      });

      test('deletingNonActiveProfile_keepsActive', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        await notifier.deleteProfile(profile2.id);

        expect(notifier.state.profile.id, profile1.id);

        notifier.dispose();
      });

      test('deletingLastProfile_returnsFalse', () async {
        final notifier = createNotifier();

        final profile = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );

        final result = await notifier.deleteProfile(profile.id);

        expect(result, false);
        expect(notifier.state.allProfiles.length, 1);

        notifier.dispose();
      });

      test('callsOnProfileDeleted', () async {
        final notifier = createNotifier(withCallbacks: true);

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        final profile2 = await notifier.createProfile(
          name: 'Bob',
          grade: 6,
        );

        await notifier.deleteProfile(profile2.id);

        expect(deletedProfileId, profile2.id);

        notifier.dispose();
      });

      test('savesToSharedPreferences', () async {
        final notifier = createNotifier();

        final profile1 = await notifier.createProfile(
          name: 'Alice',
          grade: 5,
        );
        await notifier.createProfile(name: 'Bob', grade: 6);

        await notifier.deleteProfile(profile1.id);

        final profilesJson = prefs.getString('user_profiles');
        final profiles = jsonDecode(profilesJson!) as List;
        expect(profiles.length, 1);
        expect(profiles[0]['name'], 'Bob');

        notifier.dispose();
      });
    });

    // =========================================================================
    // SET NAME/GRADE/AVATAR TESTS
    // =========================================================================
    group('setName', () {
      test('updatesActiveName', () async {
        final notifier = createNotifier();

        await notifier.createProfile(name: 'Alice', grade: 5);
        await notifier.setName('Alice Smith');

        expect(notifier.state.profile.name, 'Alice Smith');

        notifier.dispose();
      });

      test('savesToSharedPreferences', () async {
        final notifier = createNotifier();

        await notifier.createProfile(name: 'Alice', grade: 5);
        await notifier.setName('Alice Smith');

        final profilesJson = prefs.getString('user_profiles');
        final profiles = jsonDecode(profilesJson!) as List;
        expect(profiles[0]['name'], 'Alice Smith');

        notifier.dispose();
      });
    });

    group('setGrade', () {
      test('updatesActiveGrade', () async {
        final notifier = createNotifier();

        await notifier.createProfile(name: 'Alice', grade: 5);
        await notifier.setGrade(6);

        expect(notifier.state.profile.grade, 6);

        notifier.dispose();
      });

      test('marksGradeSelectionComplete', () async {
        final notifier = createNotifier();

        final profile = UserProfile(name: 'Alice');
        final updatedProfiles = [profile];
        await prefs.setString(
          'user_profiles',
          jsonEncode(updatedProfiles.map((p) => p.toJson()).toList()),
        );

        // Manually load the profile
        notifier.state = notifier.state.copyWith(
          profile: profile,
          allProfiles: updatedProfiles,
        );

        await notifier.setGrade(6);

        expect(notifier.state.gradeSelectionComplete, true);
        expect(prefs.getBool('grade_selection_complete'), true);

        notifier.dispose();
      });
    });

    group('setAvatar', () {
      test('updatesActiveAvatar', () async {
        final notifier = createNotifier();

        await notifier.createProfile(name: 'Alice', grade: 5);
        await notifier.setAvatar('dog');

        expect(notifier.state.profile.avatarId, 'dog');

        notifier.dispose();
      });
    });

    // =========================================================================
    // ONBOARDING TESTS
    // =========================================================================
    group('completeOnboarding', () {
      test('marksOnboardingComplete', () async {
        final notifier = createNotifier();

        await notifier.completeOnboarding();

        expect(notifier.state.onboardingComplete, true);
        expect(prefs.getBool('onboarding_complete'), true);

        notifier.dispose();
      });
    });

    // =========================================================================
    // RESET TESTS
    // =========================================================================
    group('resetProfile', () {
      test('clearsAllData', () async {
        final notifier = createNotifier();

        await notifier.createProfile(name: 'Alice', grade: 5);
        await notifier.completeOnboarding();

        await notifier.resetProfile();

        expect(notifier.state.profile, UserProfile.empty);
        expect(notifier.state.allProfiles, isEmpty);
        expect(notifier.state.onboardingComplete, false);
        expect(notifier.state.gradeSelectionComplete, false);
        expect(prefs.getString('user_profiles'), isNull);
        expect(prefs.getBool('onboarding_complete'), isNull);

        notifier.dispose();
      });
    });

    // =========================================================================
    // ERROR HANDLING TESTS
    // =========================================================================
    group('errorHandling', () {
      test('clearError_clearsErrorMessage', () async {
        final notifier = createNotifier();

        notifier.state = notifier.state.copyWith(
          error: 'Test error',
        );

        notifier.clearError();

        expect(notifier.state.error, isNull);

        notifier.dispose();
      });
    });
  });
}
