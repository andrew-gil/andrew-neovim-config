## Dependencies:
brew install fzf ripgrep
brew install lua-language-server (optional, only if need lua)
npm install --global typescript-language-server prettier some-sass-language-server @angular/language-server

## Set Up:
Clone repository and replace your current `nvim` folder with this one
mv ~/.config/nvim ~/.config/nvim-old

## Install Plugins:
Navigate to init.lua
install plugins using Vim Plug
:PlugInstall

To install omnisharp for c#, dowload a release from the releases link (I have downloaded omnisharp-osx-arm-64-net6.0. Place into desired path, configure path in lsp.lua to hit either OmniSharp or run. If access error, make sure run/OmniSharp is executable by `chmod +x ~/[path]`
https://github.com/omnisharp/omnisharp-roslyn#downloading-omnisharp
if hitting error code 131, try uninstalling and reinstalling dotnet from the official website. Then, run `echo export DOTNET_ROOT=/usr/local/dotnet' >> ~/.zprofile` then `exec $SHELL -l # reload shell`. Check that the DOTNET_ROOT is set by running `dotnet --info`. 

### Keybinds
| Category                   | Mapping                                   | Action                                                                  |
|----------------------------|-------------------------------------------|-------------------------------------------------------------------------|
| **File Explorer**           | `<leader>re`                             | Return to the **file‑tree** view                                        |
| **fzf.lua**                | `<leader><leader>`                        | **Find files**                                                          |
|                            | `<leader>gs`                              | **Git status** picker                                                   |
|                            | `<leader>gr`                              | **Live grep** (search text across files)                                |
|                            | `<leader>bf`                              | **Buffers** picker                                                      |
|                            | `<leader>cs`                              | **Colorscheme** picker                                                  |
|                            | `<leader>fi`                              | **Find implementations** (LSP)                                          |
|                            | `alt-a` (in fzf picker)                   | **Select all** items and accept                                         |
| **LSP Actions**            | `<leader>gd`                              | **Go to definition**                                                    |
|                            | `<leader>fr`                              | **Find references** (LSP)                                               |
|                            | `<leader>hv`                              | **Hover** documentation                                                 |
|                            | `<leader>ca`                              | **Code action** (quick‑fix / import)                                    |
|                            | `<leader>fm`                              | **Format** current buffer                                               |
| **Window / Pane Navigation** | `<leader>wl` · `<leader>wh` · `<leader>wk` · `<leader>wj` | Move to the pane **right / left / up / down**                           |
|                            | `:vsp`                                    | Open a **vertical split**                                               |
|                            | `:vertical resize ±N`                     | **Resize** the current split by *N* columns                             |
| **Buffer Management**       | `<leader>[[` · `<leader>]]`              | Switch to **previous / next buffer**                                   |
|                            | `<leader><Tab>`                           | Switch to **alternate buffer** (Ctrl-6)                                |
| **Diagnostics**            | `<leader>do`                              | **Toggle** diagnostics on/off                                          |
|                            | `<leader>dd`                              | **Open floating** diagnostic window                                    |
|                            | `<leader>de`                              | **Toggle** between virtual text and virtual lines                      |
|                            | `<leader>da`                              | **Toggle** between current line only and all lines diagnostics         |
|                            | `<leader>db`                              | **Diagnostics** (current document) picker                              |
|                            | `<leader>dw`                              | **Diagnostics** (workspace) picker                                     |
| **Git/Diff (diffview.nvim)** | `<leader>dv`                              | **Toggle** diffview                                                    |
| **Git/Diff (unified.nvim)** | `<leader>uv`                              | **Toggle** unified diff view                                           |
|                            | `<leader>uc`                              | **Clear** diff markings from current buffer                            |
| **CLI Legend**            | `<leader>cl`                              | **Toggle** custom cli legend on/off                                          |

- `<leader>` : your leader key (space by default)
- Use `<leader>dv` to toggle diffview, `<leader>uv` to toggle unified diff view, `<leader>uc` to clear diff markings

### C# Development
For C# files (`.cs`), the following commands are available:
- `:make` - Build the project using `dotnet build` (errors only, warnings filtered)
- `:DotnetTest` - Run tests using `dotnet test` and populate quickfix with failures
- `:copen` - Open the quickfix window to view build errors or test failures
