#!/bin/bash
set -e

db_file="$HOME/.config/db.sh.data"
db_dir="$( dirname "$db_file" )"
cmd_cli=

if [ "$1" = "-c" ]; then
    echo "COMMAND ARG: $2" >&2
    cmd_cli="$2"
    shift
    shift
fi

if [ -f "$db_file" ]; then
    echo "Reading persistent data..." >&2
    cat "$db_file" >&2
    . "$db_file"
else
    mkdir -pv "$db_dir"
fi

while true; do
    if [ "$cmd_cli" != "" ]; then
        cmd="$cmd_cli"
    else
        echo -n "> " >&2
        read -r cmd
    fi
    if [ "$cmd" = "" ]; then
        continue
    fi

    if [[ "$cmd" =~ = ]]; then
        echo "WRITE $cmd" >&2
        # Save for current process:
        eval "db_$cmd"
        # Save for next run:
        echo "db_$cmd" >> "$db_file"
    else
        echo "READ $cmd" >&2
        # echo "READ $cmd" >&2
        # echo eval "echo \"\$db_$cmd\""
        eval "echo \"\$db_$cmd\""
    fi
    if [ "$cmd_cli" != "" ]; then
        exit
    fi
done
