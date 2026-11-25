<div align="center">

# 🍎 macOS Setup

**Set up a new Mac for cloud-native development with a single command.**

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?style=for-the-badge&logo=homebrew&logoColor=black)](https://brew.sh)
[![Shell](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](bootstrap.sh)
[![Oh My Zsh](https://img.shields.io/badge/Oh_My_Zsh-1A2C34?style=for-the-badge&logo=zsh&logoColor=white)](https://ohmyz.sh)

[Quick start](#-quick-start) •
[What it does](#%EF%B8%8F-what-it-does) •
[What gets installed](#-what-gets-installed) •
[Customizing](#%EF%B8%8F-customizing)

</div>

---

## ✨ Overview

This repository sets up a new Mac the same way every time. A single script installs [Homebrew](https://brew.sh), every package listed in the [Brewfile](Brewfile), and [Oh My Zsh](https://ohmyz.sh), and then puts Homebrew on your `PATH` for both zsh and bash.

- **Idempotent.** Every step checks what is already done and skips it, so you can safely re-run the script.
- **Declarative.** The full toolchain lives in one readable [Brewfile](Brewfile).
- **Works on both chips.** The script finds Homebrew on Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`).
- **No extra dependencies.** It runs on the stock bash 3.2 that ships with macOS.

## 🚀 Quick start

```sh
git clone https://github.com/gimlewicz/macOS-setup.git
cd macOS-setup
./bootstrap.sh
```

When it finishes, open a new terminal window (or iTerm2) to load the changes.

> [!NOTE]
> The script only runs on macOS and exits straight away on any other OS. You need an internet connection, and the Homebrew installer may ask for your password.

## ⚙️ What it does

`bootstrap.sh` runs these steps in order:

| Step  | Action                      | Details                                                                                                     |
| :---: | --------------------------- | ----------------------------------------------------------------------------------------------------------- |
|   1   | **Install Homebrew**        | Skipped if `brew` is already installed.                                                                     |
|   2   | **Install the Brewfile**    | Runs `brew update`, then `brew bundle` against the [Brewfile](Brewfile). Homebrew analytics are turned off. |
|   3   | **Install Oh My Zsh**       | Runs in unattended mode, so it doesn't change your login shell or take over the current session.            |
|   4   | **Persist `brew shellenv`** | Adds it to `~/.zprofile`, `~/.zshrc`, `~/.bash_profile` and `~/.bashrc` if it isn't already there.          |

> [!TIP]
> Step 4 runs after Oh My Zsh on purpose: the Oh My Zsh installer replaces `~/.zshrc`, which would remove the Homebrew line if it had been added first.

## 📦 What gets installed

| Category                    | Tools                                                                                         |
| --------------------------- | --------------------------------------------------------------------------------------------- |
| 🐚 **Shell**                 | [Oh My Zsh](https://ohmyz.sh), [iTerm2](https://iterm2.com)                                   |
| 🧰 **General**               | `jq`, `yq`, `gh`, `pre-commit`, Claude, Claude Code                                           |
| 💻 **IDE**                   | [Cursor](https://cursor.com)                                                                  |
| ☸️ **Kubernetes**            | `kubectl`, `kind`, `kustomize`, `k9s`, `helm`, `argocd`, `flux`, `cilium-cli`, Docker Desktop |
| 🔒 **Containers & security** | `dive`, `grype`, `trivy`                                                                      |
| ☁️ **Cloud**                 | `awscli`, `azure-cli`, `gcloud-cli`                                                           |
| 🏗️ **IaC & secrets**         | `terraform`, `opentofu`, `vault`                                                              |

<details>
<summary><b>Third-party taps</b></summary>
<br>

| Tap                                                          | Provides             |
| ------------------------------------------------------------ | -------------------- |
| [`hashicorp/tap`](https://github.com/hashicorp/homebrew-tap) | `terraform`, `vault` |
| [`fluxcd/tap`](https://github.com/fluxcd/homebrew-tap)       | `flux`               |

</details>

## 🛠️ Customizing

To add a tool, put a line under the matching section of the [Brewfile](Brewfile) and re-run the script:

```ruby
brew "name"   # command-line tool (formula)
cask "name"   # desktop app
```

To remove a tool, delete its line from the Brewfile and uninstall it with `brew uninstall <name>`.

## 📁 Repository layout

```
.
├── Brewfile        # Every package to install, grouped by category
├── bootstrap.sh    # Idempotent setup script
└── README.md
```
