local M = {}

--the vision
--set up fzf in a floating term like :FZF for things like file searching, buffer searching
--side by side that with a floating buffer with a custom parser that finds all interfaces.
--set up a git status situation like fzf-lua git status but use that idea of displaying patches in quickfix
--set up grep to be quickfixed, with the grep current highlighted, grep again, and fzf grep (optional)
--set up fzf colorschemes
--preview-window up,1,border-horizontal

--todo pass in custom function to --preview rather than bat, that uses treesitter to properly find the best code to preview
--currently writing standalone command line util to do this. In progress. Can indefinitely use basic bat preview.
M.files = function()
    vim.cmd([[call fzf#run(fzf#wrap({
        \ 'source': 'fd --type f --hidden --exclude .git --exclude node_modules',
        \ 'sink': 'e',
        \ 'options': ['--exact', '--style', 'minimal',
        \            '--border-label', 'File Search',
        \            '--preview', 'bat -f --style=numbers {}'],
        \ 'window': { 'width': 0.6, 'height': 0.9, 'border': 'rounded' }
        \ }))]])
end

-- this doesn't do what fzf-lua git status used to do. I want this to do just one thing, which is give me a filtered list to go to files I am currently writing to.
-- when something is staged, it shows only staged changes. If it also has unstaged changes, it will not show.
-- this is only for searching. If I want a staging manager like what fzf-lua used to do, use a prebuilt tool like lazygit or fugitive
M.git_modified = function()
    local isStaged = "git diff --cached --name-only | rg -Fxq {}"
    vim.cmd([[call fzf#run(fzf#wrap({
        \ 'source': '(git ls-files -m; git diff --cached --name-only) | sort -u',
        \ 'sink': 'e',
        \ 'options': ['--exact', '--style', 'minimal', 
        \            '--border-label', 'Git Modified',
        \            '--preview', '(git diff --cached --name-only | rg -Fxq {} && git diff --cached {} || git diff {}) | bat -f --style=plain --language diff'],
        \ 'window': { 'width': 0.6, 'height': 0.9, 'border': 'rounded' }
        \ }))]])
end

M.colorschemes = function()
    vim.cmd([[call fzf#run(fzf#wrap({
        \ 'source': map(split(globpath(&rtp, 'colors/*.vim') . "\n" . globpath(&rtp, 'colors/*.lua')), 'fnamemodify(v:val, '':t:r'')'),
        \ 'sink': 'colorscheme'
        \ }))]])
end

M.setup_fzf = function()
    vim.keymap.set('n', '<leader><leader>', M.files)
    vim.keymap.set('n', '<leader>gs', M.git_modified)
    vim.keymap.set('n', '<leader>cs', M.colorschemes)
end

M.setup_fzf_lua = function()
    local fzf = require('fzf-lua')
    fzf.setup({
      keymap = {
        fzf = {
          ["alt-a"]         = "select-all+accept",
        }
      }
    })

    -- can replace with custom findexpr function use fd, pipe results out to custom vim.ui.select
    -- can also replace with fzf basic vim
    vim.keymap.set('n', '<leader><leader>', fzf.files)
    -- can replace with custom findexpr function? look at buffers, use fd, pipe results out to custom vim.ui.select
    vim.keymap.set('n', '<leader>bf', fzf.buffers)
    vim.keymap.set('n', '<leader>gs', fzf.git_status)

    -- fzf grep stuff.
    vim.keymap.set('n', '<leader>gr', fzf.grep)
    vim.keymap.set('n', '<leader>ga', ":lua FzfLua.grep({resume=true})<cr>")
    vim.keymap.set('v', '<leader>8', fzf.grep_visual)
    vim.keymap.set('n', '<leader>gl', fzf.live_grep)

    -- fzf lsp stuff. Generally, if I could benefit from the preview or the search, it's worth using this over vim.lsp.buf.
    -- add outgoing_calls and incoming_calls ; generally subsets of find references, but can be helpful
    vim.keymap.set('n', '<leader>fr', fzf.lsp_references,
      { noremap = true, silent = true, desc = 'LSP references' })
    vim.keymap.set('n', '<leader>gi', fzf.lsp_implementations,
      { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>db", fzf.diagnostics_document)
    vim.keymap.set("n", "<leader>dw", fzf.diagnostics_workspace)

    -- fzf nice to haves
    vim.keymap.set('n', '<leader>cs', fzf.colorschemes)
    vim.keymap.set('n', '<leader>co', fzf.quickfix)
end

return M
