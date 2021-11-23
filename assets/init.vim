" set up deoplete
let g:deoplete#enable_at_startup = 1
" deoplete rust/racer
let g:deoplete#sources#rust#racer_binary='/home/yhrc/.cargo/bin/racer'
"let g:deoplete#sources#rust#rust_source_path='/home/yhrc/rust/src'

" config ======================================================================

" TODO Directory Setting
syntax enable

set number
set relativenumber
set colorcolumn=80

set incsearch
set hlsearch
set showmatch
nnoremap ,<space> :nohlsearch<CR>

set scrolloff=7

set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

" GUI and colors
set mouse=a guicursor= nu rnu noshowmode background=dark tabpagemax=999
hi Normal guifg=#F8F8F2 guibg=#282A36
hi Statement ctermfg=yellow
hi LineNr ctermfg=darkgrey
hi CursorLineNr ctermfg=grey
hi ColorColumn ctermbg=black
hi FoldColumn ctermbg=none
hi Pmenu ctermbg=darkgrey
hi MatchParen cterm=bold ctermbg=darkgrey ctermfg=none
hi gitmessengerPopupNormal term=None ctermfg=255 ctermbg=234

set ttyfast		" set because of using a weird TERM (alacritty)

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'

nnoremap <F5> :make<CR>

let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ 'c': ['clangd'],
  \ }
