#!/usr/bin/env python3
"""
Duplicate iOS build configurations from junior flavor to middle, preboard, and senior.
This script carefully parses and modifies the project.pbxproj file.
"""

import re
import uuid

def generate_xcode_id():
    """Generate a unique 24-character hex ID for Xcode."""
    return uuid.uuid4().hex[:24].upper()

def main():
    pbxproj_path = '/Users/apple/work/Crack the Code/ios/Runner.xcodeproj/project.pbxproj'

    # Read the file
    with open(pbxproj_path, 'r') as f:
        content = f.read()

    # Backup
    with open(pbxproj_path + '.bak3', 'w') as f:
        f.write(content)

    print("Created backup at project.pbxproj.bak3")

    # Define flavors to add
    flavors_config = {
        'middle': {
            'bundle_id': 'com.crackthecode.app.middle',
            'product_name': 'Crack the Code',
            'display_name': 'Crack the Code',
            'icon': 'AppIcon-middle',
            'xcconfig_prefix': 'MIDDLE'
        },
        'preboard': {
            'bundle_id': 'com.crackthecode.app.preboard',
            'product_name': 'Crack the Code Board Prep',
            'display_name': 'Crack the Code Board Prep',
            'icon': 'AppIcon-preboard',
            'xcconfig_prefix': 'PREBOARD'
        },
        'senior': {
            'bundle_id': 'com.crackthecode.app',
            'product_name': 'Crack the Code',
            'display_name': 'Crack the Code',
            'icon': 'AppIcon-senior',
            'xcconfig_prefix': 'SENIOR'
        }
    }

    # Extract junior configurations
    # Pattern to match complete configuration blocks
    debug_project_pattern = r'(DEBUG_JUNIOR_PROJECT /\* Debug-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'
    debug_target_pattern = r'(DEBUG_JUNIOR_TARGET /\* Debug-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'
    debug_tests_pattern = r'(DEBUG_JUNIOR_TESTS /\* Debug-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'

    release_project_pattern = r'(RELEASE_JUNIOR_PROJECT /\* Release-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'
    release_target_pattern = r'(RELEASE_JUNIOR_TARGET /\* Release-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'
    release_tests_pattern = r'(RELEASE_JUNIOR_TESTS /\* Release-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'

    profile_project_pattern = r'(PROFILE_JUNIOR_PROJECT /\* Profile-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'
    profile_target_pattern = r'(PROFILE_JUNIOR_TARGET /\* Profile-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'
    profile_tests_pattern = r'(PROFILE_JUNIOR_TESTS /\* Profile-junior \*/ = \{[^}]*?\n\t\t\t\};[^}]*?\n\t\t\};)'

    config_patterns = {
        'DEBUG_PROJECT': debug_project_pattern,
        'DEBUG_TARGET': debug_target_pattern,
        'DEBUG_TESTS': debug_tests_pattern,
        'RELEASE_PROJECT': release_project_pattern,
        'RELEASE_TARGET': release_target_pattern,
        'RELEASE_TESTS': release_tests_pattern,
        'PROFILE_PROJECT': profile_project_pattern,
        'PROFILE_TARGET': profile_target_pattern,
        'PROFILE_TESTS': profile_tests_pattern,
    }

    # Extract all junior configurations
    junior_configs = {}
    for config_key, pattern in config_patterns.items():
        match = re.search(pattern, content, re.DOTALL)
        if match:
            junior_configs[config_key] = match.group(1)
            print(f"Extracted {config_key}")
        else:
            print(f"Warning: Could not find {config_key}")

    # Generate new configurations for each flavor
    all_new_configs = []

    for flavor, config in flavors_config.items():
        print(f"\nGenerating configurations for {flavor}...")

        for config_type in ['DEBUG', 'RELEASE', 'PROFILE']:
            for target_type in ['PROJECT', 'TARGET', 'TESTS']:
                key = f"{config_type}_{target_type}"
                if key not in junior_configs:
                    continue

                # Duplicate the configuration
                new_config = junior_configs[key]

                # Replace IDs
                new_id = f"{config_type}_{config['xcconfig_prefix']}_{target_type}"
                new_config = new_config.replace(f"{config_type}_JUNIOR_{target_type}", new_id)

                # Replace display names
                new_config = new_config.replace("Debug-junior", f"{config_type.title()}-{flavor}")
                new_config = new_config.replace("Release-junior", f"{config_type.title()}-{flavor}")
                new_config = new_config.replace("Profile-junior", f"{config_type.title()}-{flavor}")

                # Replace product identifiers
                new_config = new_config.replace("com.crackthecode.app.junior", config['bundle_id'])
                new_config = new_config.replace("Crack the Code Junior", config['product_name'])

                # Replace xcconfig references
                new_config = new_config.replace("JUNIOR_DEBUG_CONFIG", f"{config['xcconfig_prefix']}_DEBUG_CONFIG")
                new_config = new_config.replace("JUNIOR_RELEASE_CONFIG", f"{config['xcconfig_prefix']}_RELEASE_CONFIG")
                new_config = new_config.replace("JUNIOR_PROFILE_CONFIG", f"{config['xcconfig_prefix']}_PROFILE_CONFIG")
                new_config = new_config.replace("junior-Debug.xcconfig", f"{flavor}-Debug.xcconfig")
                new_config = new_config.replace("junior-Release.xcconfig", f"{flavor}-Release.xcconfig")
                new_config = new_config.replace("junior-Profile.xcconfig", f"{flavor}-Profile.xcconfig")

                # Replace icon names
                new_config = new_config.replace("AppIcon-junior", config['icon'])

                # Replace Pods xcconfig references
                new_config = new_config.replace("debug-junior.xcconfig", f"debug-{flavor}.xcconfig")
                new_config = new_config.replace("release-junior.xcconfig", f"release-{flavor}.xcconfig")
                new_config = new_config.replace("profile-junior.xcconfig", f"profile-{flavor}.xcconfig")

                all_new_configs.append(new_config)
                print(f"  Created {new_id}")

    # Find insertion point (after last RELEASE_JUNIOR_TESTS)
    match = re.search(release_tests_pattern, content, re.DOTALL)
    if match:
        insertion_point = match.end()
        # Insert all new configurations
        new_content = content[:insertion_point] + '\n\t\t' + '\n\t\t'.join(all_new_configs) + content[insertion_point:]

        # Now update configuration lists
        # Add references to buildConfigurations arrays
        for flavor, config in flavors_config.items():
            for config_type in ['DEBUG', 'RELEASE', 'PROFILE']:
                # Add to Tests configuration list
                pattern = rf"(DEBUG_JUNIOR_TESTS /\* Debug-junior \*/,)"
                replacement = rf"\1\n\t\t\t\t{config_type}_{config['xcconfig_prefix']}_TESTS /* {config_type.title()}-{flavor} */,"
                new_content = new_content.replace(pattern, replacement, 1)

                # Add to Project configuration list
                pattern = rf"(DEBUG_JUNIOR_PROJECT /\* Debug-junior \*/,)"
                replacement = rf"\1\n\t\t\t\t{config_type}_{config['xcconfig_prefix']}_PROJECT /* {config_type.title()}-{flavor} */,"
                new_content = new_content.replace(pattern, replacement, 1)

                # Add to Target configuration list
                pattern = rf"(DEBUG_JUNIOR_TARGET /\* Debug-junior \*/,)"
                replacement = rf"\1\n\t\t\t\t{config_type}_{config['xcconfig_prefix']}_TARGET /* {config_type.title()}-{flavor} */,"
                new_content = new_content.replace(pattern, replacement, 1)

        # Write updated content
        with open(pbxproj_path, 'w') as f:
            f.write(new_content)

        print(f"\nSuccessfully updated project.pbxproj")
        print(f"Added {len(all_new_configs)} configuration blocks")
        print("Configurations added for: middle, preboard, senior")
    else:
        print("Error: Could not find insertion point")

if __name__ == '__main__':
    main()
