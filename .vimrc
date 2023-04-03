set mouse=a
set number
set hidden
let mapleader=","
let maplocalleader="\<Space>"
set updatetime=200


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'Raimondi/delimitMate'

Plug 'sgur/vim-editorconfig'

" theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'shaunsingh/nord.nvim'

Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Autocompletion
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

" Clojure-related
Plug 'Olical/conjure'
Plug 'p00f/nvim-ts-rainbow'
"Plug 'luochen1990/rainbow'
Plug 'PaterJason/cmp-conjure'

call plug#end()
let b:delimitMate_quotes = "\" '"
let delimitMate_matchpairs = "(:),[:],{:},<:>"


" LSP and autocompletion
set completeopt=menu,menuone,noinsert
:lua <<EOF
  local cmp = require'cmp'
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources(
     {{ name = 'nvim_lsp' }},
     {{ name = 'conjure' }},
     {{ name = 'buffer' }}
    ),
    completion = {
      completeopt = 'menu,menuone,noinsert'
    }
  })
  local caps = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local attach = function(client, bufnr)
    vim.cmd 
    [[
    augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    nnoremap <silent> <leader>ca     <cmd>lua vim.lsp.buf.code_action()<CR> 

    nnoremap <silent> <leader>hv     <cmd>lua vim.lsp.buf.hover()<CR> 
    nnoremap <silent> <leader><C-p>     <cmd>lua vim.lsp.buf.signature_help()<CR>

    nnoremap <silent> <leader>gd     <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> <leader>td     <cmd>lua vim.lsp.buf.type_definition()<CR>

    nnoremap <silent> <leader>rn     <cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <silent> <leader>gi     <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> <leader>gr     <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> <leader>ws     <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> gd             <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> <leader>fr     <cmd>lua vim.lsp.buf.format { async = true }<CR>
    ]]
  end
  require'lspconfig'.tsserver.setup{cmd= { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }, on_attach = attach, capabilities = caps}

  require'lspconfig'.clojure_lsp.setup{on_attach = attach, cmd= { "clojure-lsp"  }, filetypes = { "clojure", "edn" }, capabilities = caps}

  require'nvim-treesitter.configs'.setup{highlight = {enable = true}, ensure_installed = {"java", "clojure", "javascript"}, rainbow = {enable = true, extended_mode = true}}
EOF

" File browser
let NERDTreeShowHidden=1
nnoremap <leader>nt :NERDTreeToggle<CR>

" custom editing shortcuts
nnoremap <C-J> m`o<Esc>``
nnoremap <C-K> m`O<Esc>``

" Code search
nmap <leader>f :FZF<CR>
nmap <leader>ag :Ag<CR>

nmap <leader>b :Buffers<CR>

" Theme
" let g:rainbow_active = 1
let g:nord_italic = v:false
set termguicolors
colorscheme nord

let java_highlight_java_lang_ids=1
let g:airline_theme='bubblegum'
"nmap <leader>z :call <SID>SynStack()<CR>
"function! <SID>SynStack()
"  if !exists("*synstack")
"    return
"  endif
"  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
"endfunc
