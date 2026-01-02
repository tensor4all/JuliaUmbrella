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
- When updating multiple interdependent packages, use `[sources]` entries in Project.toml for local development (see below)
- Never push directly to main branch - all changes via pull requests
- Always save test output to files when debugging

## Package Management

Each directory is an independent Julia package with its own `Project.toml`, `src/`, `test/`, and `docs/` directories. Packages are managed as separate git repositories, allowing for independent versioning and development.

### Using `[sources]` for Local Development

For T4A packages that depend on other T4A packages, add a `[sources]` section in Project.toml pointing to local paths during development:

```toml
[sources]
T4ATensorTrain = {path = "../T4ATensorTrain.jl"}
T4AMatrixCI = {path = "../T4AMatrixCI.jl"}
```

**Important**: `[sources]` entries are for local development only. **Always remove `[sources]` from Project.toml before committing.**

### Updating Multiple Interdependent Packages

When you need to update many Julia packages that depend on each other (for example, after bumping an upstream package version), it is best to update and verify everything locally before pushing changes upstream.

(a) Add `[sources]` entries in each package's `Project.toml` pointing to local paths for development.

(b) Update all packages in dependency order. Commit changes to local working branches but do not push yet. Include version bumps in these commits.

(c) Verify that all packages pass tests and documentation builds locally.

(d) Starting from the most upstream package, update its version number in `Project.toml` and those of its downstream packages, push the branch (you do not have to rerun tests locally), create a PR, and merge after CI passes. After each merge, register the new version to T4ARegistry using `T4ARegistrator.jl`. Then proceed to the next downstream package.

**If a problem occurs during step (d)**: If any package fails CI or encounters issues during this phase, go back to step (a) for that package and all its downstream dependencies. Fix the issue locally and verify all affected packages pass tests before attempting to push again. Always strive to maintain local consistency before pushing to remote.

## Creating New Packages

To create a new package following tensor4all conventions, use [T4ATemplate.jl](https://github.com/tensor4all/T4ATemplate.jl).

### Installation

```bash
cd T4ATemplate.jl
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### Basic Usage

Create a new package named `MyPkg.jl`:

```bash
julia --project=. generate.jl MyPkg.jl
```

Or using the module directly:

```julia
julia> using T4ATemplate
julia> T4ATemplate.generate("MyPkg.jl")
```

### Advanced Options

Create a package with TensorCrossInterpolation as a dependency:

```bash
julia --project=. generate.jl MyPkg.jl --include-tci
```

Specify a different GitHub user/organization:

```bash
julia --project=. generate.jl MyPkg.jl --user myusername
```

### Generated Package Features

The template generates a package with:
- Test.jl-based tests with Aqua and JET code quality checks
- Documenter.jl documentation scaffold
- GitHub Actions CI with multiple Julia versions (1.9, LTS, latest)
- CompatHelper and TagBot automation
- JuliaFormatter configuration (SciML style)
- AGENTS.md with development guidelines

### Post-Creation Steps

1. **Create GitHub repository**:
   ```bash
   gh repo create tensor4all/MyPkg.jl --public --description "Julia package for tensor4all" --clone=false
   ```

2. **Push to GitHub**:
   ```bash
   cd MyPkg.jl
   git push -u origin main
   ```

3. **Add to JuliaUmbrella** (if using umbrella repository):
   Add the repository name to `git_clone_all.sh` and re-run the script.

4. **Enable GitHub Pages** for documentation (Settings → Pages)

5. **Set up DOCUMENTER_KEY** (optional but recommended) for automatic documentation deployment

For more details, see the [T4ATemplate.jl README](https://github.com/tensor4all/T4ATemplate.jl).

## Package Registration with T4ARegistry

Most tensor4all packages are registered in [T4ARegistry](https://github.com/tensor4all/T4ARegistry), a custom Julia registry. For detailed instructions on:

- Adding T4ARegistry to your Julia installation
- Installing packages from T4ARegistry
- Registering new packages
- Updating package versions

See the [T4ARegistrator.jl README](https://github.com/tensor4all/T4ARegistrator.jl).

**Note**: Some packages (e.g., `TensorCrossInterpolation`, `QuanticsGrids`, `QuanticsTCI`) are registered in the official Julia General registry. For these, use JuliaHub to register new versions. See the [T4ARegistry README](https://github.com/tensor4all/T4ARegistry) for details.

## Related Documentation

- [AGENTS.md](AGENTS.md) - Development guidelines and conventions
- [CLAUDE.md](CLAUDE.md) - Repository overview and structure for AI agents
- [git_clone_all.sh](git_clone_all.sh) - Script to clone all T4A repositories

## Links

- [tensor4all GitHub organization](https://github.com/tensor4all)
- [T4ARegistry](https://github.com/tensor4all/T4ARegistry) - Custom Julia registry for tensor4all packages
