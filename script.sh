#!/usr/bin/env bash
set -euo pipefail

INFILE=""
NAME=""
OUTFILE="usernames.txt"

usage() {
    echo "Usage: $0 (-i INFILE | -N NAME) [-o OUTFILE]"
    echo
    echo "  -i INFILE   input file containing a list of names (one per line)"
    echo "  -N NAME     a single name to generate usernames for (enclosed in quotes)"
    echo "  -o OUTFILE  output file to write generated usernames to (default: usernames.txt)"
    exit 1
}

while getopts "i:N:o:h" opt; do
    case "$opt" in
        i) INFILE="$OPTARG" ;;
        N) NAME="$OPTARG" ;;
        o) OUTFILE="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -n "$INFILE" && -n "$NAME" ]]; then
    echo "Error: -i and -N are mutually exclusive" >&2
    exit 1
fi
if [[ -z "$INFILE" && -z "$NAME" ]]; then
    echo "Error: one of -i or -N is required" >&2
    usage
fi

if [[ -n "$INFILE" ]]; then
    if [[ ! -f "$INFILE" ]]; then
        echo "input file '$INFILE' does not exist"
        exit 1
    fi
    mapfile -t LINES < "$INFILE"
else
    LINES=("$NAME")
fi

declare -A SEEN
RESULT=()

add_name() {
    local n="$1"
    if [[ -z "${SEEN[$n]:-}" ]]; then
        SEEN["$n"]=1
        RESULT+=("$n")
    fi
}

for line in "${LINES[@]}"; do
    line="$(echo -n "$line" | xargs)"   # trim whitespace
    [[ -z "$line" ]] && continue

    read -ra PARTS <<< "$line"
    count=${#PARTS[@]}

    if (( count > 3 )); then
        echo "skipping '$line': mangling more than first/middle/last unsupported"
        continue
    fi

    first="${PARTS[0],,}"
    last="${PARTS[$((count-1))],,}"
    first_i="${first:0:1}"
    last_i="${last:0:1}"

    add_name "${first}.${last}"
    add_name "${first}${last}"
    add_name "${first_i}.${last}"
    add_name "${first_i}${last}"
    add_name "${first}.${last_i}"
    add_name "${first}_${last}"
    add_name "${first}"
    add_name "${last}"

    if (( count == 3 )); then
        middle="${PARTS[1],,}"
        middle_i="${middle:0:1}"

        add_name "${first}${middle_i}.${last}"
        add_name "${first}${middle_i}${last}"
        add_name "${first_i}${middle_i}${last}"
        add_name "${first_i}${middle_i}.${last}"
        add_name "${first_i}.${middle_i}.${last}"
        add_name "${first}.${middle_i}.${last_i}"
        add_name "${first}_${middle_i}_${last}"
    fi
done

SORTED=($(printf '%s\n' "${RESULT[@]}" | sort))

if [[ -n "$OUTFILE" ]]; then
    printf '%s\n' "${SORTED[@]}" > "$OUTFILE"
    echo "wrote ${#SORTED[@]} usernames to '$OUTFILE'"
else
    printf '%s\n' "${SORTED[@]}"
fi
