# dotfiles

macOS (Apple Silicon) shell and tool setup: zsh, [starship](https://starship.rs) prompt,
[mise](https://mise.jdx.dev) for Go/Node/Python, and a `Brewfile` for everything else.

## New machine setup

1. **Install the Xcode Command Line Tools** (provides `git` for the clone):

   ```sh
   xcode-select --install
   ```

2. **Clone this repo to `~/.dotfiles`** (HTTPS, since there's no SSH key yet):

   ```sh
   git clone https://github.com/davesters/dotfiles.git ~/.dotfiles
   ```

3. **Run the installer:**

   ```sh
   ~/.dotfiles/script/install
   ```

   It prompts for your git name and email on first run, then:
   - symlinks every `*.symlink` file into `$HOME` as a dotfile (e.g. `zsh/zshrc.symlink` → `~/.zshrc`),
     plus `mise/config.toml` → `~/.config/mise/config.toml` and `starship/starship.toml` → `~/.config/starship.toml`.
     Existing files are moved to `<name>.backup`.
   - installs Homebrew if missing
   - installs mise and the Go/Node/Python versions in `mise/config.toml`
   - sets `GOPATH` to `~/projects/go`
   - runs `brew bundle` to install everything in `Brewfile`: formulae, apps (VS Code, Android Studio,
     Rancher Desktop), Go tools, and global npm packages

   It is safe to re-run.

4. **Create `~/.localrc`** for machine-specific env and secrets (sourced by `.zshrc`, never committed):

   ```sh
   export GITHUB_TOKEN=...
   export GOPRIVATE="github.com/floatme-corp/*"
   ```

5. **Set up GitHub access:**

   ```sh
   ssh-keygen -t ed25519 -C "you@example.com"
   gh auth login
   ```

   For private Go modules over SSH, add to `git/gitconfig.symlink`:

   ```ini
   [url "git@github.com:floatme-corp/"]
       insteadOf = https://github.com/floatme-corp/
   ```

6. **Open a new terminal.**

### Manual installs

Not covered by the installer:

- Flutter, expected at `~/software/flutter`.
- Android SDK, installed through Android Studio's SDK Manager to `~/Library/Android/sdk`.
- For `jdk <version>` to find Homebrew's JDK, symlink it into the system JDK directory:
  `sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk`

## Layout

Each top-level directory is a topic. Within a topic:

- `*.zsh` files are sourced by `.zshrc`, and `completion.zsh` files are sourced after `compinit`.
- `*.symlink` files are linked into `$HOME` by `script/install`.

| Path | Contents |
|---|---|
| `zsh/zshrc.symlink` | Env vars, `PATH`, loader, mise + starship init |
| `zsh/zprofile.symlink` | Homebrew `shellenv` for login shells |
| `zsh/config.zsh` | History, shell options, key bindings |
| `zsh/window.zsh` | Terminal title |
| `git/` | Git aliases, global gitignore, gitconfig template (`gitconfig.symlink` is generated and gitignored) |
| `functions/` | Autoloaded functions: `c` (cd into `$PROJECTS`), `gf` (check out a remote branch), `extract`, `jdk <version>` |
| `system/keys.zsh` | `pubkey`: copy your SSH public key to the clipboard |
| `mise/config.toml` | Global tool versions (Go, Node, Python, uv, pipx CLIs) |
| `starship/starship.toml` | Prompt: `user in ~/path on branch [status] >` |
| `Brewfile` | Homebrew formulae/casks, Go tools, global npm packages |

## Maintenance

- Change a global language version: `mise use -g node@26` (writes to `mise/config.toml` via the symlink).
- Pin a version per project: add `mise.toml`, `.nvmrc`, or `.python-version` in that project.
- Capture newly installed Homebrew packages: `brew bundle dump --force --file=~/.dotfiles/Brewfile`, then review the diff.
- Reload the shell: `reload!`
