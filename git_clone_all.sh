#!/bin/bash

# Script to clone all T4A repositories and QuanticsGrids.jl
# Usage: ./git_clone_all.sh [target_directory]

set -e

# GitHub organization
ORG="tensor4all"

# Target directory (default: current directory)
TARGET_DIR="${1:-.}"

# List of T4A repositories
T4A_REPOS=(
    "T4AAdaptivePatchedTCI.jl"
    "T4AITensorCompat.jl"
    "T4AMatrixCI.jl"
    "T4AMPOContractions.jl"
    "T4APartitionedTT.jl"
    "T4APlutoExamples"
    "T4AQuantics.jl"
    "T4AQuanticsTCI.jl"
    "T4ARegistrator.jl"
    "T4ATCIAlgorithms.jl"
    "T4ATemplate.jl"
    "T4ATensorCI.jl"
    "T4ATensorTrain.jl"
)

# Additional repositories
OTHER_REPOS=(
    "QuanticsGrids.jl"
)

# All repositories
ALL_REPOS=("${T4A_REPOS[@]}" "${OTHER_REPOS[@]}")

echo "Cloning ${#ALL_REPOS[@]} repositories to ${TARGET_DIR}..."
echo ""

# Create target directory if it doesn't exist
mkdir -p "${TARGET_DIR}"

# Clone each repository
for repo in "${ALL_REPOS[@]}"; do
    repo_path="${TARGET_DIR}/${repo}"
    
    if [ -d "${repo_path}" ]; then
        echo "⚠️  ${repo} already exists, skipping..."
    else
        echo "📦 Cloning ${repo}..."
        git clone "git@github.com:${ORG}/${repo}.git" "${repo_path}" || {
            echo "❌ Failed to clone ${repo}"
            exit 1
        }
        echo "✅ ${repo} cloned successfully"
    fi
    echo ""
done

echo "🎉 All repositories cloned successfully!"
echo ""
echo "Summary:"
echo "  - T4A repositories: ${#T4A_REPOS[@]}"
echo "  - Other repositories: ${#OTHER_REPOS[@]}"
echo "  - Total: ${#ALL_REPOS[@]}"

