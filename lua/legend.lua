local M = {}

-- CLI commands organized by category with descriptions
local commands = {
  ["Git Worktree"] = {
    { cmd = "git worktree add ../feature-dir feature-branch", desc = "Checkout existing branch to a new directory alongside main repo" },
    { cmd = "git worktree add ../hotfix-dir -b hotfix/new-fix", desc = "Create new branch and checkout to new directory" },
    { cmd = "git worktree list", desc = "Show all worktrees with their paths and associated branches" },
    { cmd = "git worktree remove ../feature-dir", desc = "Remove worktree directory and clean up references" },
    { cmd = "git worktree prune", desc = "Clean up stale worktree references from deleted directories" },
    { cmd = "git worktree move ../old-dir ../new-dir", desc = "Move worktree from one directory location to another" },
    { cmd = "git worktree lock ../dir-name", desc = "Prevent accidental removal of worktree directory" },
    { cmd = "git worktree unlock ../dir-name", desc = "Allow removal of previously locked worktree directory" },
  },
  ["Git Rebase & Merge"] = {
    { cmd = "git rebase main", desc = "Reapply current branch commits on top of main branch" },
    { cmd = "git rebase -i HEAD~3", desc = "Interactive rebase to edit, squash, or reorder last 3 commits" },
    { cmd = "git rebase --continue", desc = "Continue rebase after resolving merge conflicts" },
    { cmd = "git rebase --abort", desc = "Cancel rebase and return to original branch state" },
    { cmd = "git merge feature-branch", desc = "Merge feature branch into current branch (fast-forward if possible)" },
    { cmd = "git merge --no-ff feature-branch", desc = "Force creation of merge commit even if fast-forward possible" },
    { cmd = "git merge --squash feature-branch", desc = "Apply all changes from branch as single commit without merge commit" },
    { cmd = "git cherry-pick commit-hash", desc = "Apply specific commit from another branch to current branch" },
  },
  ["Docker"] = {
    { cmd = "docker ps", desc = "List all currently running Docker containers" },
    { cmd = "docker images", desc = "List all Docker images stored locally on your system" },
    { cmd = "docker build -t name .", desc = "Build Docker image from Dockerfile in current directory with tag name" },
    { cmd = "docker run -it image", desc = "Run container interactively with terminal access" },
    { cmd = "docker exec -it container bash", desc = "Execute bash shell inside running container interactively" },
    { cmd = "docker-compose up -d", desc = "Start all services defined in docker-compose.yml in detached mode" },
    { cmd = "docker logs container", desc = "Display logs output from specified container" },
  },
  ["System"] = {
    { cmd = "cp -r source dest", desc = "Copy directory and all contents recursively to destination" },
    { cmd = "mv source dest", desc = "Move or rename file/directory from source to destination" },
    { cmd = "find . -name pattern", desc = "Search for files matching exact name pattern (case-sensitive)" },
    { cmd = "find . -iname pattern", desc = "Search for files matching name pattern (case-insensitive)" },
    { cmd = "grep -r pattern .", desc = "Search for text pattern recursively in all files from current directory" },
    { cmd = "rg pattern", desc = "Fast search for text pattern using ripgrep (faster than grep)" },
    { cmd = "rg -i pattern", desc = "Case-insensitive text search using ripgrep" },
    { cmd = "rg -t js pattern", desc = "Search for pattern only in JavaScript files" },
    { cmd = "rg -A 3 -B 3 pattern", desc = "Show 3 lines before and after each match for context" },
    { cmd = "tree", desc = "Display directory structure as hierarchical tree" },
    { cmd = "tree -L 2", desc = "Show directory tree limited to 2 levels deep" },
    { cmd = "tree -I node_modules", desc = "Show directory tree but ignore node_modules directory" },
    { cmd = "tree -a", desc = "Show directory tree including hidden files and directories" },
    { cmd = "chmod +x file.sh", desc = "Make file executable by adding execute permission" },
    { cmd = "chmod 644 file.txt", desc = "Set file permissions: read/write for owner, read-only for others" },
    { cmd = "chmod -R 755 directory/", desc = "Recursively set directory permissions: full access owner, read/execute others" },
  },
  ["FZF"] = {
    { cmd = "cd $(find . -type d | fzf)", desc = "Navigate to directory selected interactively with fuzzy finder" },
    { cmd = "vim $(fzf)", desc = "Open file selected with fuzzy finder in vim editor" },
    { cmd = "cat $(fzf)", desc = "Display contents of file selected with fuzzy finder" },
    { cmd = "git checkout $(git branch | fzf)", desc = "Switch to git branch selected interactively with fuzzy finder" },
    { cmd = "kill $(ps aux | fzf | awk '{print $2}')", desc = "Kill process selected interactively from process list" },
    { cmd = "docker exec -it $(docker ps | fzf | awk '{print $1}') bash", desc = "Enter bash shell of Docker container selected with fuzzy finder" },
    { cmd = "export VAR=$(env | fzf | cut -d= -f1)", desc = "Export environment variable selected with fuzzy finder" },
    { cmd = "history | fzf", desc = "Search and select command from shell history with fuzzy finder" },
  },
  ["Angular CLI"] = {
    { cmd = "ng generate component component-name", desc = "Create new Angular component with TypeScript, HTML, CSS, and test files" },
    { cmd = "ng g c component-name", desc = "Shorthand to create new Angular component (same as generate component)" },
    { cmd = "ng g c component-name --skip-tests", desc = "Create Angular component without generating test files" },
    { cmd = "ng test", desc = "Run all unit tests in watch mode with Karma test runner" },
    { cmd = "ng test --watch=false", desc = "Run all unit tests once without watch mode" },
    { cmd = "ng test --code-coverage", desc = "Run tests and generate code coverage report" },
    { cmd = "ng test --main src/path/to/component.spec.ts", desc = "Run specific test file using custom main entry point" },
  },
  ["Jest"] = {
    { cmd = "jest", desc = "Run all Jest tests in the project" },
    { cmd = "jest --watch", desc = "Run tests in watch mode, re-running when files change" },
    { cmd = "jest --coverage", desc = "Run tests and generate code coverage report" },
    { cmd = "jest path/to/test-file.spec.js", desc = "Run tests only from specified test file" },
    { cmd = "jest --testNamePattern='test name'", desc = "Run only tests matching the specified name pattern" },
    { cmd = "jest --testPathPattern=component", desc = "Run tests from files whose path matches the pattern" },
    { cmd = "jest --updateSnapshot", desc = "Update all snapshots to match current component output" },
  },
  ["Dotnet CLI"] = {
    { cmd = "dotnet new console -n ProjectName", desc = "Create new console application project with specified name" },
    { cmd = "dotnet new webapi -n ApiName", desc = "Create new ASP.NET Core Web API project with specified name" },
    { cmd = "dotnet build", desc = "Compile the project and all its dependencies" },
    { cmd = "dotnet run", desc = "Build and run the project from current directory" },
    { cmd = "dotnet test", desc = "Run all unit tests in the project using test runner" },
    { cmd = "dotnet test --logger trx", desc = "Run tests and output results in TRX format for reporting" },
    { cmd = "dotnet add package PackageName", desc = "Add NuGet package dependency to current project" },
    { cmd = "dotnet restore", desc = "Download and install all project dependencies from NuGet" },
  },
  ["Lua CLI"] = {
    { cmd = "lua script.lua", desc = "Execute Lua script file with Lua interpreter" },
    { cmd = "lua -i", desc = "Start interactive Lua REPL for testing code snippets" },
    { cmd = "lua -e 'print(\"hello\")'", desc = "Execute Lua code directly from command line" },
    { cmd = "lua -v", desc = "Display Lua interpreter version information" },
    { cmd = "luac -o output.luac script.lua", desc = "Compile Lua script to bytecode for faster execution" },
    { cmd = "luac -l script.lua", desc = "List compiled bytecode instructions from Lua script" },
    { cmd = "luarocks install package-name", desc = "Install Lua package from LuaRocks package manager" },
    { cmd = "luarocks list", desc = "List all installed Lua packages and their versions" },
  },
  ["Tmux Commands"] = {
    { cmd = "<prefix> + :", desc = "Enter tmux command line mode (default prefix is Ctrl-b)" },
    { cmd = "setw -g mouse on", desc = "Enable mouse support for scrolling and pane selection" },
    { cmd = "setw -g mouse off", desc = "Disable mouse support, rely on keyboard navigation only" },
    { cmd = "set -g status-position top", desc = "Move tmux status bar to top of terminal window" },
    { cmd = "set -g base-index 1", desc = "Start window numbering at 1 instead of default 0" },
    { cmd = "bind r source-file ~/.tmux.conf", desc = "Create keybinding to reload tmux configuration file" },
    { cmd = "swap-window -s 1 -t 2", desc = "Swap the positions of window 1 and window 2" },
    { cmd = "move-window -t 3", desc = "Move current window to index position 3" },
    { cmd = "list-sessions", desc = "Display all active tmux sessions with their details" },
    { cmd = "kill-session -t session-name", desc = "Terminate specified tmux session and all its windows" },
  },
}

