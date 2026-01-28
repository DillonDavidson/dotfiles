#!/usr/bin/env python3

import json
import subprocess
import sys
import re
from pathlib import Path


def run(cmd, capture=False):
    """Simple subprocess wrapper"""
    try:
        result = subprocess.run(
            cmd, text=True, encoding="utf-8", capture_output=capture, check=True
        )
        return result.stdout.strip() if capture else result
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {' '.join(cmd)}", file=sys.stderr)
        print(e.stderr.strip(), file=sys.stderr)
        sys.exit(1)


def parse_mkvinfo_tracks(filepath: str):
    """
    Parse mkvinfo output and extract meaningful track information
    Returns list of dicts with: tid (0-based), track_number, type, lang, name, codec
    """
    output = run(["mkvinfo", filepath], capture=True)

    tracks = []
    current = {}

    for line in output.splitlines():
        line = line.strip()

        # New track block starts
        if re.match(r"^\|\s+\+ Track$", line) or re.match(
            r"^\|\s+\+ Track number:", line
        ):
            if current:
                # Save previous track (if complete)
                if "tid" in current:
                    tracks.append(current)
            current = {}

        if "Track number:" or "トラック番号:" in line:
            # Examples:
            #   + トラック番号: 1 (track ID for mkvmerge & mkvextract: 0)
            #   + Track number: 1 (track ID for mkvmerge & mkvextract: 0)
            m = re.search(r"track ID for mkvmerge.*?(\d+)", line)
            if m:
                current["tid"] = int(m.group(1))  # 0-based
                current["track_number"] = current["tid"] + 1

        elif "Track type:" in line or "トラックタイプ:" in line:
            if "video" in line.lower() or "ビデオ" in line:
                current["type"] = "video"
            elif "audio" in line.lower() or "オーディオ" in line:
                current["type"] = "audio"
            elif "subtitle" in line.lower() or "字幕" in line:
                current["type"] = "subtitle"

        elif "Language:" in line or "言語:" in line:
            # + Language: jpn  or  + 言語: jpn
            # + Language (IETF BCP 47): ja
            m = re.search(r":\s*([a-z]{2,3})(?:\s|$)", line)
            if m:
                current["lang"] = m.group(1)

        elif "Name:" in line or "名前:" in line:
            # + Name: Signs & Songs@EMBER
            # + 名前: Dialogue@GJM
            if ":" in line:
                _, name_part = line.split(":", 1)
                current["name"] = name_part.strip()

        elif "Codec ID:" in line or "コーデックID:" in line:
            if ":" in line:
                _, codec = line.split(":", 1)
                current["codec"] = codec.strip()

    # Don't forget the last track
    if current and "tid" in current:
        tracks.append(current)

    return tracks


def print_track_table(tracks):
    print("\nAvailable tracks (mkvmerge uses 0-based IDs):")
    print(" TID  Type     Lang   Codec              Name")
    print("──── ──────── ────── ────────────────── ────────────────────────────────")

    for t in tracks:
        tid = t.get("tid", "?")
        typ = t.get("type", "unknown").ljust(8)
        lang = t.get("lang", "und").ljust(6)
        codec = t.get("codec", "—").ljust(18)
        name = t.get("name", "—")

        print(f" {tid:2d}  {typ} {lang} {codec} {name}")


def verify_tracks_are_same(mkvfiles):
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


def main():
    mkvs = list(Path(".").glob("*.mkv"))
    if not mkvs:
        print("No .mkv files found.")
        return

    verify_tracks_are_same(mkvs)

    # Use first file as reference
    ref_file = str(mkvs[0])
    print(f"Analyzing tracks from: {ref_file}\n")

    tracks = parse_mkvinfo_tracks(ref_file)

    if not tracks:
        print("Could not parse any tracks.", file=sys.stderr)
        return

    return
    print_track_table(tracks)

    # ──────────────────────────────────────────────
    # Filter visible subtitle tracks for user choice
    subs = [t for t in tracks if t.get("type") == "subtitle"]
    if not subs:
        print("\nNo subtitle tracks found.")
    else:
        print("\nSubtitle tracks:")
        for t in subs:
            print(
                f"  {t['tid']:2d} : {t.get('name','—')}  ({t.get('lang','und')}, {t.get('codec','—')})"
            )

    # ──────────────────────────────────────────────
    try:
        audio_choice = input("\nWhich AUDIO track to KEEP (TID number): ").strip()
        sub_choice = input(
            "Which SUBTITLE track to KEEP (TID number, or -1 / empty = drop all subs): "
        ).strip()

        audio_tid = int(audio_choice)
        sub_tid = int(sub_choice) if sub_choice and sub_choice != "-1" else -1

    except ValueError:
        print("Invalid number entered.", file=sys.stderr)
        return

    # Show decision
    print(f"\nDecision:")
    print(f"  Keep audio track    : {audio_tid}")
    print(f"  Keep subtitle track : {sub_tid if sub_tid >= 0 else 'NONE (drop all)'}")
    print()

    ok = input("Apply this to ALL .mkv files? [y/N] ").strip().lower()
    if ok not in ("y", "yes"):
        print("Aborted.")
        return

    # ──────────────────────────────────────────────
    for file in sorted(mkvs):
        basename = file.stem
        temp = file.with_name(f"temp_{file.name}")

        print(f"Remuxing: {file.name}")

        cmd = ["mkvmerge", "-o", str(temp)]

        # Keep only selected audio track
        cmd += ["--audio-tracks", str(audio_tid)]

        if sub_tid >= 0:
            cmd += ["--subtitle-tracks", str(sub_tid)]
        else:
            cmd += ["--no-subtitles"]

        cmd += [str(file)]

        try:
            run(cmd)
            if temp.exists():
                file.unlink()
                temp.rename(file)
                print("  → done")
            else:
                print("  → failed (no output file)")
        except Exception as e:
            print(f"  → error: {e}")
            if temp.exists():
                temp.unlink()


if __name__ == "__main__":
    main()
