
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
" " To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Vundle configuration
filetype off  " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
"Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'godlygeek/tabular'
"Plugin 'tpope/vim-surround'
"Plugin 'majutsushi/tagbar'
"Plugin 'Valloric/YouCompleteMe'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'xoria256.vim'
Plugin 'guicolorscheme.vim'
Plugin 'desert256.vim'
Plugin 'xterm16.vim'
"Plugin 'ZoomWin'

filetype plugin indent on     " required!

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set tabstop=2
set shiftwidth=2
set smarttab
set expandtab

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=300		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase
" No temp and backup files on disk
set noswapfile
set nobackup
" Set default buffer to OS primary buffer
set clipboard=unnamedplus

" Always show statusline
set laststatus=2
" Statusline format
set statusline=%F%m%r%h%w\ [EOL=%{&ff}]\ [TYPE=%Y]\ [ORD=\%03.3b\ 0x\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
"Always show tabs
set showtabline=2

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Do not set mouse, it breaks copying from terminal
" if has('mouse')
"   set mouse=a
" endif

" Customize colors
colorscheme desert256

if &term =~ "xterm*"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;blue\x7"
  silent !echo -ne "\033]12;blue\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]12;black\007"
endif

set tags=tags,.tags,../tags

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  autocmd InsertLeave * if pumvisible() == 0|pclose|endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

"Cscope
if has ("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPEDB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

"Cscope bindings
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"Call NERDTree window
map <Leader>n :NERDTreeToggle<CR>

"Search for files and buffers
let g:fzf_command_prefix = 'Fzf'
map <C-f>f :FzfLines<CR>
map <C-f>c :FzfFiles<CR>
map <C-f>b :FzfBuffers<CR>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"Grep functionality
map <C-f>r :FzfRg<CR>

function! ChangeSpacesMatching(new_pat)
  if exists("w:m_unwanted_spaces")
    call matchdelete(w:m_unwanted_spaces)
  endif
  let w:m_unwanted_spaces=matchadd('ExtraWhitespace', a:new_pat)
endfunction

function! ShowUnwantedSpaces()
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  let w:m_unwanted_spaces=matchadd('ExtraWhitespace','\s\+$')
  autocmd WinEnter    * call ChangeSpacesMatching('\s\+$')
  autocmd InsertEnter * call ChangeSpacesMatching('\s\+\%#\@<!$')
  autocmd InsertLeave * call ChangeSpacesMatching('\s\+$')
endfunction

function! HideUnwantedSpaces()
  call matchdelete(w:m_unwanted_spaces)
  autocmd! WinEnter    * call ChangeSpacesMatching('\s\+$')
  autocmd! InsertEnter * call ChangeSpacesMatching('\s\+\%#\@<!$')
  autocmd! InsertLeave * call ChangeSpacesMatching('\s\+$')
  highlight clear ExtraWhitespace
endfunction

function! DoHighlightLL()
  if exists("g:line_max_length")
    if exists("w:m_hl_ll")
      call matchdelete(w:m_hl_ll)
    endif
    let w:m_hl_ll=matchadd('ErrorMsg', '\%>'. g:line_max_length . 'v.\+', -1)
  endif
endfunction

function! HighlightLongLines(max_length)
  call ShadowLongLines()
  let g:line_max_length = a:max_length
  call DoHighlightLL()
  autocmd WinEnter * call DoHighlightLL()
endfunction

function! ShadowLongLines()
  if exists("w:m_hl_ll")
    call matchdelete(w:m_hl_ll)
    unlet w:m_hl_ll
    autocmd! WinEnter * call DoHighlightLL()
  endif
  unlet! g:line_max_length
endfunction
