#!/usr/bin/env ruby
# Add iOS build configurations for middle, preboard, and senior flavors

require 'xcodeproj'

project_path = '/Users/apple/work/StreamShaala/ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Flavors to add configurations for
new_flavors = {
  'middle' => {
    'bundle_id' => 'com.streamshaala.streamshaala.middle',
    'product_name' => 'StreamShaala',
    'display_name' => 'StreamShaala',
    'icon_name' => 'AppIcon-middle',
    'entry_point' => 'lib/main_middle.dart'
  },
  'preboard' => {
    'bundle_id' => 'com.streamshaala.streamshaala.preboard',
    'product_name' => 'StreamShaala Board Prep',
    'display_name' => 'StreamShaala Board Prep',
    'icon_name' => 'AppIcon-preboard',
    'entry_point' => 'lib/main_preboard.dart'
  },
  'senior' => {
    'bundle_id' => 'com.streamshaala.streamshaala',
    'product_name' => 'StreamShaala',
    'display_name' => 'StreamShaala',
    'icon_name' => 'AppIcon-senior',
    'entry_point' => 'lib/main_senior.dart'
  }
}

# Build configuration types
build_types = ['Debug', 'Release', 'Profile']

# Add build configurations for each flavor
new_flavors.each do |flavor, settings|
  puts "\nAdding configurations for #{flavor}..."

  build_types.each do |build_type|
    config_name = "#{build_type}-#{flavor}"

    # Check if configuration already exists
    existing_config = project.build_configurations.find { |c| c.name == config_name }
    if existing_config
      puts "  #{config_name} already exists, skipping..."
      next
    end

    # Find the base configuration to duplicate
    base_config_name = "#{build_type}-junior"
    base_config = project.build_configurations.find { |c| c.name == base_config_name }

    if base_config.nil?
      puts "  Warning: Could not find base configuration #{base_config_name}"
      next
    end

    # Add new configuration
    new_config = project.add_build_configuration(config_name, build_type.downcase.to_sym)

    # Copy settings from base configuration
    base_config.build_settings.each do |key, value|
      next if key == 'name'
      new_config.build_settings[key] = value.dup rescue value
    end

    puts "  Added #{config_name}"
  end
end

# Save the project
project.save
puts "\nProject configurations updated successfully!"
puts "New configurations added for: middle, preboard, senior"
