- Before starting work, read the repository root `README.md` as well as this `AGENTS.md`.

- Use the same language as in past conversations with the user (if it has been Japanese, use Japanese)

- All source code and documentation must be in English

- Each subdirectory is a git repository. If there is an AGENTS.md in each directory, read it when working on the corresponding library

- Each of some of the git repositories is an independent Julia package with its own Project.toml, src/, test/, and docs/ directories. Understand the package structure before making changes

- When working on a git repository, navigate into its directory and work as if it were a standalone package. Be aware of dependencies between packages

- **Running tests**: T4A packages use two test frameworks depending on their needs:
  - **ReTestItems**: For packages that don't use Distributed (e.g., T4AQuantics.jl, QuanticsGrids.jl)
  - **Standard Test.jl**: For packages that use Distributed for parallel computation (e.g., T4APartitionedTT.jl, T4ATCIAlgorithms.jl)

  **Full test suite** - Use `Pkg.test()` for both frameworks:
  ```bash
  julia --project=. -e "using Pkg; Pkg.test()" 2>&1 | tee test_output.log
  ```
  This automatically sets up test dependencies without modifying `Project.toml`.

  **Running specific tests for debugging**:

  For **ReTestItems packages** (check if `test/runtests.jl` uses `ReTestItems`):
  ```bash
  # Requires ReTestItems to be installed first
  julia --project=. -e "using ReTestItems; runtests(\"test/specific_tests.jl\")" 2>&1 | tee test_specific.log

  # Filter by test name (regex supported)
  julia --project=. -e "using ReTestItems; runtests(\"test/\"; name=\"test_name\")" 2>&1 | tee test_specific.log
  ```

  For **standard Test.jl packages** (check if `test/runtests.jl` uses `include`):
  ```bash
  # Include the specific test file directly
  julia --project=. -e "
    using PkgName  # Replace with actual package name
    using Test
    include(\"test/_util.jl\")  # If test utilities exist
    include(\"test/specific_tests.jl\")
  " 2>&1 | tee test_specific.log
  ```

  **Note**: Running specific tests directly requires test dependencies (ReTestItems, etc.) to be installed. If you install them in the project environment, `Project.toml` will be modified - revert these changes before committing.

  **Always save test output to files** using `tee` for debugging.

- **Handling Project.toml changes during testing**: If `Pkg.add` or similar operations during testing modify `Project.toml`, **always review the changes carefully** before committing:
  - First, use `git diff Project.toml` to see exactly what was added or changed
  - **Never** use `git checkout Project.toml` or `git checkout Manifest.toml` to blindly revert changes
  - Understand the diff, then manually remove only the unnecessary parts
  - **Never commit changes that promote test dependencies or weak dependencies to strong dependencies** - this is strictly forbidden. Test dependencies should remain in `[compat]` or `[extras]` sections, and weak dependencies should not be moved to `[deps]`
  - **Common issue**: Tools like Aqua.jl, JET.jl, etc. are often accidentally added to `Project.toml` during testing. However, when using `Pkg.test()`, these test tools are automatically available as test dependencies and should **not** be added to `[deps]`. If they appear in `Project.toml` after testing, remove them manually.

- **Handling Aqua and JET in CI**: For packages that use Aqua.jl and JET.jl for code quality checks, follow these guidelines to avoid version compatibility issues:
  - **Rationale**: Aqua and JET checks have strong Julia version dependencies. Debugging compatibility issues in CI environments is time-consuming, so it's better to run these checks only locally and on the latest Julia version in CI.
  - **CI configuration**: Run tests on both LTS and latest ('1') Julia versions
  - **Environment variable**: Set `SKIP_AQUA_JET` environment variable for non-latest versions (e.g., `SKIP_AQUA_JET: ${{ matrix.version != '1' && 'true' || '' }}` in GitHub Actions)
  - **Test script**: In `test/runtests.jl`, use conditional logic to dynamically install and run Aqua/JET tests:
    ```julia
    # Run Aqua and JET tests when not explicitly skipped
    if !haskey(ENV, "SKIP_AQUA_JET")
        using Pkg
        Pkg.add("Aqua")
        Pkg.add("JET")
        include("test_with_aqua.jl")
        include("test_with_jet.jl")
    end
    ```
  - **Project.toml**: Do **not** add Aqua or JET to `[deps]` or `[targets].test`. Keep them in `[extras]` if needed for documentation, but they should be installed dynamically in the test script when needed.
  - This approach ensures that Aqua and JET are only installed and run on compatible Julia versions, avoiding dependency resolution issues in CI.

