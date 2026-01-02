# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an umbrella repository for [tensor4all](https://github.com/tensor4all) Julia packages. Each subdirectory is an independent git repository containing a Julia package with its own `Project.toml`, `src/`, `test/`, and `docs/` directories.

Before working on any package, read the root `README.md` and `AGENTS.md`. If the package has its own `AGENTS.md`, read that too.

## Running Tests

Always redirect test output to files for debugging:

```bash
# Standard test framework
julia --project=. test/runtests.jl 2>&1 | tee test_output.log

# ReTestItems packages (Quantics.jl, QuanticsGrids.jl, TreeTCI.jl, SimpleTensorTrains.jl)
julia --project=. -e "using ReTestItems; runtests(\"test/specific_test.jl\")" 2>&1 | tee test_output.log
```

## Cross-Package Development

For packages depending on other T4A packages, add `[sources]` entries in `Project.toml` for local development:

```toml
[sources]
T4ATensorTrain = {path = "../T4ATensorTrain.jl"}
```

**Always remove `[sources]` before committing** - these are for local development only.

When updating interdependent packages: update in dependency order, verify tests locally, then push/merge starting from the most upstream package.

## Critical Rules

- **Never push directly to main** - all changes via pull requests
- **Never commit test dependencies to `[deps]`** - tools like Aqua.jl and JET.jl added during testing must be removed from Project.toml before committing
- **Review Project.toml changes after testing** - use `git diff Project.toml` to catch accidental dependency promotions
- **Aqua/JET in CI** - these run only on latest Julia version; set `SKIP_AQUA_JET` env var for other versions
- **Formatting** - follow `.JuliaFormatter.toml` if present (SciML style)

## Package Registration

- T4A packages: use T4ARegistrator.jl to register in T4ARegistry
- General registry packages (TensorCrossInterpolation, QuanticsGrids, QuanticsTCI): comment `@JuliaRegistrator register` in the repo's issue
