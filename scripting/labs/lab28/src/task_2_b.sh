#!/bin/bash

SOURCE_FILE="../files/article.txt"

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE not found."
    exit 1
fi

echo

# 1. Filter words
FILTERED=$(grep -oE '\w+' "$SOURCE_FILE" \
    | tr '[:upper:]' '[:lower:]' \
    | grep 'a' \
    | grep -v 'i$')

TOTAL=$(echo "$FILTERED" | wc -l)
echo "Total qualifying words: $TOTAL"
echo

# 2. Three most common last-two letters
echo "Top 3 last-two-letter endings:"
echo "$FILTERED" \
    | awk '{print substr($0,length($0)-1)}' \
    | sort | uniq -c | sort -nr | head -3
echo

# 3. Count unique two-letter combinations
UNIQUE=$(echo "$FILTERED" \
    | awk 'length($0) > 1 {print substr($0,length($0)-1)}' \
    | sort -u | wc -l)
echo "Unique two-letter endings: $UNIQUE"
echo

# 4. Optional: list two-letter combinations that never occur
echo "Two-letter combinations that do NOT occur:"
comm -23 \
  <(for x in {a..z}; do for y in {a..z}; do echo "$x$y"; done; done | sort) \
  <(grep -oE '\w+' SOURCE_FILE.txt \
      | tr '[:upper:]' '[:lower:]' \
      | grep 'a' \
      | grep -v 'i$' \
      | awk 'length($0) > 1 {print substr($0, length($0)-1)}' \
      | sort -u) \
| paste -sd, -
