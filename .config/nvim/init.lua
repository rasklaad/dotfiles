-- set runtimepath^=~/.vim runtimepath+=~/.vim/after
-- let &packpath = &runtimepath
-- source ~/.vimrc

vim.o.mouse = "a"
vim.o.number = true
vim.o.hidden = true
vim.g.mapleader = ","
vim.g.maplocalleader = " "
vim.g.updatetime = 200
vim.g.tabstop = 4
vim.g.shiftwidth = 4
vim.g.relativenumber = true
vim.g.rnu = true

-- Plugins using vim-plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('Raimondi/delimitMate')

Plug('sgur/vim-editorconfig')

-- theme
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('shaunsingh/nord.nvim')
Plug('https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git')

Plug('scrooloose/nerdtree')
Plug('junegunn/fzf.vim')
Plug('mhinz/vim-signify')
Plug('neovim/nvim-lspconfig')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = function()
  vim.call(":TSUpdate")
end })
-- Autocompletion
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')

-- Clojure-related
Plug('Olical/conjure')
Plug('PaterJason/cmp-conjure')

vim.call('plug#end')

-- delimitMate settings
vim.g.delimitMate_quotes = "\" '"
vim.g.delimitMate_matchpairs = "(:),[:],{:},<:>"


-- LSP and autocompletion setup
vim.o.completeopt = 'menu,menuone,noinsert'
local cmp = require'cmp'
cmp.setup({
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources(
    {{ name = 'nvim_lsp' }},
    {{ name = 'conjure' }},
    {{ name = 'buffer' }}
  ),
  completion = {
    completeopt = 'menu,menuone,noinsert'
  }
})

local caps = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local attach = function(client, bufnr)
  local supports_highlight = client.supports_method('textDocument/documentHighlight')
  local highlight_cmd = supports_highlight and "lua vim.lsp.buf.document_highlight()" or ""

  local augroup_cmds = table.concat({
      "autocmd! * <buffer>",
      "autocmd CursorHold <buffer> " .. highlight_cmd,
      "autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()"
  }, "\n")

  vim.cmd("augroup lsp_document_highlight")
  vim.cmd("au!")
  vim.cmd(augroup_cmds)
  vim.cmd("augroup END")

  -- Key mappings
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set('n', '<leader>fr', function()
        vim.lsp.buf.format { async = true }
      end, opts)
end

require'lspconfig'.clojure_lsp.setup{on_attach = attach, cmd= { "clojure-lsp"  }, filetypes = { "clojure", "edn" }, capabilities = caps}
require'lspconfig'.gopls.setup({on_attach = attach, settings = { gopls = { analyses = { unusedparams = true, }, staticcheck = true, gofumpt = true, }, }, })
require'lspconfig'.tailwindcss.setup{on_attach = attach}

require'nvim-treesitter.configs'.setup{highlight = {enable = true}, ensure_installed = {"java", "clojure", "javascript", "go", "html"}, rainbow = {enable = true, extended_mode = true}}

-- File browser
vim.g.NERDTreeShowHidden=1
vim.api.nvim_set_keymap('n', '<leader>nt', ':NERDTreeToggle<CR>', {noremap = true, silent = true})

local function set_formatprg()
    local formatprg_cmd = 'npx prettier --stdin-filepath %'
    vim.bo.formatprg = formatprg_cmd
end

vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = {"*.html" }, callback = set_formatprg })

-- Custom editing shortcuts
vim.api.nvim_set_keymap('n', '<C-J>', 'm`o<Esc>``', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', 'm`O<Esc>``', { noremap = true })

-- Code search
vim.api.nvim_set_keymap('n', '<leader>f', ':FZF<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ag', ':Ag<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', { noremap = true })

-- Theme
vim.g.nord_italic = false
vim.opt.termguicolors = true
vim.cmd('colorscheme nord')
vim.g.airline_theme='bubblegum'
vim.g.java_highlight_java_lang_ids=1

