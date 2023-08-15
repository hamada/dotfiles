# vscode and me

Mainly I'm using neovim for coding.

then, I'm using vscode for some other cases.

e.g.

- GitHub copilot 
- markdown preview
- mermaid preview
- bloggings

# vscode and neovim

I'm using vscode-neovim for vscode.

vscode specific neovim settings are in `.config/nvim/lua/init_for_vscode.lua` (jk esc is in vscode keybindings.json)

neovim in vscode with `nvim --embed` mode (https://neovim.io/doc/user/starting.html#--embed)

## refs

- https://zenn.dev/yubrot/articles/1bf4b8d79d7cae
- https://qiita.com/cyamy/items/12742afe6f61bce76698#fn-4
- https://github.com/vscode-neovim/vscode-neovim

# vscode settings and keybindings file

- keybindings: `.config/vscode/keybindings.json`
   - symbolic link: `ln -s ~/dotfiles/.config/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json`
- settings: `.config/vscode/settings.json`
   - symbolic link: `ln -s ~/dotfiles/.config/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json`

# Copilot

- when I open a file in nvim, you can open the file immediately in vscode by nvim `copilot this file` command of `telescope-menu` commad. then, you can ask copilot in vscode instantly.
   - this `copilot this file` actually run (neo)vim `:!/usr/local/bin/code %:p` command. (`%:p` is current file full path in vim)
   - to archive this workflow. you have to install `code` command beforehand in vscode. this command can open a file in vscode from CLI 
- keybinding to open copilot chat in vscode: `⌘ + i`
- keybinding to accept copilot suggestion in vscode: `⌘ + Enter`

## refs

- https://qiita.com/kohashi/items/05bc01cbb3a74fdc7227
- https://qiita.com/RyoWakabayashi/items/1207128e88669c76bf5f
