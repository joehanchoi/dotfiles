"-----------------------------------------------------------------------------
" PRELIMINARY SETUP
"-----------------------------------------------------------------------------
set shell=/bin/bash               " Use bash shell
set nocompatible                  " Use Vim settings, rather than vi
call plug#begin('~/.vim/plugged') " Use Vim-Plug

"-----------------------------------------------------------------------------
" PLUGINS
"-----------------------------------------------------------------------------
Plug 'tpope/vim-sensible'               " Sensible defaults
Plug 'tomtom/tcomment_vim'              " Makes commenting easy
Plug 'vim-scripts/Solarized'            " Solarized color scheme
Plug 'godlygeek/tabular'                " Automatic indent completion
Plug 'kien/ctrlp.vim'                   " Fuzzy path finder
Plug 'joehanchoi/nerdtree'              " Folder management
Plug 'bling/vim-airline'                " Airline status bar
Plug 'terryma/vim-multiple-cursors'     " Multiple cursors
Plug 'myusuf3/numbers.vim'              " Adds smart number lines
Plug 'gregsexton/MatchTag'              " Match tags with highlighting
Plug 'Shougo/neocomplete.vim'           " Autocompletion
Plug 'sjl/gundo.vim'                    " Undo tree pane
Plug 'tpope/vim-vinegar'                " Avoid project drawer plugin
Plug 'tpope/vim-repeat'                 " Enable repeating plugin maps with .
Plug 'svermeulen/vim-easyclip'          " Simplified clipboard functionality
Plug 'christoomey/vim-tmux-navigator'   " Vim and tmux seamless navigation
Plug 'scrooloose/syntastic'             " Syntax checker
Plug 'majutsushi/tagbar'                " Tag navigation
Plug 'rking/ag.vim'                     " Keyword searcher
Plug 'tpope/vim-unimpaired'             " Paired mapping
Plug 'tpope/vim-surround'               " Mappings to change surroundings
Plug 'justinmk/vim-sneak'               " Fast text movement
Plug 'joehanchoi/vim-jinja'             " Jinja syntax highlighting
Plug 'Yggdroot/indentLine'              " Show indentation visually
Plug 'Shougo/neosnippet.vim'            " Code snippets
Plug 'hynek/vim-python-pep8-indent'     " Correct indentation for Python
Plug 'Raimondi/delimitMate'             " Automatic closing of brackets
Plug 'hdima/python-syntax'              " Enhanced Python syntax highlighting
Plug 'mustache/vim-mustache-handlebars' " Mustache/Handlebars syntax highlighting
Plug 'joehanchoi/vim-markdown'          " Markdown syntax highlighting
Plug 'tpope/vim-fugitive'               " Git commands

call plug#end()

"-----------------------------------------------------------------------------
" MAPPINGS
"-----------------------------------------------------------------------------
" Map <Leader> to <Space>
map <Space><Space> <Leader><Leader>
map <Space> <Leader>

" Map marks to 'gm'
nnoremap gm m

"-----------------------------------------------------------------------------
" VIM SETTINGS
"-----------------------------------------------------------------------------
" Ignore case in command mode, but keep search case-sensitive if beginning
" with a capital letter
set ignorecase
set smartcase

" Disable auto-commenting
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"-----------------------------------------------------------------------------
" PLUGIN SPECIFIC SETTINGS
"-----------------------------------------------------------------------------
"--- NEOCOMPLETE -------------------------------------------------------------
" Start neocomplete at startup, disable autocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#disable_auto_complete = 0
" Smart close popup when backspacing
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close Popup with <Enter>
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
endfunction
" Disable preview window
set completeopt-=preview

"--- GUNDO -------------------------------------------------------------------
" Toggle Gundo with <Leader>gun
map <Leader>gun :GundoToggle<CR>

"--- SYNTASTIC ---------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting = 0
let g:syntastic_enable_balloons = 0
" Python chckers
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_python_exec = '/usr/local/bin/python3'

"--- TAGBAR ------------------------------------------------------------------
" Add a toggle leader
nnoremap <leader>tag :TagbarToggle<CR>
" Add support for markdown files in tagbar.
let g:tagbar_type_mkd = {
    \ 'ctagstype': 'mkd',
    \ 'ctagsbin' : '~/.vim/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
	\ 's:sections',
	\ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
	\ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
" Focus Tagbar automatically when called
let g:tagbar_autofocus = 1

"--- MULTIPLE CURSORS --------------------------------------------------------
" Compatability with neocomplete
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction

"--- SNEAK -------------------------------------------------------------------
" Enable streak
let g:sneak#streak = 1

" Enable keys
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S

" Enable case-insensitive search
let g:sneak#use_ic_scs = 1

" Colors
augroup SneakPluginColors
   autocmd!
   autocmd ColorScheme * hi SneakPluginTarget ctermfg=235 ctermbg=136
   autocmd ColorScheme * hi SneakStreakTarget ctermfg=235 ctermbg=136
   autocmd ColorScheme * hi SneakStreakMask ctermfg=136 ctermbg=136
augroup END

"--- NEOSNIPPET --------------------------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/snippets'

" Disable runtime snippets (use custom snippets only)
let g:neosnippet#disable_runtime_snippets = {'_' : 1,}

"--- INDENT-LINE -------------------------------------------------------------
let g:indentLine_color_term = 236

"--- PYTHON-SYNTAX -----------------------------------------------------------
let python_highlight_space_errors = 0
let python_highlight_indent_errors = 0
let python_print_as_function = 0
let python_highlight_all = 1

"--- FUGITIVE ----------------------------------------------------------------
nnoremap <Leader>gs :Gstatus<CR>

"-----------------------------------------------------------------------------
" USER INTERFACE
"-----------------------------------------------------------------------------
set noeb vb t_vb=               " gets rid of beeping
set number                      " Show line numbers
let g:airline_powerline_fonts=1 " Enable Powerline symbols for Airline
let g:vim_markdown_math=1       " Allow LaTeX math syntax highlighting
let g:solarized_termcolors=16   " correctly colored for terminal vim
set background=dark             " required for solarized dark
colorscheme solarized           " set color scheme to solarized dark
set nofoldenable                " Disable folding
set nowrap                      " Disable line wrap
set noswapfile                  " No backups

" Set columncolor bar
autocmd FileType cpp,c,cxx,h,hpp,python,sh,vim,mkd,jinja,html,lua setlocal cc=80

"--- INTEGRATION -------------------------------------------------------------
" Change cursor when in Insert mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" Enable mouse anywhere
" set mouse=a
" Enable Vim to use OSX clipboard
set clipboard=unnamed
" Timeout fix for inserting new line above with 'O' - for tmux
set ttimeoutlen=100
" Strip whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
