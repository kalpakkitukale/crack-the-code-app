import 'dart:io';
import 'dart:convert';

/// Script to fix conceptTags in kinematics quiz
/// Maps display names to proper concept IDs from concepts.json
void main() async {
  print('🔧 Fixing Kinematics Quiz Concept Tags');
  print('=' * 60);

  // Mapping from display names to concept IDs
  final Map<String, String> conceptMapping = {
    // Direct mappings to existing physics concepts
    'Distance': 'physics_8_speed_velocity',
    'Displacement': 'physics_8_speed_velocity',
    'Scalars and Vectors': 'physics_8_motion_basics',
    'Acceleration': 'physics_8_acceleration',
    'Units': 'physics_8_acceleration',
    'SI System': 'physics_8_acceleration',
    'Speed': 'physics_8_speed_velocity',
    'Average Speed': 'physics_8_speed_velocity',
    'Motion': 'physics_8_motion_basics',
    'Velocity': 'physics_8_speed_velocity',
    'Uniform Motion': 'physics_8_speed_velocity',
    'Projectile Motion': 'physics_9_equations_motion',
    'Gravity': 'physics_9_equations_motion',
    'Free Fall': 'physics_9_equations_motion',
    'Equations of Motion': 'physics_9_equations_motion',
    'Uniform Acceleration': 'physics_8_acceleration',
    'Deceleration': 'physics_8_acceleration',
    'Braking Distance': 'physics_9_equations_motion',
    'Two-Phase Motion': 'physics_9_equations_motion',
    'Relative Motion': 'physics_9_equations_motion',
    'Quadratic Equations': 'physics_9_equations_motion', // Used in problem solving
  };

  final quizFile = File('assets/data/quizzes/physics/topic_kinematics.json');

  if (!quizFile.existsSync()) {
    print('❌ Quiz file not found: ${quizFile.path}');
    return;
  }

  print('📄 Reading quiz file...');
  final content = await quizFile.readAsString();
  final data = jsonDecode(content) as Map<String, dynamic>;

  print('✅ Quiz loaded: ${data['quiz']['title']}');
  print('');

  final questions = data['questions'] as List<dynamic>;
  int updatedCount = 0;
  int skippedCount = 0;

  print('🔄 Processing ${questions.length} questions...');
  print('');

  for (final question in questions) {
    final qId = question['id'];
    final oldTags = List<String>.from(question['conceptTags'] ?? []);

    if (oldTags.isEmpty) {
      print('⚠️  $qId: No concept tags');
      skippedCount++;
      continue;
    }

    // Convert display names to concept IDs
    final newTags = <String>{};
    final unmapped = <String>[];

    for (final tag in oldTags) {
      if (conceptMapping.containsKey(tag)) {
        newTags.add(conceptMapping[tag]!);
      } else {
        unmapped.add(tag);
      }
    }

    if (unmapped.isNotEmpty) {
      print('⚠️  $qId: Unmapped tags: $unmapped');
    }

    if (newTags.isEmpty) {
      print('⚠️  $qId: No valid concept mappings found');
      skippedCount++;
      continue;
    }

    question['conceptTags'] = newTags.toList();
    updatedCount++;

    print('✅ $qId:');
    print('   Old: $oldTags');
    print('   New: ${newTags.toList()}');
    print('');
  }

  print('=' * 60);
  print('📊 Summary:');
  print('   Questions updated: $updatedCount');
  print('   Questions skipped: $skippedCount');
  print('');

  // Write updated file
  print('💾 Writing updated quiz file...');
  final encoder = JsonEncoder.withIndent('  ');
  final updatedContent = encoder.convert(data);
  await quizFile.writeAsString(updatedContent);

  print('✅ Quiz file updated successfully!');
  print('');
  print('🧪 Next steps:');
  print('   1. Review the changes in topic_kinematics.json');
  print('   2. Reinstall the app to use updated quiz data');
  print('   3. Complete the kinematics quiz');
  print('   4. Watch for recommendations to generate successfully');
  print('');
  print('🎉 Done!');
}
