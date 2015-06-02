#Joe Choi's Dotfiles

Powered by [Dotbot][dotbot].

##Prerequisite Applications
* [Homebrew][homebrew]: `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
* [Amethyst][amethyst]: `brew cask install amethyst`
* [Oh-My-Zsh][zsh]: `curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh`
* [Tmux][tmux]: `brew install tmux`
* [VIM with Lua][vim]: `brew install vim --with-lua`
* [Vim-Plug][plug]: `curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
* [Hammerspoon][hs]

## Installation
Run `sh install`. Open vim and `:PlugInstall` to install plugins.

[dotbot]: https://github.com/anishathalye/dotbot
[homebrew]: http://brew.sh/
[amethyst]: https://github.com/ianyh/amethyst
[zsh]: https://github.com/robbyrussell/oh-my-zsh
[tmux]: http://tmux.sourceforge.net/
[vim]: http://www.vim.org/
[plug]: https://github.com/junegunn/vim-plug
[hs]: https://github.com/Hammerspoon/hammerspoon/releases
