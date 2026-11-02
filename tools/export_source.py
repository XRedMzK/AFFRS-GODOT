#!/usr/bin/env python3
"""Package the public source files without assets or local Git history."""

import argparse
from pathlib import Path
import tempfile
import zipfile


ROOT = Path(__file__).resolve().parent.parent
ROOT_FILES = (
    ".editorconfig",
    ".gitattributes",
    ".gitignore",
    "README.md",
    "project.godot",
    "scripts/perf/README.md",
    "tools/export_source.py",
)
SOURCE_PATTERNS = {
    "scripts": ("*.gd", "*.gd.uid"),
    "scenes": ("*.tscn",),
    "shaders": ("*.gdshader", "*.gdshader.uid"),
}
PRIVATE_DIRS = {"__pycache__", "assets", "android", "build", "dist"}
STALE_UIDS = {"scripts/__MenuSmoke.gd.uid"}


def source_paths():
    paths = {ROOT / name for name in ROOT_FILES}
    for directory, patterns in SOURCE_PATTERNS.items():
        for pattern in patterns:
            for path in (ROOT / directory).rglob(pattern):
                relative = path.relative_to(ROOT)
                if any(
                    part.startswith(".") or part in PRIVATE_DIRS
                    for part in relative.parts[:-1]
                ):
                    continue
                if relative.as_posix() not in STALE_UIDS:
                    paths.add(path)
    return sorted(paths)


def validate(path):
    relative = path.relative_to(ROOT)
    if any(parent.is_symlink() for parent in (path, *path.parents) if parent != ROOT):
        raise ValueError(f"Symbolic links are not allowed: {relative}")
    if not path.is_file():
        raise ValueError(f"Missing source file: {relative}")
    data = path.read_bytes()
    if b"\0" in data:
        raise ValueError(f"Binary content is not allowed: {relative}")
    data.decode("utf-8")
    if path.suffix == ".uid" and not path.with_suffix("").is_file():
        raise ValueError(f"UID without a source file: {relative}")
    return data


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="list and validate only")
    parser.add_argument(
        "--output", type=Path, default=ROOT / "dist" / "AFFRS-GODOT-source.zip"
    )
    args = parser.parse_args()
    try:
        files = [(path.relative_to(ROOT).as_posix(), validate(path)) for path in source_paths()]
        if args.check:
            for name, _ in files:
                print(name)
        else:
            output = args.output.resolve()
            if output.is_relative_to(ROOT) and not output.is_relative_to(ROOT / "dist"):
                raise ValueError("Inside the project, write archives only to dist/")
            output.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.TemporaryDirectory(dir=output.parent) as temporary:
                archive = Path(temporary) / "source.zip"
                with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as package:
                    for name, data in files:
                        package.writestr(f"AFFRS-GODOT-source/{name}", data)
                archive.replace(output)
            print(f"Created: {output}")
        print(f"Validated {len(files)} source files ({sum(len(data) for _, data in files)} bytes).")
    except (OSError, ValueError) as error:
        parser.exit(1, f"Source export failed: {error}\n")


if __name__ == "__main__":
    main()