local legend_buf = nil
local legend_win = nil

-- Create the legend window content
local function create_legend_content()
  local lines = {"CLI Command Legend", "==================", ""}

  for category, cmds in pairs(commands) do
    table.insert(lines, category .. ":")
    table.insert(lines, string.rep("-", #category + 1))

    for _, item in ipairs(cmds) do
      table.insert(lines, "  " .. item.cmd)
    end

    table.insert(lines, "")
  end

  table.insert(lines, "Press 'q' to close")

  return lines
end

-- Setup virtual text for descriptions
local function setup_virtual_text()
  local ns_id = vim.api.nvim_create_namespace('legend_descriptions')

  -- Clear existing virtual text
  vim.api.nvim_buf_clear_namespace(legend_buf, ns_id, 0, -1)

  local current_line = vim.api.nvim_win_get_cursor(legend_win)[1]
  local line_content = vim.api.nvim_buf_get_lines(legend_buf, current_line - 1, current_line, false)[1]

  if line_content and line_content:match("^  ") then
    local cmd = line_content:match("^  (.+)$")
    if cmd then
      -- Find matching command description
      for category, cmds in pairs(commands) do
        for _, item in ipairs(cmds) do
          if item.cmd == cmd then
            vim.api.nvim_buf_set_extmark(legend_buf, ns_id, current_line - 1, 0, {
              virt_lines = {{{"  → " .. item.desc, "Comment"}}},
              virt_lines_above = false,
            })
            break
          end
        end
      end
    end
  end
end

-- Toggle the legend window
function M.toggle_legend()
  if legend_win and vim.api.nvim_win_is_valid(legend_win) then
    vim.api.nvim_win_close(legend_win, true)
    legend_win = nil
    legend_buf = nil
    return
  end

  -- Create buffer if it doesn't exist
  if not legend_buf or not vim.api.nvim_buf_is_valid(legend_buf) then
    legend_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(legend_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(legend_buf, 'filetype', 'legend')

    -- Set content
    local lines = create_legend_content()
    vim.api.nvim_buf_set_lines(legend_buf, 0, -1, false, lines)

    -- Make buffer read-only
    vim.api.nvim_buf_set_option(legend_buf, 'modifiable', false)
  end

  -- Calculate window dimensions (centered, reasonable size)
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(30, vim.o.lines - 6)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create floating window
  legend_win = vim.api.nvim_open_win(legend_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    border = 'rounded',
    title = ' CLI Legend ',
    title_pos = 'center',
  })

  -- Set window options
  vim.api.nvim_win_set_option(legend_win, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

  -- Setup cursor movement handler for virtual text
  local function on_cursor_moved()
    if legend_win and vim.api.nvim_win_is_valid(legend_win) then
      setup_virtual_text()
    end
  end

  -- Set up autocmds for cursor movement
  local group = vim.api.nvim_create_augroup('LegendVirtualText', { clear = true })
  vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
    group = group,
    buffer = legend_buf,
    callback = on_cursor_moved,
  })

  -- Initial virtual text setup
  vim.defer_fn(setup_virtual_text, 50)

  -- Close on 'q' key
  vim.api.nvim_buf_set_keymap(legend_buf, 'n', 'q', '<cmd>lua require("legend").toggle_legend()<CR>',
    { noremap = true, silent = true })
end

return M
