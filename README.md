## Dependencies:
brew install ripgrep
npm install --global typescript-language-server prettier some-sass-language-server

## Set Up:
Clone repository and replace your current `nvim` folder with this one
mv ~/.config/nvim ~/.config/nvim-old

## Install Plugins:
Navigate to init.lua
install plugins using Vim Plug
:PlugInstall
:OmniSharpInstall
On windows, may have to adjust file path targetting omnisharp in lsp.lua

### Keybinds
| Category                   | Mapping                                   | Action                                                                  |
|----------------------------|-------------------------------------------|-------------------------------------------------------------------------|
| **File Explorer**           | `<leader>re`                              | Return to the **file‑tree** view                                        |
| **Telescope**              | `<leader><leader>`                        | **Find files**                                                          |
|                            | `<leader>gs`                              | **Git status** picker                                                   |
|                            | `<leader>gr`                              | **Live grep** (search text across files)                                |
|                            | *Inside Telescope* &nbsp;—&nbsp;`Ctrl‑j / Ctrl‑k` | Move **down / up** in the results list                                  |
| **LSP Actions**            | `<leader>gd`                              | **Go to definition**                                                    |
|                            | `<leader>hv`                              | **Hover** documentation                                                 |
|                            | `<leader>ca`                              | **Code action** (quick‑fix / import)                                    |
|                            | `<leader>fm`                              | **Format** current buffer                                               |
| **Window / Pane Navigation** | `<leader>ll` · `<leader>hh` · `<leader>kk` · `<leader>jj` | Move to the pane **right / left / up / down**                           |
|                            | `:vsp`                                    | Open a **vertical split**                                               |
|                            | `:vertical resize ±N`                     | **Resize** the current split by *N* columns                             |
| **Buffer Management**       | `<leader>[[` · `<leader>]]`               | Switch to **previous / next buffer**                                    |

- `<leader>` : your leader key (space by default)  

### thoughts for future config
could install brew install lua-language-server, but pain on windows. If using lua-language-server, update config
could dotnet tool --global install csharpier, but pain. Would rather just stay lightweight. Use rider if you want everything.
