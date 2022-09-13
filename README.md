# Heisencoder's Linux Settings

This repo contains Matt Ball's personal Linux configuration,
with the goal of making it easier to set up a new account on a new computer.

You are welcome to use these settings for yourself, but beware!
Some of these changes are generally useful to anyone, but other changes are very specific to my local development environment.

These changes assume an Ubuntu 22.04 LTS or compatible Linux distribution.

## Installation

1. Clone the repo into your home directory.  It should appear as a subdirectory named `settings`.

```shell
cd ~
git clone https://github.com/heisencoder/settings.git
```

2. Install the settings

Beware!  This will add a lot of symlinks to your home directory!

```shell
cd settings
./install.sh
```

Look for error messages about particular files already existing.  Delete these files
(after you've confirmed that there aren't important changes you want to save) and rerun `install.sh`.

### Git Settings

Update git to point to the githooks directory:

```shell
git config --global core.hooksPath ~/settings/githooks
```

## Development

New configuration goes into the `main` branch, but baseline configuration files go into the `baseline` branch.

When adding new configuration that depends on a boilerplate file, the process is to first check-in this file to the `baseline`
branch and then merge the baseline branch into `main`.

When upgrading the baseline environment (e.g., when upgrading to a new Ubuntu version or a new version of a dependency like i3), 
regenerate a new template file and check that into `baseline` and then merge that into `main`.
In this way, new changes can more easily get included via a 3-day merge.

