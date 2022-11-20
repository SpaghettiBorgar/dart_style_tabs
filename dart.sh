#!/usr/bin/env bash

# Script that can be used to hook "dart format" to use a custom dart formatter
# Requirements:
#  - put this script somewhere in your PATH so that it's callable using just "dart"
#  - have the dart formatter available as "dartfmt"

SCRIPT_PATH=$(realpath "$0")

mapfile -t DART_PATHS < <( which -a dart )
DART_PATHS+=('/opt/flutter/bin/dart')
DART_PATHS+=('/opt/dart-sdk/bin/dart')

for path in "${DART_PATHS[@]}"; do
	ABS_PATH="$(realpath "$path")"
	if [ "$ABS_PATH" != "$SCRIPT_PATH" ] && [ -f "$ABS_PATH" ]; then
		DART_EXE=$path
		break;
	fi
done

if [[ ! -v DART_EXE ]]; then
	echo "No valid dart executable found"
	exit
fi

if [[ "$1" == "format" ]]; then
	shift
	dartfmt "$@"
else
	$DART_EXE "$@"
fi
