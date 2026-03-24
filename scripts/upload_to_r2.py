#!/usr/bin/env python3
"""
R2 Upload Script for StreamShaala
Uploads content to Cloudflare R2 bucket

Usage:
    python upload_to_r2.py <local_dir> <bucket_path> [--dry-run]

Example:
    python upload_to_r2.py content/v1/ streamshaala-content/v1/

Prerequisites:
    1. Install boto3: pip install boto3
    2. Set environment variables:
       - R2_ACCOUNT_ID: Your Cloudflare account ID
       - R2_ACCESS_KEY_ID: R2 API token access key
       - R2_SECRET_ACCESS_KEY: R2 API token secret
       - R2_BUCKET_NAME: Name of your R2 bucket

Configuration:
    You can also create a .env file or config file with these values.
"""

import os
import sys
import argparse
import mimetypes
from pathlib import Path
from typing import Optional, Dict, List, Tuple

try:
    import boto3
    from botocore.config import Config
except ImportError:
    print("Error: boto3 package not installed.")
    print("Install with: pip install boto3")
    sys.exit(1)


# =============================================================================
# R2 CONFIGURATION
# =============================================================================
# Set these via environment variables or modify directly (not recommended)
# =============================================================================

def get_r2_config() -> Dict[str, str]:
    """Get R2 configuration from environment variables."""
    config = {
        'account_id': os.environ.get('R2_ACCOUNT_ID', ''),
        'access_key_id': os.environ.get('R2_ACCESS_KEY_ID', ''),
        'secret_access_key': os.environ.get('R2_SECRET_ACCESS_KEY', ''),
        'bucket_name': os.environ.get('R2_BUCKET_NAME', 'streamshaala-content'),
    }

    # Validate required fields
    missing = [k for k, v in config.items() if not v and k != 'bucket_name']
    if missing:
        print("Error: Missing required R2 configuration:")
        for key in missing:
            env_var = f"R2_{key.upper()}"
            print(f"  - {env_var}")
        print()
        print("Set these environment variables and try again.")
        sys.exit(1)

    return config


def create_r2_client(config: Dict[str, str]):
    """Create an S3-compatible client for R2."""
    endpoint_url = f"https://{config['account_id']}.r2.cloudflarestorage.com"

    return boto3.client(
        's3',
        endpoint_url=endpoint_url,
        aws_access_key_id=config['access_key_id'],
        aws_secret_access_key=config['secret_access_key'],
        config=Config(
            signature_version='s3v4',
            s3={'addressing_style': 'path'},
        ),
    )


def get_content_type(file_path: str) -> str:
    """Determine content type for a file."""
    if file_path.endswith('.json'):
        return 'application/json'

    mime_type, _ = mimetypes.guess_type(file_path)
    return mime_type or 'application/octet-stream'


def scan_directory(local_dir: str) -> List[Tuple[str, str]]:
    """
    Scan a directory for files to upload.

    Returns:
        List of (local_path, relative_path) tuples
    """
    files = []
    local_path = Path(local_dir)

    for root, dirs, filenames in os.walk(local_dir):
        for filename in filenames:
            full_path = os.path.join(root, filename)
            rel_path = os.path.relpath(full_path, local_dir)
            files.append((full_path, rel_path))

    return sorted(files)


def upload_file(client, bucket: str, local_path: str, remote_path: str,
               dry_run: bool = False) -> bool:
    """
    Upload a single file to R2.

    Args:
        client: boto3 S3 client
        bucket: Bucket name
        local_path: Local file path
        remote_path: Remote object key
        dry_run: If True, don't actually upload

    Returns:
        True if successful
    """
    content_type = get_content_type(local_path)

    if dry_run:
        print(f"  [DRY RUN] Would upload: {remote_path}")
        return True

    try:
        with open(local_path, 'rb') as f:
            client.upload_fileobj(
                f,
                bucket,
                remote_path,
                ExtraArgs={
                    'ContentType': content_type,
                    'CacheControl': 'public, max-age=31536000',  # 1 year cache
                },
            )
        print(f"  Uploaded: {remote_path}")
        return True

    except Exception as e:
        print(f"  Failed to upload {remote_path}: {e}")
        return False


