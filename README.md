# JuliaUmbrella

An umbrella repository for [tensor4all](https://github.com/tensor4all) Julia packages, designed to enable AI agents to work across multiple packages efficiently.

## Purpose

This repository provides a unified workspace for cross-package development and maintenance of tensor4all Julia packages. It is specifically designed to facilitate AI agent workflows that need to understand and modify code across multiple related packages.

## Quick Start

Use the `git_clone_all.sh` script to clone all T4A repositories and QuanticsGrids.jl:

```bash
# Clone all repositories to current directory
./git_clone_all.sh

# Or specify a target directory
./git_clone_all.sh /path/to/target/directory
```

The script clones the following repositories:
- **13 T4A repositories**: T4AAdaptivePatchedTCI.jl, T4AITensorCompat.jl, T4AMatrixCI.jl, T4AMPOContractions.jl, T4APartitionedTT.jl, T4APlutoExamples, T4AQuantics.jl, T4AQuanticsTCI.jl, T4ARegistrator.jl, T4ATCIAlgorithms.jl, T4ATemplate.jl, T4ATensorCI.jl, T4ATensorTrain.jl
- **QuanticsGrids.jl**

See the script for details on what each repository contains.

## Development Guidelines

See [AGENTS.md](AGENTS.md) for development guidelines and conventions when working with packages in this repository.

Key points:
- All source code and documentation must be in English
- Each subdirectory is an independent Julia package with its own `Project.toml`, `src/`, `test/`, and `docs/` directories
- When updating multiple interdependent packages, use `[sources]` entries in Project.toml for local development
- Never push directly to main branch - all changes via pull requests
- Always save test output to files when debugging

## Package Management

Each directory is an independent Julia package with its own `Project.toml`, `src/`, `test/`, and `docs/` directories. Packages are managed as separate git repositories, allowing for independent versioning and development.

### Using `[sources]` for Local Development

For T4A packages that depend on other T4A packages, it is **strongly recommended** to add a `[sources]` section in Project.toml pointing to local paths:

```toml
[sources]
T4ATensorTrain = {path = "../T4ATensorTrain.jl"}
TensorCrossInterpolation = {path = "../TensorCrossInterpolation.jl"}
```

**Benefits**:
- When local paths exist (e.g., in the umbrella repository), Julia uses the local versions automatically
- When local paths don't exist (e.g., in CI or user environments), Julia falls back to the registered versions from the registry
- No need to add/remove `[sources]` entries during development workflows
- Makes cross-package development and testing much smoother

## Creating New Packages

To create a new package following tensor4all conventions, use [T4ATemplate.jl](https://github.com/tensor4all/T4ATemplate.jl).

## Related Documentation

- [AGENTS.md](AGENTS.md) - Development guidelines and conventions
- [CLAUDE.md](CLAUDE.md) - Repository overview and structure for AI agents
- [git_clone_all.sh](git_clone_all.sh) - Script to clone all T4A repositories

## Links

- [tensor4all GitHub organization](https://github.com/tensor4all)
- [T4ARegistry](https://github.com/tensor4all/T4ARegistry) - Custom Julia registry for tensor4all packages
