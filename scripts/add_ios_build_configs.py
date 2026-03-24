#!/usr/bin/env python3
"""
Add iOS build configurations for middle, preboard, and senior flavors.
This script duplicates the junior flavor configurations in the Xcode project.pbxproj file.
"""

import re
import sys
from pathlib import Path

def generate_unique_id():
    """Generate a unique 24-character hex ID for Xcode objects."""
    import hashlib
    import time
    # Use timestamp and random data to generate unique ID
    data = f"{time.time()}{id(object())}".encode()
    return hashlib.sha256(data).hexdigest()[:24].upper()

def duplicate_config(content, source_flavor, target_flavor, source_id_prefix, target_id_prefix):
    """
    Duplicate build configuration entries from source flavor to target flavor.

    Args:
        content: The project.pbxproj file content
        source_flavor: Source flavor name (e.g., 'junior')
        target_flavor: Target flavor name (e.g., 'middle')
        source_id_prefix: Source ID prefix pattern (e.g., 'JUNIOR')
        target_id_prefix: Target ID prefix pattern (e.g., 'MIDDLE')
    """
    # Configuration types to duplicate
    config_types = ['DEBUG', 'RELEASE', 'PROFILE']
    target_types = ['PROJECT', 'TARGET', 'TESTS']

    new_configs = []
    id_mapping = {}

    # First pass: Create new configuration entries
    for config_type in config_types:
        for target_type in target_types:
            source_key = f"{config_type}_{source_id_prefix}_{target_type}"
            target_key = f"{config_type}_{target_id_prefix}_{target_type}"

            # Generate unique ID for new configuration
            new_id = generate_unique_id()
            id_mapping[source_key] = (target_key, new_id)

            # Find the source configuration block
            pattern = rf"({source_key} /\* {config_type.title()}-{source_flavor} \*/ = \{{[^}}]+\}};\s*}};\s*}})"
            matches = re.findall(pattern, content, re.DOTALL)

            if not matches:
                # Try simpler pattern for shorter configs
                pattern = rf"({source_key} /\* {config_type.title()}-{source_flavor} \*/ = \{{[^}}]+\}};\s*}})"
                matches = re.findall(pattern, content, re.DOTALL)

            if matches:
                config_block = matches[0]

                # Replace flavor names and IDs
                new_block = config_block.replace(source_key, target_key)
                new_block = new_block.replace(f"{config_type.title()}-{source_flavor}", f"{config_type.title()}-{target_flavor}")
                new_block = new_block.replace(f".{source_flavor}", f".{target_flavor}")
                new_block = new_block.replace(f"Crack the Code Junior", get_product_name(target_flavor))
                new_block = new_block.replace(f"crackthecode.junior", f"crackthecode.{target_flavor}")

                # Replace xcconfig reference
                new_block = new_block.replace(f"{source_flavor.upper()}_", f"{target_flavor.upper()}_")
                new_block = new_block.replace(f"{source_flavor.lower()}-", f"{target_flavor.lower()}-")
                new_block = new_block.replace(f"AppIcon-{source_flavor}", f"AppIcon-{target_flavor}")

                new_configs.append(new_block)

    return new_configs, id_mapping

def get_product_name(flavor):
    """Get the product name for a flavor."""
    names = {
        'junior': 'Crack the Code Junior',
        'middle': 'Crack the Code',
        'preboard': 'Crack the Code Board Prep',
        'senior': 'Crack the Code'
    }
    return names.get(flavor, 'Crack the Code')

def add_to_configuration_lists(content, flavors):
    """Add new configurations to the buildConfigurations lists."""
    # Find the three buildConfigurations sections
    # They correspond to: Tests, Project, Target

    for flavor in flavors:
        flavor_upper = flavor.upper()

        # Add to each configuration list (3 total: Tests, Project, Target)
        # Pattern to find buildConfigurations lists
        config_list_pattern = r'(buildConfigurations = \([^)]+\);)'

        # We need to add entries for Debug, Release, Profile for each flavor
        for config_type in ['DEBUG', 'RELEASE', 'PROFILE']:
            for target_type in ['TESTS', 'PROJECT', 'TARGET']:
                key = f"{config_type}_{flavor_upper}_{target_type}"
                config_name = f"{config_type.title()}-{flavor}"

                # Add comment entry to configuration list
                entry = f"\t\t\t\t{key} /* {config_name} */,"

                # Find the corresponding list and add the entry
                # This is tricky - we need to add to the right list
                # For now, let's insert after the junior entries
                source_key = f"{config_type}_JUNIOR_{target_type}"
                pattern = rf"(\t\t\t\t{source_key} /\* {config_type.title()}-junior \*/,)"
                content = re.sub(pattern, rf"\1\n{entry}", content)

    return content

def main():
    project_file = Path('/Users/apple/work/Crack the Code/ios/Runner.xcodeproj/project.pbxproj')

    if not project_file.exists():
        print(f"Error: {project_file} not found")
        sys.exit(1)

    # Backup original file
    backup_file = project_file.with_suffix('.pbxproj.bak2')
    print(f"Creating backup at {backup_file}")

    # Read the project file
    content = project_file.read_text()

    # Save backup
    backup_file.write_text(content)

    # Flavors to add
    flavors_to_add = [
        ('junior', 'middle', 'JUNIOR', 'MIDDLE'),
        ('junior', 'preboard', 'JUNIOR', 'PREBOARD'),
        ('junior', 'senior', 'JUNIOR', 'SENIOR'),
    ]

    all_new_configs = []

    # Generate new configurations
    for source_flavor, target_flavor, source_id, target_id in flavors_to_add:
        print(f"\nDuplicating {source_flavor} configurations to {target_flavor}...")
        new_configs, id_mapping = duplicate_config(content, source_flavor, target_flavor, source_id, target_id)
        all_new_configs.extend(new_configs)
        print(f"Generated {len(new_configs)} configuration blocks for {target_flavor}")

    # Find where to insert the new configurations (after the last RELEASE_JUNIOR_TESTS)
    insertion_marker = "RELEASE_JUNIOR_TESTS /* Release-junior */ = {"
    insertion_pattern = rf"(RELEASE_JUNIOR_TESTS /\* Release-junior \*/ = \{{[^}}]+\}};\s*}};\s*}})"

    matches = re.findall(insertion_pattern, content, re.DOTALL)
    if not matches:
        insertion_pattern = rf"(RELEASE_JUNIOR_TESTS /\* Release-junior \*/ = \{{[^}}]+\}};\s*}})"
        matches = re.findall(insertion_pattern, content, re.DOTALL)

    if matches:
        last_junior_config = matches[-1]
        # Insert all new configurations after the last junior config
        insertion_text = "\n\t\t" + "\n\t\t".join(all_new_configs)
        content = content.replace(last_junior_config, last_junior_config + insertion_text)
        print(f"\nInserted {len(all_new_configs)} new configuration blocks")
    else:
        print("Warning: Could not find insertion point for new configurations")

    # Add references to configuration lists
    print("\nAdding configuration references to build configuration lists...")
    content = add_to_configuration_lists(content, ['middle', 'preboard', 'senior'])

    # Write the modified content back
    project_file.write_text(content)
    print(f"\nSuccessfully updated {project_file}")
    print("Build configurations added for: middle, preboard, senior")

if __name__ == '__main__':
    main()
