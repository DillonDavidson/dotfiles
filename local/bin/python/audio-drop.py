#!/usr/bin/env python3
import os, subprocess


def main():
    number = input("Which audio track are we keeping? ")

    for mkvfile in os.listdir("."):
        if mkvfile.endswith(".mkv"):
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
