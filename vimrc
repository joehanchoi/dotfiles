"-----------------------------------------------------------------------------
" PRELIMINARY SETUP
"-----------------------------------------------------------------------------
set shell=/bin/bash " Use bash shell
set nocompatible    " Use Vim settings, rather than vi
call plug#begin('~/.vim/plugged')

"-----------------------------------------------------------------------------
" PLUGINS
"-----------------------------------------------------------------------------
Plug 'tpope/vim-sensible'                        " sensible defaults
Plug 'tomtom/tcomment_vim'                       " makes commenting easy
Plug 'vim-scripts/Solarized'                     " solarized color scheme
Plug 'godlygeek/tabular'                         " Automatic indent completion
Plug 'plasticboy/vim-markdown', { 'for': 'mkd' } " vim markdown syntax highlighting!
Plug 'kien/ctrlp.vim'                            " Fuzzy path finder
Plug 'scrooloose/nerdtree'                       " Folder management
Plug 'Lokaltog/vim-easymotion'                   " Fast text movement
Plug 'bling/vim-airline'                         " Airline status bar
Plug 'terryma/vim-multiple-cursors'              " Multiple cursors
Plug 'myusuf3/numbers.vim'                       " Adds smart number lines
Plug 'gregsexton/MatchTag'                       " Match tags with highlighting
Plug 'Shougo/neocomplete.vim'                    " Autocompletion
Plug 'sjl/gundo.vim'                             " Undo tree pane
Plug 'tpope/vim-vinegar'                         " Avoid project drawer plugin
Plug 'tpope/vim-repeat'                          " Enable repeating plugin maps with .
Plug 'svermeulen/vim-easyclip'                   " Simplified clipboard functionality
Plug 'Shougo/neosnippet'                         " Text expansion
Plug 'christoomey/vim-tmux-navigator'            " Vim and tmux seamless navigation
Plug 'davidhalter/jedi-vim'                      " Python code completion
Plug 'scrooloose/syntastic'                      " Syntax checker
Plug 'majutsushi/tagbar'                         " Tag navigation
Plug 'rking/ag.vim'                              " Keyword searcher
Plug 'tpope/vim-unimpaired'                      " Paired mapping
Plug 'Raimondi/delimitMate'                      " Add delimiters automatically
" Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }

call plug#end()
" call vundle#end()
" filetype plugin indent on

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
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"-----------------------------------------------------------------------------
" PLUGIN SPECIFIC SETTINGS
"-----------------------------------------------------------------------------
"--- EASY MOTION -------------------------------------------------------------
" Disable default key maps
let g:EasyMotion_do_mapping = 0
" Case insensitive seach
let g:EasyMotion_smartcase = 1
" Bi-Directional Search
nmap s <Plug>(easymotion-s2)

"--- NEOCOMPLETE -------------------------------------------------------------
" Hide popupmenu for python information
autocmd FileType python setlocal completeopt-=preview
" Start neocomplete at startup, disable autocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#disable_auto_complete = 1
" Smart close popup when backspacing
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close Popup with <Enter>
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
endfunction
" Tab to cycle through, shift tab for backwards
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-Space> to toggle auto-complete
inoremap <expr><Nul>  pumvisible() ? "\<C-e>" :
	\ neocomplete#start_manual_complete()
" Python Completions for neocomplete
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python =
\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

"--- GUNDO -------------------------------------------------------------------
" Toggle Gundo with <Leader>gun
map <Leader>gun :GundoToggle<CR>

"--- NEOSNIPPET --------------------------------------------------------------
" Command+K for expansion
imap <C-c> <Plug>(neosnippet_expand_or_jump)
smap <C-c> <Plug>(neosnippet_expand_or_jump)
xmap <C-c> <Plug>(neosnippet_expand_target)
" Custom snippet directory
let g:neosnippet#snippets_directory='~/.vim/snippets/'

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
    \ 'ctagsbin' : '/Users/joechoi/.vim/bundle/markdown2ctags/markdown2ctags.py',
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

"--- DELIMITMATE -------------------------------------------------------------
" Disable in certain filetypes
let delimitMate_excluded_ft = "vim"

"--- JEDI-VIM ----------------------------------------------------------------
" Disable function popup
let g:jedi#show_call_signatures = "1"

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

" Set columncolor bar
autocmd FileType cpp,c,cxx,h,hpp,python,sh,vim,mkd  setlocal cc=80

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
set mouse=a
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
" Ignore blank lines for indent
function! IndentIgnoringBlanks(child)
  let lnum = v:lnum
  while v:lnum > 1 && getline(v:lnum-1) == ""
    normal k
    let v:lnum = v:lnum - 1
  endwhile
  if a:child == ""
    if ! &l:autoindent
      return 0
    elseif &l:cindent
      return cindent(v:lnum)
    endif
  else
    exec "let indent=".a:child
    if indent != -1
      return indent
    endif
  endif
  if v:lnum == lnum && lnum != 1
    return -1
  endif
  let next = nextnonblank(lnum)
  if next == lnum
    return -1
  endif
  if next != 0 && next-lnum <= lnum-v:lnum
    return indent(next)
  else
    return indent(v:lnum-1)
  endif
endfunction
command! -bar IndentIgnoringBlanks
            \ if match(&l:indentexpr,'IndentIgnoringBlanks') == -1 |
            \   if &l:indentexpr == '' |
            \     let b:blanks_indentkeys = &l:indentkeys |
            \     if &l:cindent |
            \       let &l:indentkeys = &l:cinkeys |
            \     else |
            \       setlocal indentkeys=!^F,o,O |
            \     endif |
            \   endif |
            \   let b:blanks_indentexpr = &l:indentexpr |
            \   let &l:indentexpr = "IndentIgnoringBlanks('".
            \   substitute(&l:indentexpr,"'","''","g")."')" |
            \ endif
command! -bar IndentNormally
            \ if exists('b:blanks_indentexpr') |
            \   let &l:indentexpr = b:blanks_indentexpr |
            \ endif |
            \ if exists('b:blanks_indentkeys') |
            \   let &l:indentkeys = b:blanks_indentkeys |
            \ endif
augroup IndentIgnoringBlanks
  au!
  au FileType * IndentIgnoringBlanks
augroup END
