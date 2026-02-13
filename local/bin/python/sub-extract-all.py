#!/usr/bin/env python3

import subprocess
import os
import sys
from pathlib import Path


def run_command(cmd, check=True, capture_output=False, text=True):
    """Small helper to run subprocess commands"""
    try:
        result = subprocess.run(
            cmd,
            check=check,
            capture_output=capture_output,
            text=text,
            encoding="utf-8" if text else None,
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {' '.join(cmd)}", file=sys.stderr)
        print(e.stderr if e.stderr else "", file=sys.stderr)
        return None


def get_subtitle_codec(mkv_path: str) -> str | None:
    """Get codec name of the first subtitle stream using ffprobe"""
    cmd = [
        "ffprobe",
        "-v",
        "error",
        "-select_streams",
        "s:0",
        "-show_entries",
        "stream=codec_name",
        "-of",
        "csv=p=0",
        mkv_path,
    ]
    result = run_command(cmd, capture_output=True, check=False)
    if result is None or not result.stdout.strip():
        return None
    return result.stdout.strip()


def main():
    mkv_files = list(Path(".").glob("*.mkv"))

    if not mkv_files:
        print("No .mkv files found in current directory.")
        return

    for mkv_path in sorted(mkv_files):
        basename = mkv_path.stem
        print(f"\nProcessing: {mkv_path}")

        codec = get_subtitle_codec(str(mkv_path))
        if not codec:
            print("  Could not detect subtitle stream → skipping")
            continue

        if codec == "ass":
            extracted_sub = f"{basename}eng.ass"
            target_ext = ".ass"
        elif codec in ("subrip", "srt"):
            extracted_sub = f"{basename}eng.srt"
            target_ext = ".srt"
        else:
            print(f"  Unsupported subtitle format: {codec} → skipping")
            continue

        print(f"  Extracting {codec} subtitles → {extracted_sub}")

        # Extract first subtitle track
        extract_cmd = [
            "ffmpeg",
            "-y",
            "-loglevel",
            "error",
            "-i",
            str(mkv_path),
            "-map",
            "0:s:0",
            extracted_sub,
        ]
        result = run_command(extract_cmd)
        if result is None or not Path(extracted_sub).is_file():
            print("  Extraction failed")
            continue

        print("  Extraction successful")

        # Look for existing subtitle to align with
        original_sub = None
        for ext in (".srt", ".ass"):
            candidate = Path(f"{basename}{ext}")
            if candidate.is_file():
                original_sub = str(candidate)
                break

        if not original_sub:
            print("  No existing .srt or .ass file found to align with")
            os.remove(extracted_sub)
            continue

        print(f"  Aligning with existing file: {original_sub}")

        temp_sub = f"{basename}temp{target_ext}"

        alass_cmd = ["alass-cli", extracted_sub, original_sub, temp_sub]

        result = run_command(alass_cmd)
        if result is None or not Path(temp_sub).is_file():
            print("  Alignment failed – keeping original file")
            os.remove(extracted_sub)
            continue

        # Replace original with aligned version
        try:
            os.remove(original_sub)
            os.rename(temp_sub, original_sub)
            print(f"  Successfully aligned and replaced: {original_sub}")
        except OSError as e:
            print(f"  Error during file replacement: {e}")
            # Try to clean up temp file
            if Path(temp_sub).exists():
                os.remove(temp_sub)

        # Clean up extracted file
        if Path(extracted_sub).exists():
            os.remove(extracted_sub)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted by user.")
        sys.exit(1)
