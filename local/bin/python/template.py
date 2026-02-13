#!/usr/bin/env python3
# /// script
# requires-python = ">=3.9"
# dependencies = []
# ///

"""
short description what this tool does

Usage:
    mytool.py [options] <args>

Examples:
    ...
"""

from __future__ import annotations
import sys
from pathlib import Path
import argparse
from typing import NoReturn


def die(msg: str, code: int = 1) -> NoReturn:
    print(msg, file=sys.stderr)
    sys.exit(code)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    # parser.add_argument(...)

    args = parser.parse_args()

    # ── real code here ────────────────────────────────────────

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        # optionally: import traceback; traceback.print_exc()
        sys.exit(1)
