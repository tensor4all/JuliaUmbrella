# JuliaUmbrella

An umbrella repository for [tensor4all](https://github.com/tensor4all) Julia packages, designed to enable AI agents to work across multiple packages efficiently.

## Purpose

This repository manages tensor4all Julia packages as git submodules, providing a unified workspace for cross-package development and maintenance. It is specifically designed to facilitate AI agent workflows that need to understand and modify code across multiple related packages.

## Setup

Clone the repository and initialize all submodules:

```bash
git clone git@github.com:tensor4all/JuliaUmbrella.git
cd JuliaUmbrella
git submodule update --init --recursive
```

## Development Guidelines

See [AGENTS.md](AGENTS.md) for development guidelines and conventions when working with packages in this repository.

## Package Management

Submodules are managed dynamically. To see the current list of packages, check `.gitmodules` or list the subdirectories. Each subdirectory is an independent Julia package with its own `Project.toml`, `src/`, `test/`, and `docs/` directories.

## Creating New Packages

To create a new package following tensor4all conventions, use [T4ATemplate.jl](https://github.com/tensor4all/T4ATemplate.jl).
