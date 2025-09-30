#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <PC_value>"
    echo "Example: $0 0x1004"
    exit 1
fi

PC_VALUE="$1"
SOURCE_FILE="../files/core.txt"   # <-- correct relative path

# Method 1: Using grep and sed to extract instruction
echo "Method 1 - Using grep and sed:"
cat "$SOURCE_FILE" | grep "$PC_VALUE" | sed -E 's/[^,]*,([^,]*).*/\1/'
echo ""

# Method 2: Using awk for more precise extraction
echo "Method 2 - Using awk:"
awk -F',' -v pc="$PC_VALUE" '$1 ~ pc { print $2 }' "$SOURCE_FILE"
echo ""

# Method 3: Using grep with more specific pattern matching
echo "Method 3 - Using grep with pattern:"
grep "^$PC_VALUE," "$SOURCE_FILE" | cut -d',' -f2