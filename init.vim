call plug#begin()

Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/vim-airline/vim-airline' 
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'Raimondi/delimitMate'
Plug 'mxw/vim-jsx'
Plug 'https://github.com/pangloss/vim-javascript'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'edersonferreira/dalton-vim'
Plug 'jistr/vim-nerdtree-tabs'

call plug#end()

syntax on

if (has("termguicolors"))
    set termguicolors
endif

set number
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set encoding=UTF-8
set background=dark

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:webdevicons_enable = 1
let base16colorspace=256 
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dalton'
colorscheme dalton

nmap <F1> :NERDTreeTabsToggle<CR>
nnoremap <C-p> :GFiles<CR>
nmap <C-l> :tabn<CR>
nmap <C-k> :tabp<CR>
nmap <C-n> :tabnew<CR>






