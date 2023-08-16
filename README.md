<!-- markdownlint-disable MD013 MD034 MD033 -->

# fzfx.nvim

[![Neovim-v0.5](https://img.shields.io/badge/Neovim-v0.5-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green)](https://github.com/neovim/neovim/releases/tag/v0.5.0)
[![License](https://img.shields.io/github/license/linrongbin16/lin.nvim?style=flat-square&logo=GNU)](https://github.com/linrongbin16/lin.nvim/blob/main/LICENSE)
![Linux](https://img.shields.io/badge/Linux-%23.svg?style=flat-square&logo=linux&color=FCC624&logoColor=black)
![macOS](https://img.shields.io/badge/macOS-%23.svg?style=flat-square&logo=apple&color=000000&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-%23.svg?style=flat-square&logo=windows&color=0078D6&logoColor=white)

> E(x)tended commands missing in [fzf.vim](https://github.com/junegunn/fzf.vim).

This is the next generation of [fzfx.vim](https://github.com/linrongbin16/fzfx.vim). A brand new fzf plugin for Neovim, build from scratch, focused on user friendly, customization and performance.

- [Feature](#feature)
- [Requirement](#requirement)
  - [Path containing whitespace & Escaping issue](#path-containing-whitespace--escaping-issue)
- [Install](#install)
  - [vim-plug](#vim-plug)
  - [packer.nvim](#packernvim)
  - [lazy.nvim](#lazynvim)
- [Commands](#commands)
- [Recommended Key Mappings](#recommended-key-mappings)
  - [Vimscript](#vimscript)
  - [Lua](#lua)
- [Configuration](#configuration)
- [Credit](#credit)
- [Contribute](#contribute)

## Feature

- Windows support.
- Icons & colors.
- Multiple variants to avoid manual input:
  - Search by visual select.
  - Search by cursor word.
  - Search by yank text.
- (Un)restricted mode: easily switch whether to search hidden and ignored files.
- Lua support: preview lua function defined commands and key mappings (todo).
- ...

Here's a live grep demo that searching `fzfx` with rg's `-g *ch.lua` option on specific filetypes.

https://github.com/linrongbin16/fzfx.nvim/assets/6496887/aa5ef18c-26b4-4a93-bd0c-bfeba6f6caf1

## Requirement

- Neovim &ge; 0.5.
- [rg](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), recommand to install them with [cargo](https://www.rust-lang.org/):

  ```bash
  cargo install ripgrep
  cargo install fd-find
  cargo install --locked bat
  ```

- [Nerd fonts](https://www.nerdfonts.com/) (optional for icons).

### Path containing whitespace & Escaping issue

fzfx.nvim internally extends both executables (`nvim`, `fzf`) and lua scripts to full path when launching command.

But when there're whitespaces on the path, launching correct shell command becomes quite difficult, since it will seriously affected escaping characters. Here're two typical cases:

1. `C:\Program Files\Neovim\bin\nvim.exe` - `nvim.exe` installed in `C:\Program Files` directory.

   Please add executables (`nvim.exe`, `fzf.exe`) to `%PATH%` (`$env:PATH` in PowerShell), and set the `env` configuration:

   ```lua
   require("fzfx").setup({
       env = {
           nvim = 'nvim',
           fzf = 'fzf',
       }
   })
   ```

   This will help fzfx.nvim avoid the shell command issue.

2. `C:\Users\Lin Rongbin\opt\Neovim\bin\nvim.exe` - User name contains whitespace.

   We still cannot handle the 2nd case for now, please always try to avoid whitespaces in path.

<details>
<summary><b>Click here to read more details</b></summary>
<br/>

Here's an example of searching files command (macOS):

- `/opt/homebrew/bin/nvim -n --clean --headless -l /Users/linrongbin/.local/share/nvim/lazy/fzfx.nvim/bin/files/provider.lua  /tmp/nvim.linrongbin/3NXwys/0`

Here's an example of launching fzf command (Windows 10):

- `C:/Users/linrongbin/github/junegunn/fzf/bin/fzf --query "" --header ":: Press \27[38;2;255;121;198mCTRL-U\27[0m to unrestricted mode" --prompt "~/g/l/fzfx.nvim > " --bind "start:unbind(ctrl-r)" --bind "ctrl-u:unbind(ctrl-u)+execute-silent(C:\\Users\\linrongbin\\scoop\\apps\\neovim\\current\\bin\\nvim.exe -n --clean --headless -l C:\\Users\\linrongbin\\github\\linrongbin16\\fzfx.nvim\\bin\\rpc\\client.lua 1)+change-header(:: Press \27[38;2;255;121;198mCTRL-R\27[0m to restricted mode)+rebind(ctrl-r)+reload(C:\\Users\\linrongbin\\scoop\\apps\\neovim\\current\\bin\\nvim.exe -n --clean --headless -l C:\\Users\\linrongbin\\github\\linrongbin16\\fzfx.nvim\\bin\\files\\provider.lua C:\\Users\\linrongbin\\AppData\\Local\\nvim-data\\fzfx.nvim\\switch_files_provider)" --bind "ctrl-r:unbind(ctrl-r)+execute-silent(C:\\Users\\linrongbin\\scoop\\apps\\neovim\\current\\bin\\nvim.exe -n --clean --headless -l C:\\Users\\linrongbin\\github\\linrongbin16\\fzfx.nvim\\bin\\rpc\\client.lua 1)+change-header(:: Press \27[38;2;255;121;198mCTRL-U\27[0m to unrestricted mode)+rebind(ctrl-u)+reload(C:\\Users\\linrongbin\\scoop\\apps\\neovim\\current\\bin\\nvim.exe -n --clean --headless -l C:\\Users\\linrongbin\\github\\linrongbin16\\fzfx.nvim\\bin\\files\\provider.lua C:\\Users\\linrongbin\\AppData\\Local\\nvim-data\\fzfx.nvim\\switch_files_provider)" --preview "C:\\Users\\linrongbin\\scoop\\apps\\neovim\\current\\bin\\nvim.exe -n --clean --headless -l C:\\Users\\linrongbin\\github\\linrongbin16\\fzfx.nvim\\bin\\files\\previewer.lua {}" --bind "ctrl-l:toggle-preview" --expect "enter" --expect "double-click" >C:\\Users\\LINRON~1\\AppData\\Local\\Temp\\nvim.0\\JSmP06\\2`

If user name contains whitespace, that will make all lua scripts contains whitespace, thus the shell command cannot being correctly evaluated.

</details>

## Install

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
call plug#begin()

" optional for icons
Plug 'nvim-tree/nvim-web-devicons'

" mandatory
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'linrongbin16/fzfx.nvim'

call plug#end()

lua require('fzfx').setup()
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
return require('packer').startup(function(use)
    -- optional for icons
    use { "nvim-tree/nvim-web-devicons" }

    -- mandatory
    use { "junegunn/fzf", run = ":call fzf#install()" }
    use {
        "linrongbin16/fzfx.nvim",
        requires = { "junegunn/fzf" },
        config = function()
            require("fzfx").setup()
        end
    }
end)
```

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
require("lazy").setup({
    -- optional for icons
    { "nvim-tree/nvim-web-devicons" },

    -- mandatory
    { "junegunn/fzf", build = ":call fzf#install()" },
    {
        "linrongbin16/fzfx.nvim",
        dependencies = { "junegunn/fzf" },
        config = function()
            require("fzfx").setup()
        end
    },

})
```

## Commands

Commands are named following below rules:

- All commands are named with prefix `Fzfx`.
- The main command name has no suffix.
- The unrestricted variant is named with `U` suffix.
- The visual select variant is named with `V` suffix.
- The cursor word variant is named with `W` suffix.
- The yank text variant is named with `P` suffix (just like press the `p` key).

> Note: command names can be configured, see [Configuration](#configuration).

Here're some most useful builtin keys inside fzf terminal:

- Preview keys
  - `ctrl-l`: toggle preview.
- Multi keys
  - `ctrl-e`: select.
  - `ctrl-d`: deselect.
  - `ctrl-a`: select all.
  - `alt-a`: deselect all.

> Note: builtin keys can be configured, see [Configuration](#configuration).

<table>
<thead>
  <tr>
    <th>Group</th>
    <th>Command</th>
    <th>Mode</th>
    <th>Multi Key?</th>
    <th>Preview Key?</th>
    <th>Special Feature</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="4">Files</td>
    <td>FzfxFiles(U)</td>
    <td>N</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4"></td>
  </tr>
  <tr>
    <td>FzfxFiles(U)V</td>
    <td>V</td>
  </tr>
  <tr>
    <td>FzfxFiles(U)W</td>
    <td>N</td>
  </tr>
  <tr>
    <td>FzfxFiles(U)P</td>
    <td>N</td>
  </tr>
  <tr>
    <td rowspan="4">Live Grep</td>
    <td>FzfxLiveGrep(U)</td>
    <td>N</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4">1. Use `--` to pass raw options to search command (grep, rg)</td>
  </tr>
  <tr>
    <td>FzfxLiveGrep(U)V</td>
    <td>V</td>
  </tr>
  <tr>
    <td>FzfxLiveGrep(U)W</td>
    <td>N</td>
  </tr>
  <tr>
    <td>FzfxLiveGrep(U)P</td>
    <td>N</td>
  </tr>
  <tr>
    <td rowspan="4">Buffers</td>
    <td>FzfxBuffers</td>
    <td>N</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4"></td>
  </tr>
  <tr>
    <td>FzfxBuffersV</td>
    <td>V</td>
  </tr>
  <tr>
    <td>FzfxBuffersW</td>
    <td>N</td>
  </tr>
  <tr>
    <td>FzfxBuffersP</td>
    <td>N</td>
  </tr>
  <tr>
    <td rowspan="4">Git Files</td>
    <td>FzfxGFiles</td>
    <td>N</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4">Yes</td>
    <td rowspan="4"></td>
  </tr>
  <tr>
    <td>FzfxGFilesV</td>
    <td>V</td>
  </tr>
  <tr>
    <td>FzfxGFilesW</td>
    <td>N</td>
  </tr>
  <tr>
    <td>FzfxGFilesP</td>
    <td>N</td>
  </tr>
</tbody>
</table>

## Recommended Key Mappings

### Vimscript

```vim

" ======== files ========

" find files
nnoremap <space>f :\<C-U>FzfxFiles<CR>
" visual select
xnoremap <space>f :\<C-U>FzfxFilesV<CR>
" unrestricted
nnoremap <space>uf :\<C-U>FzfxFilesU<CR>
" unrestricted visual select
xnoremap <space>uf :\<C-U>FzfxFilesUV<CR>

" cursor word
nnoremap <space>wf :\<C-U>FzfxFilesW<CR>
" unrestricted cursor word
nnoremap <space>uwf :\<C-U>FzfxFilesUW<CR>
" yank text
nnoremap <space>pf :\<C-U>FzfxFilesP<CR>
" unrestricted yank text
nnoremap <space>upf :\<C-U>FzfxFilesUP<CR>

" ======== live grep ========

" live grep
nnoremap <space>l :\<C-U>FzfxLiveGrep<CR>
" visual select
xnoremap <space>l :\<C-U>FzfxLiveGrepV<CR>
" unrestricted
nnoremap <space>ul :\<C-U>FzfxLiveGrepU<CR>
" unrestricted visual select
xnoremap <space>ul :\<C-U>FzfxLiveGrepUV<CR>

" by cursor word
nnoremap <space>wl :\<C-U>FzfxLiveGrepW<CR>
" unrestrictly cursor word
nnoremap <space>uwl :\<C-U>FzfxLiveGrepUW<CR>
" by yank text
nnoremap <space>pl :\<C-U>FzfxLiveGrepP<CR>
" unrestrictly yank text
nnoremap <space>upl :\<C-U>FzfxLiveGrepUP<CR>

" ======== buffers ========

" buffers
nnoremap <space>bf :\<C-U>FzfxBuffers<CR>
" visual select
xnoremap <space>bf :\<C-U>FzfxBuffersV<CR>
" by cursor word
nnoremap <space>wbf :\<C-U>FzfxBuffersW<CR>
" by yank text
nnoremap <space>pbf :\<C-U>FzfxBuffersP<CR>

" ======== git files ========

" git files
nnoremap <space>gf :\<C-U>FzfxGFiles<CR>
" visual select
xnoremap <space>gf :\<C-U>FzfxGFilesV<CR>
" by cursor word
nnoremap <space>wgf :\<C-U>FzfxGFilesW<CR>
" by yank text
nnoremap <space>pgf :\<C-U>FzfxGFilesP<CR>
```

### Lua

```lua

-- ======== files ========

-- find files
vim.keymap.set('n', '<space>f', '<cmd>FzfxFiles<cr>',
        {silent=true, noremap=true, desc="Find files"})
-- visual select
vim.keymap.set('x', '<space>f', '<cmd>FzfxFilesV<CR>',
        {silent=true, noremap=true, desc="Find files"})
-- unrestricted
vim.keymap.set('n', '<space>uf',
        '<cmd>FzfxFilesU<cr>',
        {silent=true, noremap=true, desc="Unrestricted find files"})
-- unrestricted visual select
vim.keymap.set('x', '<space>uf',
        '<cmd>FzfxFilesUV<CR>',
        {silent=true, noremap=true, desc="Unrestricted find files"})

-- cursor word
vim.keymap.set('n', '<space>wf', '<cmd>FzfxFilesW<cr>',
        {silent=true, noremap=true, desc="Find files by cursor word"})
-- unrestricted cursor word
vim.keymap.set('n', '<space>uwf', '<cmd>FzfxFilesUW<cr>',
        {silent=true, noremap=true, desc="Unrestricted find files by cursor word"})
-- yank text
vim.keymap.set('n', '<space>pf', '<cmd>FzfxFilesP<cr>',
        {silent=true, noremap=true, desc="Find files by yank text"})
-- unrestricted yank text
vim.keymap.set('n', '<space>uwf', '<cmd>FzfxFilesUP<cr>',
        {silent=true, noremap=true, desc="Unrestricted find files by yank text"})

-- ======== live grep ========

-- live grep
vim.keymap.set('n', '<space>l',
        '<cmd>FzfxLiveGrep<cr>',
        {silent=true, noremap=true, desc="Live grep"})
-- visual select
vim.keymap.set('x', '<space>l',
        "<cmd>FzfxLiveGrepV<cr>",
        {silent=true, noremap=true, desc="Live grep"})
-- unrestricted live grep
vim.keymap.set('n', '<space>ul',
        '<cmd>FzfxLiveGrepU<cr>',
        {silent=true, noremap=true, desc="Unrestricted live grep"})
-- unrestricted visual select
vim.keymap.set('x', '<space>ul',
        "<cmd>FzfxLiveGrepUV<cr>",
        {silent=true, noremap=true, desc="Unrestricted live grep"})

-- cursor word
vim.keymap.set('n', '<space>wl',
        '<cmd>FzfxLiveGrepW<cr>',
        {silent=true, noremap=true, desc="Live grep by cursor word"})
-- unrestricted cursor word
vim.keymap.set('n', '<space>uwl',
        '<cmd>FzfxLiveGrepUW<cr>',
        {silent=true, noremap=true, desc="Unrestricted live grep by cursor word"})
-- yank text
vim.keymap.set('n', '<space>pl',
        '<cmd>FzfxLiveGrepP<cr>',
        {silent=true, noremap=true, desc="Live grep by cursor word"})
-- unrestricted yank text
vim.keymap.set('n', '<space>upl',
        '<cmd>FzfxLiveGrepUP<cr>',
        {silent=true, noremap=true, desc="Unrestricted live grep by yank text"})

-- ======== buffers ========

-- buffers
vim.keymap.set('n', '<space>bf',
        '<cmd>FzfxBuffers<cr>',
        {silent=true, noremap=true, desc="Find buffers"})
-- visual select
vim.keymap.set('x', '<space>bf',
        "<cmd>FzfxBuffersV<cr>",
        {silent=true, noremap=true, desc="Find buffers"})
-- cursor word
vim.keymap.set('n', '<space>wbf',
        '<cmd>FzfxBuffersW<cr>',
        {silent=true, noremap=true, desc="Find buffers by cursor word"})
-- yank text
vim.keymap.set('n', '<space>pbf',
        '<cmd>FzfxBuffersP<cr>',
        {silent=true, noremap=true, desc="Find buffers by yank text"})

-- ======== git files ========

-- git files
vim.keymap.set('n', '<space>gf',
        '<cmd>FzfxGFiles<cr>',
        {silent=true, noremap=true, desc="Find git files"})
-- visual select
vim.keymap.set('x', '<space>gf',
        "<cmd>FzfxGFilesV<cr>",
        {silent=true, noremap=true, desc="Find git files"})
-- cursor word
vim.keymap.set('n', '<space>wgf',
        '<cmd>FzfxGFilesW<cr>',
        {silent=true, noremap=true, desc="Find git files by cursor word"})
-- yank text
vim.keymap.set('n', '<space>pgf',
        '<cmd>FzfxGFilesP<cr>',
        {silent=true, noremap=true, desc="Find git files by yank text"})
```

## Configuration

For complete options and default configurations, please check [config.lua](https://github.com/linrongbin16/fzfx.nvim/blob/main/lua/fzfx/config.lua).

## Credit

- [fzf.vim](https://github.com/junegunn/fzf.vim): Things you can do with [fzf](https://github.com/junegunn/fzf) and Vim.
- [fzf-lua](https://github.com/ibhagwan/fzf-lua): Improved fzf.vim written in lua.

## Contribute

Please open [issue](https://github.com/linrongbin16/fzfx.nvim/issues)/[PR](https://github.com/linrongbin16/fzfx.nvim/pulls) for anything about fzfx.nvim.

Like fzfx.nvim? Consider

[![Github Sponsor](https://img.shields.io/badge/-Sponsor%20Me%20on%20Github-magenta?logo=github&logoColor=white)](https://github.com/sponsors/linrongbin16)
[![Wechat Pay](https://img.shields.io/badge/-Tip%20Me%20on%20WeChat-brightgreen?logo=wechat&logoColor=white)](https://github.com/linrongbin16/lin.nvim/wiki/Sponsor)
[![Alipay](https://img.shields.io/badge/-Tip%20Me%20on%20Alipay-blue?logo=alipay&logoColor=white)](https://github.com/linrongbin16/lin.nvim/wiki/Sponsor)
