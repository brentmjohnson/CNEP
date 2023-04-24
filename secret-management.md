pip install detect-secrets

detect-secrets scan --force-use-all-plugins > .secrets.baseline
detect-secrets audit .secrets.baseline
detect-secrets audit --only-real .secrets.baseline
detect-secrets audit --only-real --report .secrets.baseline > .secrets.report
