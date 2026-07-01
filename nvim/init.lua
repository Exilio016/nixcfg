local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
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
        "mason-org/mason-lspconfig.nvim", opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
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
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }
}
require("lazy").setup(plugins, opts)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local bufnr = args.buf
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    map('gd', vim.lsp.buf.definition, 'Goto Definition')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<leader>cf', vim.lsp.buf.format, 'Code Format')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>cd', vim.diagnostic.open_float, 'Code Diagnostic')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  end,
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('nvim-treesitter').install { 'all' }
vim.api.nvim_create_autocmd('FileType', {
    pattern = { '<filetype>' },
    callback = function()
	vim.treesitter.start()
    	vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    	vim.wo[0][0].foldmethod = 'expr'
    end,
})

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
vim.opt.winborder = "rounded"
vim.opt.cmdheight = 0

local wal_cache = os.getenv("HOME") .. "/.cache/wal/colors-wal.vim"
local handle = vim.loop.new_fs_event()
handle:start(wal_cache, {}, vim.schedule_wrap(function(err, filename, events)
    if err then return end
    vim.cmd('source ' .. wal_cache)
    vim.cmd.colorscheme("pywal16")
end))

require('lualine').setup {
  options = {
    theme = 'pywal',
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch', 'searchcount', 'selectioncount' },
    lualine_c = {
      '%=', --[[ add your center components here in place of this comment ]]
    },
    lualine_x = {},
    lualine_y = { 'filetype', 'lsp_status', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {'mason'},
}
