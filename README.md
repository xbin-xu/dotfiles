# Dotfiles

> Reference: [anishathalye] | [JJGO] | [mathiasbynens] | [ravenxrz]

Uses [Dotbot] for installation.

**Warning**: Try to backup your dotfiles first.

## Getting Started

```bash
git clone https://github.com/acwBin/dotfiles
cd dotfiles
./install
```

## Making Local Customizations

You can make local customizations by editing these files:

+ `git`: `~/.gitconfig_local`
+ `tmux`: `~/.tmux_local.conf`
+ `vim`: `~/.vimrc_local`

## [Modern Unix Commands]

+ [bat]: A `cat` clone with syntax highlighting and Git integration.
+ [eza]: A modern, maintained replacement for `ls`.
+ [fd]: A simple, fast and user-friendly alternative to `find`.
+ [fzf]: A general purpose command-line fuzzy finder.
+ [lazygit]: A simple terminal UI for `git`.
+ [ripgrep]: An extremely fast alternative to `grep` that respects your gitignore.
+ [zoxide]: A smarter `cd` command inspired by `z`.

```bash
# ubuntu
sudo apt install -y bat eza fd-find ripgrep zoxide 
# windows: install by scoop
scoop install bat eza fd lazygit ripgrep zoxide

# fzf integration
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

[anishathalye]: https://github.com/anishathalye/dotfiles
[JJGO]: https://github.com/JJGO/dotfiles
[mathiasbynens]: https://github.com/mathiasbynens/dotfiles
[ravenxrz]: https://github.com/ravenxrz/dotfiles
[dotbot]: https://github.com/anishathalye/dotbot
[Modern Unix Commands]: https://github.com/ibraheemdev/modern-unix
[bat]: https://github.com/sharkdp/bat
[eza]: https://github.com/eza-community/eza
[fd]: https://github.com/sharkdp/fd
[fzf]: https://github.com/junegunn/fzf
[lazygit]: https://github.com/jesseduffield/lazygit
[ripgrep]: https://github.com/BurntSushi/ripgrep
[zoxide]: https://github.com/ajeetdsouza/zoxide
