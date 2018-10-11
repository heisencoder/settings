" Matt Ball's vimrc file

set nocompatible
filetype plugin indent on
syntax on
set expandtab
set shiftwidth=2
set softtabstop=2

" Make Vim behave like Windows, with Ctrl-C for copy, Ctrl-V for paste, etc.
" source $VIMRUNTIME/mswin.vim

" Keep contents copied to clipboard after vim exits:
autocmd VimLeave * call system("xsel -ib", getreg('+'))

"
" Fix PageUp/Dn
map <PageDown> :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-D>:set scroll=0<CR>
map <PageUp> :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-U>:set scroll=0<CR>
map <C-F> :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-D>:set scroll=0<CR>
map <C-B> :set scroll=0<CR>:set scroll^=2<CR>:set scroll-=1<CR><C-U>:set scroll=0<CR>

" Map space to center screen on cursor's row
nmap <space> zz

set ruler
set wildmode=longest,list,full  " Completion modes for wildcard expansion
set hlsearch
set showmode
set title
" set clipboard=unnamedplus
hi StatusLine ctermfg=Cyan
set laststatus=2
set colorcolumn=+1

" Automatically change the working directory to the current one
" au BufEnter * silent! lcd %:p:h

" Jump to last position when previously editing file
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Command to toggle Paste Mode
:map ,p :se invpaste paste?<return>

" Command to move between tabs
:map ,h :tabp<CR>
:map ,l :tabn<CR>
:map ,n :tabnew<CR>

" Automatically re-read unedited files that change outside VIM.
set autoread

" Automatically write files when switching buffers
set autowrite
" Force Autoreading of file when one of these events occurs:
" :au BufEnter,BufWinEnter,CursorHold,WinEnter,TabEnter,FocusGained,InsertEnter filename :checktime

" set mouse=a
set nowrap
" colorscheme elflord
set number  " Display line numbers

" Changes to change the color of the status bar in insert mode.
" Taken from http://vim.wikia.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode
" First, enable status line always.
set laststatus=2

" Now set it up to change the status line based on mode.

if version >= 700
  hi CursorLine ctermbg=darkblue cterm=none
  au InsertEnter * set cursorline
  au InsertLeave * set nocursorline
  " au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
  " au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
endif

" Load non-tracked config that is local to a particular computer
if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif
