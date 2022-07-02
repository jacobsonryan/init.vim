call plug#begin()
Plug 'nvim-lualine/lualine.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'terrortylor/nvim-comment'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'https://github.com/onsails/lspkind-nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'https://github.com/windwp/nvim-autopairs'
Plug 'akinsho/toggleterm.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'projekt0n/github-nvim-theme'
Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

syntax on

if (has("termguicolors"))
    set termguicolors
endif

set number
set relativenumber
" set numberwidth=5
set autoindent
set tabstop=2
set shiftwidth=2
set nohlsearch
set smarttab
set softtabstop=2
set encoding=UTF-8
set background=dark
set noswapfile
set nowrap
set completeopt=menu,menuone,noselect
set signcolumn=yes
let g:webdevicons_enable = 1
let base16colorspace=256 
let mapleader=" "
colorscheme github_dark_default
"hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=none guifg=none

nnoremap <C-p> :Telescope git_files<CR>
nmap <C-l> :tabn<CR>
nmap <C-h> :tabp<CR>
nmap <C-n> :tabnew<CR>
nmap <leader>n :NvimTreeToggle<cr>


lua << EOF
	local diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn" },
		symbols = { error = " ", warn = " ", hint = " ", info = " " },
		colored = true,
		update_in_insert = false,
		always_visible = true,
	}
require('lualine').setup { options = {
    icons_enabled = true,
    theme = 'github_dark_default',
		component_separators = '',
    section_separators = '',
		disabled_filetypes = {'NvimTree'},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {diagnostics},
		lualine_y = {'encoding','filetype'},
    lualine_z = {'location'}
  },
	tabline = {
		lualine_a = {'filename'},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {'tabs'}
	},
  extensions = {'nvim-tree'}
}
EOF

lua << EOF
require("nvim-tree").setup({
	diagnostics = {
		enable = true
	}
})
EOF

lua << EOF
require("nvim-lsp-installer").setup {}
EOF

lua << EOF
require("toggleterm").setup({
	size = 15,
	open_mapping = [[<C-t>]],
	hide_numbers = true,
	-- shade_terminals = true,
	-- shade_filetypes = {},
	-- shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		-- border = "curved",
		-- winblend = 0,
		-- highlights = {
			-- border = "Normal",
			-- background = "Normal",
		-- }
	}
})
EOF

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
      ["<Up>"] = cmp.mapping.select_prev_item(),
      ["<Down>"] = cmp.mapping.select_next_item(),
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
  local servers = {'tsserver', 'html', 'cssls', 'rust_analyzer', 'vimls', 'jsonls'}
  for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup{
          capabilities = capabilities	
      }
  end

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = true,
  severity_sort = false,
	virtual_text = { spacing = 4, prefix = "●" },
})
EOF
lua << EOF

local signs = { Error = " "  , Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
EOF

lua << EOF
require('telescope').setup{
    defaults = { 
	file_ignore_patterns = { "node_modules" },
	prompt_prefix = "$ "
    }
}
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
  ensure_installed = "all",
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

lua << EOF
require('nvim-autopairs').setup{}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))


-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
-- cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
EOF

" set list
" set listchars=eol:↵,tab:\ \ 
"↲
 




