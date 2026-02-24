# Homebrew Tap

Generic Homebrew tap for `trajano` formulas.

## Install

```bash
brew tap trajano/tap
brew install trajano/tap/aliae
```

## How updates work

This tap contains a GitHub Actions workflow that watches `trajano/aliae` releases.
When a new release is found, it updates `Formula/aliae.rb` and commits the change in this tap repository.
