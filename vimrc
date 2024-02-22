filetype on " Enable type file detection.
filetype plugin on " Enable plugins and load plugin for the detected file type.
filetype indent on " Load an indent file for the detected file type.

" Ref: https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/
" zo - to open a single fold under the cursor.
" zc - to close the fold under the cursor.
" zR - to open all folds.
" zM - to close all folds.
" SET ---------------------------------------------------------------- {{{

set tabstop=2
set shiftwidth=2
set expandtab
set regexpengine=0 " Automatically choose the regular expression engine.
set magic " Enable regular expression magic.
set number " Display line number.
set hlsearch " Highlight search result.
set incsearch " Shows incremental search results as you type.
set wildmenu " Enables enhanced command-line completion.
set showcmd " Shows incomplete commands in status.
set autoindent " Automatically sets the autoindent option.
set smartindent " Enables smart auto-indenting.
set title " Sets window title in Vim.
set laststatus=2 " Always displays the status line.
set statusline=%F\ %m%r%h%w%=[%l/%L]\ [%p%%] " Displays file info, modification status.
syntax enable " Enables syntax highlighting in Vim.
set smartcase " Case-sensitive if lowercase typed.
set nocompatible " Ensures Vim is not in vi-compatible mode.
set mouse=a " Enable mouse.
set autoread " Automatically updates files in Vim.
" set spell " Enable spell checking.
set linebreak " Enables automatic long line breaking.
set hidden " Allows switching between buffers without saving.
set encoding=utf-8 " Sets file encoding to UTF-8.
set history=1000 " Set the commands to save in history default number is 20.
set showmode " Show the mode you are on the last line.
set showmatch " Show matching words during a search.
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildmode=list:longest " Make wildmenu behave like similar to Bash completion.

" }}}


" PLUGINS ---------------------------------------------------------------- {{{

" Plugin code goes here.
" Check and create required directories
for dir in ['autoload', 'backup', 'colors', 'plugged']
    if !isdirectory(expand("~/.vim/" . dir))
        silent execute "!mkdir -p ~/.vim/" . dir
    endif
endfor

" Check if Vim-Plug is already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  " Download and install Vim-Plug
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
call plug#end()

"To install -> :PlugInstall

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.
" Show file full path
nnoremap P :echo expand('%:p')<CR>

" Map the F5 key to run a Python script inside Vim.
" I map F5 to a chain of commands here.
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python.
nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}


" VIMSCRIPT ------------------------------------------------------------- {{{
" How to Add Some Vimscripting
" Vimscript is a scripting language that lets you create scripts using variables, if else statements, and functions. Auto commands are waiting for events to occur in order to trigger a command.

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif


" }}}


" COLOR SCHEME ------------------------------------------------------------ {{{

"colorscheme synthwave84
"colorscheme atom-dark
"colorscheme atom-dark-256
"colorscheme molokai
"colorscheme onehalfdark
"colorscheme tokyonight

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Status bar code goes here.

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Help-> :help <cmd>
" eg. :help showcmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
