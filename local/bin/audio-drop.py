#!/usr/bin/env python3

import os
import subprocess
import json
import sys


def get_audio_tracks(mkvfile):
    result = subprocess.run(
        ["mkvmerge", "-J", mkvfile],
        capture_output=True,
        text=True,
        check=True,
    )

    data = json.loads(result.stdout)
    audio_tracks = []

    for track in data["tracks"]:
        if track["type"] == "audio":
            props = track.get("properties", {})
            audio_tracks.append(
                {
                    "id": track["id"],
                    "codec": track.get("codec"),
                    "language": props.get("language", "und"),
                    "name": props.get("track_name", ""),
                }
            )

    return audio_tracks


def check_batch_safety(mkvfiles):
    """
    Ensures all MKV files have the same number of tracks
    and the same track names (by order).
    """
    reference = None

    for mkvfile in mkvfiles:
        result = subprocess.run(
            ["mkvmerge", "-J", mkvfile],
            capture_output=True,
            text=True,
            check=True,
        )
        data = json.loads(result.stdout)

        # Create signature list of (type, name) for comparison
        signature = [
            (t["type"], t.get("properties", {}).get("track_name", ""))
            for t in data["tracks"]
        ]

        if reference is None:
            reference = signature
        elif signature != reference:
            print(f"Batch safety check failed for: {mkvfile}")
            print("Track layout does not match the reference file.")
            sys.exit(1)

    return True


def main():
    mkvfiles = sorted(f for f in os.listdir(".") if f.endswith(".mkv"))
    if not mkvfiles:
        print("No MKV files found.")
        sys.exit(1)

    # Batch safety check
    check_batch_safety(mkvfiles)

    sample = mkvfiles[0]
    print(f"Detecting audio tracks from: {sample}\n")

    tracks = get_audio_tracks(sample)
    if not tracks:
        print("No audio tracks found.")
        sys.exit(1)

    print("Available audio tracks:")
    for t in tracks:
        name = f" ({t['name']})" if t["name"] else ""
        print(f"  ID {t['id']}: {t['codec']} | lang={t['language']}{name}")

    # Auto-select Japanese track if possible
    jpn_tracks = [t for t in tracks if t["language"] == "jpn"]

    if len(jpn_tracks) == 1:
        number = str(jpn_tracks[0]["id"])
        print(f"\nAuto-selected Japanese track: ID {number}")
    else:
        if not jpn_tracks:
            print("\nNo Japanese (jpn) audio track found.")
        else:
            print("\nMultiple Japanese audio tracks found.")

        number = input("Which audio track ID are we keeping? ").strip()

    for mkvfile in mkvfiles:
        basename = mkvfile[:-4]
        tempname = f"temp{basename}.mkv"
        print(f"Processing {mkvfile}...")

        subprocess.run(
            ["mkvmerge", "-o", tempname, "--audio-tracks", number, mkvfile],
            check=True,
        )

        os.remove(mkvfile)
        os.rename(tempname, mkvfile)


if __name__ == "__main__":
    main()
