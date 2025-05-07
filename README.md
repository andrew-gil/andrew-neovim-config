Initial Config for NeoVim:
using " " (space) as leader, relative line numbers are enabled, gruvbox is used as color scheme
installed vim plug as package manager
installed telescope as fuzzy finder: use leader ff for find, leader fg for grep (search words) use ctrl p for git
use ctrl p to go up ctrl n to go down, when browsing inside telescope
telescope uses ripgrep as a dependency (brew installed) for live searching, also requires plenary, but that's vim plugged
installed treesitter as coloring thing
installed omnisharp as csharp thing, but not working as intended
need to install typescript, javascript lsp's
installed neovim lsp config, see https://lsp-zero.netlify.app/blog/lsp-config-overview.html maybe for info on using it

instead of tab management, using vim features, such as 
:vsp (open new vertical pane)
C-w h (switch to left pane)
C-w l (switch to right pane)
:bprev (go to previousy buffer in this pane)
:bnext (go to next buffer in this pane)
:q (close pane)
:bd (unload current buffer)
:ls or :buffers (see all buffers in memory)
:buffer 3 (jump to buffer 3)

for typescript lsp
npm install --global typescript-language-server prettier
installed a bunch of stuff like buffer, vsnip stuff, add the require at the end, copied some config from a github dudes config, boom. 


Dependencies:
brew install ripgrep
npm install --global typescript-language-server prettier
npm install --global some-sass-language-server
