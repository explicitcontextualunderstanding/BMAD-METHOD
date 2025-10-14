#!/usr/bin/env python3
"""
Concatenate a specific ordered list of documentation artifacts into a single text file
with no filtering or transformation of the file contents.

By default this script concatenates the project documentation files used by the
Nanosaur `bmad` workflow. It writes raw bytes from each file to the output file,
adding a single newline between files to avoid accidental run-together.

Usage:
  ./concat_docs.py                          # uses embedded list, writes ./combined_docs.txt
  ./concat_docs.py --output out.txt         # specify output file
  ./concat_docs.py --no-sep                 # do not write an extra newline between files
  ./concat_docs.py --files file1 file2 ...  # override the embedded list
  ./concat_docs.py --abort-on-missing       # error and exit if any input file is missing

This intentionally performs no filtering, rewriting, or Markdown-to-text conversion.
"""

from pathlib import Path
import argparse
import sys

DEFAULT_FILES = [
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/PRD-openvla.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/product-brief-openvla-2025-10-06.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/bmad-assessment-openvla.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/epic-0.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/tech-spec-epic-0.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/tech-spec-epic-1.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/tech-spec-epic-2.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/tech-spec-epic-3.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/tech-spec-epic-4.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/docs/tech-spec-epic-5.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/solution-architecture.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/implementation-guidance.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/architecture-diagrams.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/architecture-quality-assessment.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/ngc-container-implementation.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/model_optimization_research.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/OpenVLA-OFT_architecture.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/OpenVLA-argument-map.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/jetson-memory-analysis.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/ngc-container-troubleshooting.md",
    "/Users/kieranlal/workspace/BMAD-METHOD/research/dustys-learnings-integration.md",
]


def parse_args():
    p = argparse.ArgumentParser(description="Concatenate documentation files into one text file (no filtering)")
    p.add_argument("--output", "-o", default="./combined_docs.txt", help="Output file path")
    p.add_argument("--files", "-f", nargs="*", help="Optional list of files to concatenate (overrides default list)")
    p.add_argument("--no-sep", action="store_true", help="Do not write an extra newline between concatenated files")
    p.add_argument("--abort-on-missing", action="store_true", help="Exit with error if any input file is missing")
    return p.parse_args()


def main():
    args = parse_args()
    files = args.files if args.files else DEFAULT_FILES
    out_path = Path(args.output)

    # Ensure parent directory exists
    if out_path.parent and not out_path.parent.exists():
        out_path.parent.mkdir(parents=True, exist_ok=True)

    missing = []
    with out_path.open("wb") as out:
        for idx, fp in enumerate(files):
            p = Path(fp)
            if not p.exists():
                sys.stderr.write(f"WARNING: input file not found: {p}\n")
                missing.append(str(p))
                if args.abort_on_missing:
                    sys.stderr.write("Aborting due to --abort-on-missing\n")
                    return 2
                # skip missing files when not aborting
                continue

            # Read and write raw bytes (no decoding or filtering)
            with p.open("rb") as src:
                data = src.read()
                out.write(data)

            # Add a single newline between files unless disabled
            if not args.no_sep:
                out.write(b"\n")

    if missing and not args.abort_on_missing:
        sys.stderr.write(f"Completed with missing files: {len(missing)} file(s) were not found.\n")

    print(f"Wrote concatenated file: {out_path} ({out_path.stat().st_size} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
