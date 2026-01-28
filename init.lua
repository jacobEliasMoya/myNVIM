local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
vim.env.CC = "gcc"
require("lazy").setup({
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("nvim-tree").setup({
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true -- will change tree root to match opened file
                }
            })
        end
    }, {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
            })
        end,
    },{
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    "lua", "typescript", "javascript", "tsx", "html", "css",
                    "json", "markdown", "markdown_inline"
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                },
                indent = {enable = true}
            }
        end
    }, {
        "catppuccin/nvim",
        lazy = false,
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
                    native_lsp = {enabled = true}
                }
            })
            
            vim.cmd.colorscheme("catppuccin")
        end
    },  {
        "Tsuzat/NeoSolarized.nvim",
        lazy = true,
        priority = 1000,
        config = function()
        end,
    },{
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline", "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets"
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({select = true})
                }),
                sources = cmp.config.sources({
                    {name = "nvim_lsp"}, {name = "luasnip"}, {name = "buffer"},
                    {name = "path"}
                })
            })

            -- Cmdline completion
            cmp.setup.cmdline({"/", "?"}, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {{name = "buffer"}}
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({{name = "path"}},
                    {{name = "cmdline"}})
            })
        end
    }, -- mason
    {
        "williamboman/mason.nvim",
        config = function() require("mason").setup() end
    }, {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"williamboman/mason.nvim"},
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "ts_ls", "eslint", "html", "cssls", "tailwindcss",
                    "jsonls"
                }

            })
        end
    }, -- telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {"nvim-lua/plenary.nvim"}, -- Required by Telescope
        config = function() require("telescope").setup() end
    }, -- lsp support
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = {
                lua_ls = {
                    settings = {Lua = {diagnostics = {globals = {"vim"}}}}
                },
                ts_ls = {},
                eslint = {},
                html = {},
                cssls = {},
                tailwindcss = {},
                jsonls = {},
                rust_analyzer = {}
            }

            for name, config in pairs(servers) do
                vim.lsp.config(name, vim.tbl_extend("force", {
                    capabilities = capabilities
                }, config))
                vim.lsp.enable({name})
            end
        end
    }

}, {
        -- options
        rocks = {enabled = true, hererocks = false}
    })

vim.g.mapleader = " " 
vim.g.maplocalleader = " " 

vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation (4 spaces, fully consistent)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {desc = "Find Files"})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {desc = "Find Text"})
vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>", {desc = "Toggle treesitter"})


