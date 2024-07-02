#!/bin/bash

# This Bash script performs validations in dbt models.
# It ensures that the specified fields in the YAML structure meet certain
# conditions.

set -euo xtrace

# Only run when models exist
if [[ $# -lt 1 ]]; then
	echo 1>&2 "No models read."
	echo 1>&2 "Usage: $0 <models_files>..."
	exit 1
fi

check-file() {
	local input=$1
	local title=$2
	local yqexpr=$3

	printf '%s\n' "$title"
	yq eval "$yqexpr" "$input" --exit-status --no-doc
}

for f in "$@"; do
	check-file "$f" "Check mandatory fields (name, description, and columns)" \
		'["name", "description", "columns"] - (.models.[0] | keys) | length == 0'

	check-file "$f" "Check that the name is not empty" \
		'.models.[0].name | length > 0'

	check-file "$f" "Check that the description is not empty" \
		'.models.[0].description | length > 0'

	check-file "$f" "Check if columns have a name" \
		'[.models.[0].columns[] | has("name")] | all'

	check-file "$f" "Check if columns have a description" \
		'[.models.[0].columns[] | has("description")] | all'

	check-file "$f" "Check that column names are not empty" \
		'.models.[0].columns | all_c(.name | length > 0)'

	check-file "$f" "Check that column descriptions are not empty" \
		'.models.[0].columns | all_c(.description | length > 0)'
done
