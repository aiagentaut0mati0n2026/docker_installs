# Contributing

Thank you for taking the time to improve this project.

---

## Reporting a Bug

Before you open an issue, check the existing issues to see if it has already been reported.

Include: your OS and version, the exact error message, relevant lines from `~/docker-script-install.log`, and the application you were trying to install.

```bash
cat ~/docker-script-install.log
```

---

## Requesting a New Application

Open an issue with the label `feature-request` and include the application name, a Docker Hub link, a sample compose snippet, the ports used, and whether it needs a `.env` file.

---

## Submitting a Change

1. Fork the repository on GitHub.
2. Create a branch: `git checkout -b fix/description`
3. Validate YAML: `python3 -c "import yaml; yaml.safe_load(open('file.yml'))" && echo VALID`
4. Validate bash: `bash -n install_docker_nproxyman.sh && echo OK`
5. Commit and open a pull request against `main`.

---

## Code Style

- Use `set -euo pipefail` at the top of bash scripts.
- Add a `healthcheck` block to every Docker Compose service.
- Add comments explaining every port, volume, environment variable, and network entry.
- Do not introduce external dependencies not available on a fresh OS install.
