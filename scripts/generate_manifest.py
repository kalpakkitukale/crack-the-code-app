#!/usr/bin/env python3
"""
Manifest Generator for Crack the Code
Generates a manifest.json file for content synchronization

Usage:
    python generate_manifest.py <content_dir> <version> [--output manifest.json]

Example:
    python generate_manifest.py content/v1/ v1 --output manifest.json

The manifest contains:
- Content version
- Update timestamp
- Segments with checksums
- Subject and chapter listings
"""

import os
import sys
import json
import hashlib
import argparse
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional


def calculate_checksum(file_path: str) -> str:
    """Calculate SHA-256 checksum of a file."""
    sha256 = hashlib.sha256()
    with open(file_path, 'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            sha256.update(chunk)
    return sha256.hexdigest()[:16]  # Use first 16 chars for brevity


def calculate_directory_checksum(dir_path: str) -> str:
    """Calculate combined checksum of all files in a directory."""
    sha256 = hashlib.sha256()
    file_checksums = []

    for root, dirs, files in sorted(os.walk(dir_path)):
        for filename in sorted(files):
            if filename.endswith('.json'):
                file_path = os.path.join(root, filename)
                file_checksums.append(calculate_checksum(file_path))

    # Combine all checksums
    for checksum in file_checksums:
        sha256.update(checksum.encode())

    return sha256.hexdigest()[:16]


def scan_segment(segment_path: str, segment_name: str) -> Dict[str, Any]:
    """
    Scan a segment directory and build its manifest entry.

    Args:
        segment_path: Path to segment directory
        segment_name: Name of the segment (e.g., "junior", "senior")

    Returns:
        Segment manifest dict
    """
    segment_data = {
        'checksum': calculate_directory_checksum(segment_path),
        'updatedAt': datetime.utcnow().isoformat() + 'Z',
        'subjects': [],
        'subjectDetails': {},
    }

    # Scan for subjects
    for item in sorted(os.listdir(segment_path)):
        item_path = os.path.join(segment_path, item)

        # Skip files, only process directories
        if not os.path.isdir(item_path):
            continue

        # Skip if it looks like a file
        if item.endswith('.json'):
            continue

        subject_id = item
        segment_data['subjects'].append(subject_id)

        # Scan chapters for this subject
        chapters = []
        for chapter_item in sorted(os.listdir(item_path)):
            chapter_path = os.path.join(item_path, chapter_item)
            if os.path.isdir(chapter_path):
                chapters.append(chapter_item)

        segment_data['subjectDetails'][subject_id] = {
            'checksum': calculate_directory_checksum(item_path),
            'chapters': chapters,
            'chapterCount': len(chapters),
        }

    return segment_data


def generate_manifest(content_dir: str, version: str) -> Dict[str, Any]:
    """
    Generate a complete manifest for the content directory.

    Args:
        content_dir: Root content directory (containing version subdirs or segments)
        version: Content version string

    Returns:
        Complete manifest dict
    """
    manifest = {
        'version': version,
        'updatedAt': datetime.utcnow().isoformat() + 'Z',
        'generatedBy': 'generate_manifest.py',
        'segments': {},
    }

    content_path = Path(content_dir)

    if not content_path.exists():
        print(f"Error: Content directory does not exist: {content_dir}")
        return manifest

    # Scan for segments (top-level directories)
    for item in sorted(os.listdir(content_dir)):
        item_path = os.path.join(content_dir, item)

        # Skip files
        if not os.path.isdir(item_path):
            continue

        # Skip version directories if they exist, scan their contents
        if item.startswith('v') and item[1:].isdigit():
            # This is a version directory, scan its contents
            for segment in sorted(os.listdir(item_path)):
                segment_path = os.path.join(item_path, segment)
                if os.path.isdir(segment_path):
                    manifest['segments'][segment] = scan_segment(segment_path, segment)
        else:
            # This is a segment directory directly
            manifest['segments'][item] = scan_segment(item_path, item)

    # Calculate overall checksum
    all_checksums = []
    for segment_name, segment_data in manifest['segments'].items():
        all_checksums.append(segment_data['checksum'])

    sha256 = hashlib.sha256()
    for checksum in sorted(all_checksums):
        sha256.update(checksum.encode())
    manifest['checksum'] = sha256.hexdigest()[:16]

    return manifest


def main():
    parser = argparse.ArgumentParser(
        description='Generate content manifest for Crack the Code',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python generate_manifest.py content/v1/ v1
  python generate_manifest.py content/ v1 --output manifest.json
  python generate_manifest.py content/ v1 --pretty
        """
    )

    parser.add_argument('content_dir', help='Content directory to scan')
    parser.add_argument('version', help='Content version (e.g., v1, v2)')
    parser.add_argument('--output', '-o', help='Output file (default: stdout)')
    parser.add_argument('--pretty', '-p', action='store_true',
                       help='Pretty print JSON output')

    args = parser.parse_args()

    # Generate manifest
    print(f"Scanning content directory: {args.content_dir}", file=sys.stderr)
    print(f"Version: {args.version}", file=sys.stderr)

    manifest = generate_manifest(args.content_dir, args.version)

    # Format output
    if args.pretty:
        output = json.dumps(manifest, indent=2, sort_keys=True)
    else:
        output = json.dumps(manifest, separators=(',', ':'))

    # Write output
    if args.output:
        with open(args.output, 'w') as f:
            f.write(output)
        print(f"Manifest written to: {args.output}", file=sys.stderr)
    else:
        print(output)

    # Summary
    print(f"\nManifest summary:", file=sys.stderr)
    print(f"  Version: {manifest['version']}", file=sys.stderr)
    print(f"  Checksum: {manifest.get('checksum', 'N/A')}", file=sys.stderr)
    print(f"  Segments: {len(manifest['segments'])}", file=sys.stderr)

    for segment_name, segment_data in manifest['segments'].items():
        subject_count = len(segment_data.get('subjects', []))
        print(f"    - {segment_name}: {subject_count} subjects", file=sys.stderr)


if __name__ == '__main__':
    main()
