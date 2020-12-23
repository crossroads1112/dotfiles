"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <Leader>w saves the current file
let mapleader = ","
let g:mapleader = "," 
"Fast saving
nmap <Leader>w :w!<CR>

" Disable ex mode
nnoremap Q <nop>

" THE MOST IMPORTANT BINDING
inoremap jk <Esc>

" Should be default, but better safe than sorry
if &compatible
    set nocompatible
endif

" Autoread file after external command
set autoread

" Key sequence timeout
set ttimeout

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line numbers
set number

" Regular numbers in insert mode, relative numbers in normal mode
"set relativenumber
"autocmd InsertEnter * :set number
"autocmd InsertEnter * :set norelativenumber
"autocmd InsertLeave * :set relativenumber
"autocmd InsertLeave * :set nonumber

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Make splitting the window behave like you'd expect it to
set splitbelow
set splitright

" Change terminal title
set title
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    "set go=aAcig
    nnoremap <expr> ZZ (getline(1) ==# '' && 1 == line('$') ? 'ZZ' : ':w<CR>:bdelete<CR>')
    nnoremap <expr> ZQ (getline(1) ==# '' && 1 == line('$') ? 'ZZ' : ':bdelete<CR>')
    autocmd GUIEnter * set vb t_vb=

endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup

" Enable swaps and undo files though
set swapfile
set undofile

" Make sure these exist
if empty(glob('~/.vim/swp'))
    silent !mkdir -p ~/.vim/swp
endif
set directory=~/.vim/swp//

if empty(glob('~/.vim/undo'))
    silent !mkdir -p ~/.vim/undo
endif
set undodir=~/.vim/undo//

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Use code context to determine how much to indent
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" Set linebreak character
set showbreak=↪

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Remap VIM 0 to first non-blank character
map 0 ^

",/ disables turns off the highlighting after you've done a search
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" Navigate between windows with ALT + hjkl
if has("nvim") 
    map <A-h> <C-\><C-n><C-w>h
    map <A-j> <C-\><C-n><C-w>j
    map <A-k> <C-\><C-n><C-w>k
    map <A-l> <C-\><C-n><C-w>l
else 
    map <A-l> <C-W>l
    map <A-j> <C-W>j
    map <A-h> <C-W>h
    map <A-k> <C-W>k
endif

" Open Exporer
map <Leader>e :Explore<CR>

" Close the current buffer
map <Leader>bd :Bclose<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprev<CR>


" Close all the buffers
map <Leader>ba :1,1000 bd!<CR>

" Useful mappings for managing tabs
map <Leader>tn :tabnew<CR>
map <Leader>to :tabonly<CR>
map <Leader>tc :tabclose<CR>
map <Leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <Leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

" Switch CWD to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Move a line of text using Ctrl + [jk]
nmap <C-j> mz:m+<CR>`z
nmap <C-k> mz:m-2<CR>`z
vmap <C-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <C-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" Quickly open a buffer for scribble
map <Leader>q :e ~/buffer<CR>

" Toggle paste mode on and off
map <Leader>pp :setlocal paste!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else 
        return ''
    endif
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob(expand('~/.vim/dein/repos/github.com/Shougo/dein.vim')))
    silent !mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim 
    silent !git clone https://github.com/Shougo/dein.vim.git  ~/.vim/dein/repos/github.com/Shougo/dein.vim
endif

set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

"" General

if dein#load_state('~/.vim/dein')
    call dein#begin('~/.vim/dein')

    call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif

    call dein#add('Shougo/vimproc.vim', {
    \ 'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make',
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \    },
    \ })
    call dein#add('scrooloose/nerdcommenter')
    call dein#add('preservim/nerdtree')
    call dein#add('croaker/mustang-vim')
    call dein#add('vim-scripts/bufexplorer.zip')
    call dein#add('simnalamburt/vim-mundo')
    call dein#add('xolox/vim-misc')
    call dein#add('ervandew/supertab')

    " C/C++
    call dein#add('benekastah/neomake', { 'on_ft' : ['c', 'cpp']})
    call dein#add('vim-scripts/Conque-GDB', { 'on_ft' : ['c', 'cpp'] })

    " Python
    call dein#add('vim-scripts/pydoc.vim', { 'on_ft' : ['python'] })
    call dein#add('nvie/vim-flake8', { 'on_ft' : ['python'] })

    " Rust
    call dein#add('wting/rust.vim', { 'on_ft' : ['rust']})

    " Haskell
    "NeoBundle 'eagletmt/ghcmod-vim'
    "call dein#add('eagletmt/neco-ghc', { 'on_ft' : ['haskell'] } )
    "call dein#add('neovimhaskell/haskell-vim', { 'on_ft' : ['haskell'] })

    " LaTeX
    call dein#add('donRaphaco/neotex', { 'on_ft' : ['tex', 'latex'] })
    call dein#add('lervag/vimtex', { 'on_ft' : ['tex', 'latex'] })

    " Markdown
    call dein#add('JamshedVesuna/vim-markdown-preview', {'on_ft' : ['markdown']})

    "" Multilang
    "NeoBundleLazy 'Valloric/YouCompleteMe'
    "NeoBundle 'scrooloose/syntastic'
    call dein#add('autozimu/LanguageClient-neovim', { 'rev' : 'next', 'build' : 'bash install.sh' })

    " Coffeescript
    call dein#add('kchmck/vim-coffee-script')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax on

