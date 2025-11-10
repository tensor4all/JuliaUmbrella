- Use the same language as in past conversations with the user (if it has been Japanese, use Japanese)

- All source code and documentation must be in English

- Each subdirectory is a submodule. If there is an AGENTS.md in each directory, read it when working on the corresponding library

- Each submodule is an independent Julia package with its own Project.toml, src/, test/, and docs/ directories. Understand the package structure before making changes

- When working on a submodule, navigate into its directory and work as if it were a standalone package. Be aware of dependencies between packages

- To update submodules after pulling changes, use `git submodule update --init --recursive`

- Run tests for a specific package by navigating to its directory and running `julia --project=. -e 'using Pkg; Pkg.test()'` or `julia --project=. test/runtests.jl`

- If a package has a `.JuliaFormatter.toml` file, follow its formatting rules. Otherwise, follow standard Julia style guidelines

- When making changes that affect multiple packages, consider the dependency graph and test affected packages accordingly

- The `gh` (GitHub CLI) command is available locally and can be used for GitHub-related operations

- Some libraries are registered in T4ARegistry. Use T4ARegistrator.jl to register them

- Some libraries are already registered in the official Julia registry. To register a new version, comment `@JuliaRegistrator register` in the library's issue, and the bot will create a PR to the official registry