- **CI.yml rollup job verification**: When working on a package, verify that `.github/workflows/CI.yml` includes a `rollup` job that aggregates test and docs job results. The rollup job should:
  - Have `needs: [test, docs]` (or appropriate job names)
  - Use `if: always()` to run regardless of previous job results
  - Check for both `failure` and `cancelled` statuses: `contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')`
  - If the rollup job is missing or incorrectly configured, propose updating the CI.yml to match the template in `T4ATemplate.jl/template/CI.yml`

- **Branch protection and auto merge verification**: Use `gh` command to verify that branch protection rules are properly configured and auto merge is enabled:
  ```bash
  # Check if auto merge is enabled
  gh api /repos/OWNER/REPO --jq '.allow_auto_merge'
  
  # Check branch protection rules
  gh api /repos/OWNER/REPO/branches/main/protection --jq '{required_status_checks, allow_auto_merge: .required_status_checks.checks[0].context}'
  ```
  If auto merge is not enabled or branch protection is missing the rollup job check, propose enabling auto merge and updating branch protection rules:
  ```bash
  # Enable auto merge
  gh api --method PATCH /repos/OWNER/REPO -f allow_auto_merge=true
  
  # Set branch protection with CI check requirement
  gh api --method PUT /repos/OWNER/REPO/branches/main/protection -f required_status_checks='{"strict": true, "contexts": ["CI"]}' -f enforce_admins=false
  ```

- If a package has a `.JuliaFormatter.toml` file, follow its formatting rules. Otherwise, follow standard Julia style guidelines

- When making changes that affect multiple packages, consider the dependency graph and test affected packages accordingly

- The `gh` (GitHub CLI) command is available locally and can be used for GitHub-related operations. If `gh` is not available, suggest the user to install it

- **Never push directly to main branch**: All changes must be made through pull requests. Create a branch, commit changes, push the branch, and create a PR. Wait for CI workflows to pass before merging.

- **Never use force push to main branch**: Force pushing (including `--force-with-lease`) to main is prohibited. If you need to rewrite history, do it on a feature branch and create a PR.

- All libraries are under the [tensor4all GitHub organization](https://github.com/tensor4all)

- Some libraries are registered in T4ARegistry. Use T4ARegistrator.jl to register them. T4ARegistrator.jl is a development tool that should be installed in the global environment, not added as a dependency in individual package Project.toml files. When manually registering packages in T4ARegistry, use HTTPS URLs (not SSH) in the `repo` field of Package.toml to ensure compatibility in environments without SSH access

- Some libraries are already registered in the official Julia registry. To register a new version, comment `@JuliaRegistrator register` in the library's issue, and the bot will create a PR to the official registry

- **Using `[sources]` for local development**: For T4A packages that depend on other T4A packages, add a `[sources]` section in Project.toml pointing to local paths during development. This enables seamless local development across interdependent packages.
  ```toml
  [sources]
  T4ATensorTrain = {path = "../T4ATensorTrain.jl"}
  T4AMatrixCI = {path = "../T4AMatrixCI.jl"}
  ```
  **Important**: `[sources]` entries are for local development only. **Always remove `[sources]` from Project.toml before committing.** The `[sources]` section should never be pushed to the repository.

---

**Note for maintainers**: If this file (`AGENTS.md`) is updated and differs from `T4ATemplate.jl/template/AGENTS.md`, please copy the changes to the template file so that new packages generated with T4ATemplate.jl will include the updated guidelines.