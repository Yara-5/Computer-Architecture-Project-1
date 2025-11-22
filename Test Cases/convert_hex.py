#!/usr/bin/env python3
import sys
import os

def convert_file(input_file):
    # Derive output filename: Testcase3.hex -> Testcase3_bytes.hex
    base, ext = os.path.splitext(input_file)
    output_file = base + "_bytes.hex"

    # Read input lines
    with open(input_file) as f:
        lines = f.read().strip().splitlines()

    out = []
    for line in lines:
        line = line.strip()
        if line == "":
            continue
        word = int(line, 16)

        # Little-endian byte split
        b0 = (word >> 0)  & 0xff
        b1 = (word >> 8)  & 0xff
        b2 = (word >> 16) & 0xff
        b3 = (word >> 24) & 0xff

        out += [
            f"{b0:02x}",
            f"{b1:02x}",
            f"{b2:02x}",
            f"{b3:02x}"
        ]

    # Write output
    with open(output_file, "w") as f:
        f.write("\n".join(out))

    print(f"Converted ? {output_file}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 convert_hex.py <inputfile.hex>")
        sys.exit(1)

    convert_file(sys.argv[1])