def upload_directory(local_dir: str, bucket_path: str, dry_run: bool = False) -> Dict:
    """
    Upload all files in a directory to R2.

    Args:
        local_dir: Local directory to upload
        bucket_path: Remote path prefix (bucket_name/path)
        dry_run: If True, don't actually upload

    Returns:
        Statistics dict
    """
    stats = {
        'total': 0,
        'uploaded': 0,
        'failed': 0,
        'skipped': 0,
        'bytes': 0,
    }

    # Parse bucket path
    parts = bucket_path.strip('/').split('/', 1)
    bucket_name = parts[0]
    prefix = parts[1] if len(parts) > 1 else ''

    # Get configuration
    config = get_r2_config()

    # Override bucket name if specified in path
    if bucket_name:
        config['bucket_name'] = bucket_name
    else:
        bucket_name = config['bucket_name']

    print(f"\nUpload Configuration:")
    print(f"  Local directory: {local_dir}")
    print(f"  Bucket: {bucket_name}")
    print(f"  Prefix: {prefix or '(root)'}")
    print(f"  Dry run: {dry_run}")
    print()

    # Create client
    if not dry_run:
        client = create_r2_client(config)

        # Test connection
        try:
            client.head_bucket(Bucket=bucket_name)
            print(f"Connected to bucket: {bucket_name}")
        except Exception as e:
            print(f"Error: Cannot access bucket '{bucket_name}': {e}")
            return stats
    else:
        client = None

    # Scan files
    files = scan_directory(local_dir)
    print(f"Found {len(files)} files to upload")
    print()

    # Upload files
    for local_path, rel_path in files:
        stats['total'] += 1

        # Build remote path
        if prefix:
            remote_path = f"{prefix}/{rel_path}"
        else:
            remote_path = rel_path

        # Normalize path separators
        remote_path = remote_path.replace('\\', '/')

        # Get file size
        file_size = os.path.getsize(local_path)

        if upload_file(client, bucket_name, local_path, remote_path, dry_run):
            stats['uploaded'] += 1
            stats['bytes'] += file_size
        else:
            stats['failed'] += 1

    return stats


def format_bytes(bytes_count: int) -> str:
    """Format bytes as human-readable string."""
    for unit in ['B', 'KB', 'MB', 'GB']:
        if bytes_count < 1024:
            return f"{bytes_count:.1f} {unit}"
        bytes_count /= 1024
    return f"{bytes_count:.1f} TB"


def main():
    parser = argparse.ArgumentParser(
        description='Upload content to Cloudflare R2',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Environment Variables:
  R2_ACCOUNT_ID         Your Cloudflare account ID
  R2_ACCESS_KEY_ID      R2 API token access key
  R2_SECRET_ACCESS_KEY  R2 API token secret
  R2_BUCKET_NAME        Default bucket name (optional)

Examples:
  # Dry run to see what would be uploaded
  python upload_to_r2.py content/v1/ streamshaala-content/v1/ --dry-run

  # Actually upload
  python upload_to_r2.py content/v1/ streamshaala-content/v1/

  # Upload manifest
  python upload_to_r2.py manifest.json streamshaala-content/
        """
    )

    parser.add_argument('local_dir', help='Local directory to upload')
    parser.add_argument('bucket_path', help='Bucket name and path (bucket/prefix)')
    parser.add_argument('--dry-run', '-n', action='store_true',
                       help="Don't actually upload, just show what would be done")

    args = parser.parse_args()

    # Validate local directory
    if not os.path.exists(args.local_dir):
        print(f"Error: Local directory does not exist: {args.local_dir}")
        sys.exit(1)

    # Upload
    stats = upload_directory(args.local_dir, args.bucket_path, args.dry_run)

    # Summary
    print()
    print("=" * 50)
    print("Upload Summary")
    print("=" * 50)
    print(f"  Total files:    {stats['total']}")
    print(f"  Uploaded:       {stats['uploaded']}")
    print(f"  Failed:         {stats['failed']}")
    print(f"  Total size:     {format_bytes(stats['bytes'])}")

    if args.dry_run:
        print()
        print("This was a dry run. No files were actually uploaded.")
        print("Remove --dry-run to perform the actual upload.")

    if stats['failed'] > 0:
        sys.exit(1)


if __name__ == '__main__':
    main()
