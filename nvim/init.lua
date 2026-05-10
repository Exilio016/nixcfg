local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

local opts = {}
local plugins = {
    require('plugins/yazi'),
    { 'neovim/nvim-lspconfig' },
    { 
        'saghen/blink.cmp', branch = 'v1',
        opts = {
            keymap = { preset = 'super-tab' },
            sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
            signature = { enabled = true },

        },
    },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
          { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
          { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
          { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
          { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        },
    },
    {
      'uZer/pywal16.nvim',
      -- for local dev replace with:
      -- dir = '~/your/path/pywal16.nvim',
      config = function()
        vim.cmd.colorscheme("pywal16")
      end,
    },
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
}
require("lazy").setup(plugins, opts)

local lsp_configs = {}
-- Find all lua files in the lsp configuration directory
for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

-- Enable all found servers
for _, server in ipairs(lsp_configs) do
  local config = vim.lsp.config[server]
  if config and config.cmd then
      local executable = type(config.cmd) == "table" and config.cmd[1] or config.cmd
      if type(executable) == 'string' and vim.fn.executable(executable) == 1 then
        vim.lsp.enable(server)
      end
      -- FIXME: handle function cmd
  end
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.g.have_nerd_font = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.cursorline = true
vim.opt.inccommand = "split"

local wal_cache = os.getenv("HOME") .. "/.cache/wal/colors-wal.vim"
local handle = vim.loop.new_fs_event()
handle:start(wal_cache, {}, vim.schedule_wrap(function(err, filename, events)
    if err then return end
    vim.cmd('source ' .. wal_cache)
    vim.cmd.colorscheme("pywal16")
end))