try 
    colo mustang
catch
    colo slate
endtry


let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

nnoremap <F5> :MundoToggle<CR>
nnoremap <F2> :BufExplorerVerticalSplit<CR>
let g:tex_flavor = 'latex'



"Open NERDTree when nvim starts
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Toggle NERDTree with Ctrl-N
map <C-n> :NERDTreeToggle<CR>
map <C-p> :pclose<CR>

"Show hidden files in NERDTree
let NERDTreeShowHidden=1


"let g:haskellmode_completion_ghc = 0
"let g:necoghc_enable_detailed_browse = 1
"let g:necoghc_use_stack = 1


let g:LanguageClient_serverCommands = { 'rust': ['rustup', 'run', 'stable', 'rls'], 'python': ['/usr/local/bin/pyls'], 'haskell': ['hie-wrapper', '--lsp'] } 
let g:deoplete#enable_at_startup = 1
"call deoplete#custom#option('sources', {
            "\ 'rust' : ['LanguageClient'],
            "\ 'haskell' : ['LanguageClient'],
            "\ 'python' : ['LanguageClient']
            "\ } )

let g:ConqueTerm_color = 2
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTermStartMessages = 0

"let g:ycm_python_binary_path = '/usr/bin/python3'
"let g:ycm_rust_src_path = $RUST_SRC_PATH

"let g:ycm_global_ycm_extra_conf = "/home/chad/.ycm_extra_conf.py"
"let g:ycm_filetype_whitelist = { '*': 1 }
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_python_binary_path = "python"
"let g:ycm_autoclose_preview_window_after_completion=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language Specific
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup TEX
    au!
    "au FileType latex,tex NeoBundleSource vimtex
    au FileType latex,tex set textwidth=70
    au FileType latex,tex set spell
augroup END

augroup MD
    au FileType md, markdown set textwidth=90
    au FileType md, markdown set spell
augroup END


augroup PYTHON
    au!
    au FileType python nnoremap <buffer> <Leader>2 :w<CR>:exec '!python2' shellescape(@%, 1)
    au FileType python nnoremap <buffer> <Leader>3 :w<CR>:exec '!python3' shellescape(@%, 1)
    au BufWrite *.py :call DeleteTrailingWS()

    " Plugins
    au FileType python nnoremap <Leader>d :Pydoc 
    au FileType python map <buffer> <Leader>x :call Flake8()<CR>
augroup END


augroup MAIL
    au!
    au FileType mail set spell
    au FileType mail set textwidth=72
    au FileType mail set formatoptions+=aw
    au FileType mail set noautoindent
augroup END

augroup YAML
    au!
    au FileType yaml set shiftwidth=2
    au FileType yaml set sts=2
    au FileType yaml set ts=2
augroup END

augroup FUNCTIONAL
    au!
    au FileType haskell,scheme set shiftwidth=2
    au FileType haskell,scheme set sts=2
    au FileType haskell,scheme set ts=2
    au FileType haskell setlocal omnifunc=neoghc#omnifunc
augroup END

augroup C_OR_CPP
    au!
    au FileType c,cpp set textwidth=79
    "au FileType c,cpp NeoBundleSource YouCompleteMe
    "au FileType c,cpp nnoremap <Leader>g :NeoBundleSource Conque-GDB
augroup END


"augroup MULTILANG
    "au! FileType c,cpp,python,rust,go,js NeoBundleSource YouCompleteMe
"augroup END

