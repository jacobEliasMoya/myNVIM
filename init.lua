-- ===============================
-- Bootstrap lazy.nvim
-- ===============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.env.CC = "gcc"

-- ===============================
-- Plugins
-- ===============================
require("lazy").setup({

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      format_on_save = { lsp_fallback = true },
    },
  },

  -- File Tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- Tree-sitter (with full language coverage)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- Core
          "lua",
          "vim",
          "bash",

          -- Web
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "scss",
          "json",
          "yaml",

          -- Content
          "markdown",
          "markdown_inline",

          -- Systems
          "rust",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Themes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          treesitter = true,
          telescope = true,
          mason = true,
          native_lsp = { enabled = true },
        },
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "storm",
      transparent = true,
    },
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "eslint",
          "html",
          "cssls",
          "tailwindcss",
          "jsonls",
          "rust_analyzer",
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        lua_ls = {
          settings = {
            Lua = { diagnostics = { globals = { "vim" } } },
          },
        },
        ts_ls = {},
        eslint = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        rust_analyzer = {},
      }

      for name, config in pairs(servers) do
        vim.lsp.config(name, vim.tbl_extend("force", {
          capabilities = capabilities,
        }, config))
        vim.lsp.enable({ name })
      end
    end,
  },

}, {
  rocks = { enabled = true, hererocks = false },
})

-- ===============================
-- Global Options
-- ===============================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- ===============================
-- ✅ TREE-SITTER FOLDING (KEY FIX)
-- ===============================
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- ===============================
-- Keymaps
-- ===============================
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>")

vim.keymap.set("n", "<leader>bb", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>bm", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.cmd.colorscheme("tokyonight")
