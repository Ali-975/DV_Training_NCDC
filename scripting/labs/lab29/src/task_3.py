#!/usr/bin/env python3

import os
from pathlib import Path

# list of subdirectories to create
DIRS = ["rtl", "tb", "scripts", "docs", "synthesis", "simulation"]

def create_directories(base_path="../"):
    # absolute path to the 'files' folder
    files_dir = Path(base_path) / "files"
    files_dir.mkdir(exist_ok=True)

    print(f"\nBase directory: {files_dir.resolve()}\n")

    for d in DIRS:
        target = files_dir / d
        if target.exists():
            print(f"{target } is already exists")
        else:
            target.mkdir(parents=True)
            print(f"{target} created successfully!")

if __name__ == "__main__":
    # Run from anywhere; creates 'files' in the current working directory
    create_directories()
    print("")
