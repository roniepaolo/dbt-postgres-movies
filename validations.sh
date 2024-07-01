#!/bin/bash

# This bash script performs validations in dbt models.
# It ensures that the specified fields in the YAML structure meet certain
# conditions.

set -euo xtrace

# Only run when models exist
if [ "$#" -lt 1 ]; then
	echo "No models read."
	echo "Usage: $0 <models_files>..."
	exit 1
fi

models_files=("$@")

# Validations
for file in "${models_files[@]}"; do
	echo "--"
	echo "Validation for $file"
	echo "Check mandatory fields (name, description, and columns)"
	yq eval \
		'["name", "description", "columns"] - (.models.[0] | keys) | length == 0' \
		"$file" --exit-status --no-doc

	echo "Check that the name is not empty"
	yq eval \
		'.models.[0].name | length > 0' \
		"$file" --exit-status --no-doc

	echo "Check that the description is not empty"
	yq eval \
		'.models.[0].description | length > 0' \
		"$file" --exit-status --no-doc

	echo "Check if columns have a name"
	yq eval \
		'[.models.[0].columns[] | has("name")] | all' \
		"$file" --exit-status --no-doc

	echo "Check if columns have a description"
	yq eval \
		'[.models.[0].columns[] | has("description")] | all' \
		"$file" --exit-status --no-doc

	echo "Check that column names are not empty"
	yq eval \
		'.models.[0].columns | all_c(.name | length > 0)' \
		"$file" --exit-status --no-doc

	echo "Check that column descriptions are not empty"
	yq eval \
		'.models.[0].columns | all_c(.description | length > 0)' \
		"$file" --exit-status --no-doc
done
