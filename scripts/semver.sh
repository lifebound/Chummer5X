#!/bin/bash
# Usage: ./scripts/semver.sh 1.2.3+45 1.3.0
# Output: 1.3.0+46

prev="$1"
next="$2"

prev_build=$(echo "$prev" | cut -d'+' -f2)
next_build=$((prev_build + 1))

echo "${next}+${next_build}"
