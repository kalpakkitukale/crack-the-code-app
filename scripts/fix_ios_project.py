#!/usr/bin/env python3
"""
Fix iOS Xcode project.pbxproj file by removing duplicate xcconfig references.
"""

import re

pbxproj_path = '/Users/apple/work/Crack the Code/ios/Runner.xcodeproj/project.pbxproj'

# Read the file
with open(pbxproj_path, 'r') as f:
    lines = f.readlines()

# Backup
with open(pbxproj_path + '.bak_fix', 'w') as f:
    f.writelines(lines)

print("Created backup at project.pbxproj.bak_fix")

# Track which senior config references we've seen
senior_refs_seen = {
    'SENIOR_DEBUG_CONFIG': False,
    'SENIOR_RELEASE_CONFIG': False,
    'SENIOR_PROFILE_CONFIG': False
}

# Track which lines to keep
lines_to_keep = []

i = 0
while i < len(lines):
    line = lines[i]

    # Check if this is a duplicate senior PBXFileReference
    is_duplicate = False
    for ref_id in senior_refs_seen.keys():
        if f"{ref_id} /* senior-" in line and "PBXFileReference" in line:
            if senior_refs_seen[ref_id]:
                # This is a duplicate, skip it
                is_duplicate = True
                print(f"Removing duplicate: {line.strip()}")
                break
            else:
                # First occurrence, mark as seen
                senior_refs_seen[ref_id] = True

    if not is_duplicate:
        lines_to_keep.append(line)

    i += 1

# Now check for duplicate entries in children arrays
# We need to remove duplicate senior config references from the Flutter group

final_lines = []
in_flutter_group = False
flutter_group_depth = 0

for i, line in enumerate(lines_to_keep):
    # Detect Flutter group
    if 'name = Flutter;' in line or 'path = Flutter;' in line:
        in_flutter_group = True
        flutter_group_depth = 0

    # Track braces to know when we exit the group
    if in_flutter_group:
        flutter_group_depth += line.count('{')
        flutter_group_depth -= line.count('}')

        if flutter_group_depth <= 0:
            in_flutter_group = False

    # Check if this is a duplicate senior config in children array
    is_dup_in_children = False
    if in_flutter_group and 'SENIOR_' in line and '_CONFIG' in line:
        # Check if we've already seen this line in the children array
        senior_line = line.strip()
        # Count occurrences before this point
        count_before = sum(1 for l in final_lines if senior_line in l)
        if count_before > 0:
            is_dup_in_children = True
            print(f"Removing duplicate from children array: {line.strip()}")

    if not is_dup_in_children:
        final_lines.append(line)

# Write the fixed content
with open(pbxproj_path, 'w') as f:
    f.writelines(final_lines)

print(f"\nSuccessfully fixed {pbxproj_path}")
print("Removed duplicate senior xcconfig references")
