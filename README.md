# db.sh - Append-only Bash database

Roughly based on an example in Martin Kleppmann's book [Designing Data-Intensive Applications](https://dataintensive.net/).

Additional, unique feature: The database file itself is also a valid Bash script 🤪🥴.

## How does it work?

Startup: The database file is "sourced" to evaluate all assignments from previous runs.

Write operations: Write operations are specified in the form of a Bash variable assigment instruction.  
This instruction is 1) executed with `eval` and 2) appended to the database file.

Read operations: Read operations are specified simply as the variable name.  
This variable is printed using `eval "printf '%s\n' ..."`.

All variables are internally prefixed with `dbsh_`, to avoid overwriting predefined variables.


Examples:

```bash
# Write command:
myvar="\"That's a hell of a database\", he said."
# ...is executed as:
eval dbsh_myvar="\"That's a hell of a database\", he said."
echo dbsh_myvar="\"That's a hell of a database\", he said." >> "$db_file"

# Read command:
myvar
# ...is executed as:
printf eval "printf '%s\n' \"$dbsh_myvar\""
```

## Is this safe?

This code is using `eval`. Can this be safe?

```bash
./db.sh -c "safe=Yes \"No, of course not...\""
./db.sh: line 62: No, of course not...: command not found
```

Since this seems too dangerous, the option `-k` was added.  
The code then follows mostly the example from the book.  
This avoids 99% of the security issues, but doesn't store the database as real a Bash script any more.

## Should I use it in production?

If you currently use a Powershell script as your database, then it could be an improvement.

Otherwise, use it only if you like databases that allow arbitrary code execution.
