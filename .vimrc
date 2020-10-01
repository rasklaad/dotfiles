set mouse=a
set number
set hidden
let mapleader=","
set updatetime=100
set re=0 " yats.vim requirement

" don't give |ins-completion-menu| messages.
set shortmess+=c


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'stephpy/vim-yaml'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'arcticicestudio/nord-vim'
Plug 'Raimondi/delimitMate'
Plug 'sgur/vim-editorconfig'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'HerringtonDarkholme/yats.vim'
call plug#end()
let b:delimitMate_quotes = "\" '"
let delimitMate_matchpairs = "(:),[:],{:},<:>"

" Built it LSP
:lua <<EOF
  require'nvim_lsp'.tsserver.setup{cmd= { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" } }
EOF

nnoremap <silent> <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>

nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>K <cmd>lua vim.lsp.buf.signature_help()<CR>

nnoremap <silent> <leader>rn     <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>td   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>fr    <cmd>lua vim.lsp.buf.formatting()<CR>

" Autocompletion
autocmd BufEnter * lua require'completion'.on_attach()
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

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
