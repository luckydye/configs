set tabstop=4
set autoindent
set number
set wildmode=longest,list
syntax on
set mouse=a
set clipboard=unnamedplus
filetype plugin on

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()
