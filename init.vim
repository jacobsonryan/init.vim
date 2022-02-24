call plug#begin()
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/vim-airline/vim-airline' 
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'ryanoasis/vim-devicons'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'terrortylor/nvim-comment'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'https://github.com/onsails/lspkind-nvim'
Plug 'windwp/nvim-ts-autotag'
call plug#end()

syntax on

if (has("termguicolors"))
    set termguicolors
endif

set number
set relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set smarttab
set softtabstop=2
set encoding=UTF-8
set background=dark
set noswapfile
set nowrap
set completeopt=menu,menuone,noselect

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:webdevicons_enable = 1
let base16colorspace=256 
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='gruvbox'
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox

"hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=none guifg=none

nmap <F1> :NERDTreeTabsToggle<CR>
nnoremap <C-p> :Telescope git_files<CR>
nmap <C-l> :tabn<CR>
nmap <C-h> :tabp<CR>
nmap <C-n> :tabnew<CR>

lua << EOF
local lspkind = require('lspkind')
local cmp = require("cmp")
cmp.setup({
   snippet = {
      expand = function(args)
         require('luasnip').lsp_expand(args.body)
      end,
   },
   mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
         behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      }),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
   },
   sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer" }
   },
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        path = "[path]",
        luasnip = "[snip]",
      },
    },
  },
})

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local nvim_lsp = require('lspconfig')
  local servers = {'tsserver', 'html', 'cssls'}
  for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup{
          capabilities = capabilities	
      }
  end

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

EOF


lua << EOF
require('telescope').setup{
    defaults = { 
	file_ignore_patterns = { "node_modules" },
	prompt_prefix = "$ "
    }
}
require('telescope').load_extension('fzf')
EOF

lua << EOF
require('nvim_comment').setup({
	line_mapping = "<C-c>",
	operator_mapping = "<C-_>",
	comment_empty = false,
  	hook = function()
    		require("ts_context_commentstring.internal").update_commentstring()
  	end,
})
EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  sync_install = false,
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    config = {
      javascript = {
        __default = '// %s',
        jsx_element = '{/* %s */}',
        jsx_attribute = '// %s',
        comment = '// %s'
      }
    }
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF












