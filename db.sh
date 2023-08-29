#!/bin/bash
set -e

echo2() {
    echo "$@" >&2
}

db_file="$HOME/.config/db.sh.data"
cmd_cli=
verbose=0

while [[ "$1" != "" ]]; do
    if [ "$1" = "-c" ]; then
        cmd_cli="$2"
        shift
        shift
    elif [ "$1" = "-v" ]; then
        verbose=1
        shift
    elif [ "$1" = "--db" ]; then
        db_file="$2"
        shift
        shift
    else
        echo "ERROR: Unknown option '$1'"
        exit 1
    fi
done

db_dir="$( dirname "$db_file" )"
echo2 "Reading persistent data from \"$db_file\"..."
if [ -f "$db_file" ]; then
    if [ "$verbose" = 1 ]; then
        cat "$db_file" >&2
    fi
    . "$db_file"
    echo2 "Done."
else
    echo2 "File not found. -> Starting with empty database."
    mkdir -pv "$db_dir"
fi

if [ "$cmd_cli" = "" ]; then
    echo2
    echo2 "QUICK REFERENCE:"
    echo2 "HOW TO WRITE: var=value_no_spaces  OR  var=\"value\"  OR  var='value' (with Bash quoting rules)."
    echo2 "HOW TO READ:  var"
    echo2 "CLI WRITE:    ./db.sh -c \"var=\\\"hello world\\\"\""
    echo2 "CLI READ:     ./db.sh -c \"var\""
fi

while true; do
    if [ "$cmd_cli" != "" ]; then
        echo2
        cmd="$cmd_cli"
    else
        echo2; echo2 "Command?"
        read -er cmd
    fi
    if [ "$cmd" = "" ]; then
        continue
    fi

    if [[ "$cmd" =~ = ]]; then
        echo2 "WRITE $cmd"
        # Save for current process:
        eval "dbsh_$cmd"
        # Save for next run:
        echo "dbsh_$cmd" >> "$db_file"
    else
        echo2 "READ $cmd"
        eval "printf '%s\n' \"\$dbsh_$cmd\""
    fi
    if [ "$cmd_cli" != "" ]; then
        exit
    fi
done
