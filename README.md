# AWS Solutions Architect Labs

This repository hosts subfolders (often Git submodules) containing Terraform scripts and related assets used for AWS Solutions Architect study labs.

## Structure
- Each lab lives in its own folder under the repository root.
- Prefer keeping reusable Terraform modules under a dedicated `modules/` folder or within each lab folder as needed.

## Getting Started
1. Create a new lab folder, e.g., `lab-ec2-basics/`.
2. Initialize Terraform inside that lab folder and manage state there.
3. Keep sensitive values in `*.tfvars` files and never commit them (already ignored).

## Submodules (optional)
If a lab lives in another repo, add it as a submodule:

```bash
git submodule add <repo_url> <path>
```

Then update submodules when needed:

```bash
git submodule update --init --recursive
```

## Notes
- `.gitignore` is set up for Terraform projects to avoid committing state and secrets.
- Use separate AWS profiles or environments per lab if helpful.
