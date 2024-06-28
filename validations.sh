#!/usr/bin/env bash

set -eux

if [ "$#" -lt 1 ]; then
	echo "No models read."
	echo "Usage: $0 <models_files>..."
	exit 1
fi

models_files="$*"

echo $models_files

# # Check mandatory fields (name, description, and columns)
# yq eval \
#   '["name", "description", "columns"] - (.models.[0] | keys) | length == 0' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
#
# # Check name is not empty
# yq eval \
#   '.models.[0].name | length > 0' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
#
# # Check description is not empty
# yq eval \
#   '.models.[0].description | length > 0' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
#
# # Check if columns has name
# yq eval \
#   '[.models.[0].columns[] | has("name")] | all' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
#
# # Check if columns has description
# yq eval \
#   '[.models.[0].columns[] | has("description")] | all' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
#
# # Check if column name is not empty
# yq eval \
#   '.models.[0].columns | all_c(.name | length > 0)' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
#
# # Check if column description is not empty
# yq eval \
#   '.models.[0].columns | all_c(.description | length > 0)' \
#   ${{ steps.get_file_changes.outputs.models_files }} --exit-status
