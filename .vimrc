" This is a collection of settings I have stolen from other people on the internet.
" ==================================================================================

" Use Vim settings, rather then Vi settings 
" This must be first, because it changes other options as a side effect.
set nocompatible

" ================ General Config ====================

set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set autoread                    "Reload files changed outside vim
set ruler                       "Show line number and column in status bar

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on
colorscheme desert

" The <Leader> key is mapped to \ by default. So if you have a map of <Leader>t, you can execute it by default with \+t. For more detail or re-assigning it using the mapleader variable, see :help leader
" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.
let mapleader=","

" ================ Mappings =========================

"To generate Escape, jj has to be typed quickly. :help 'timeout'
:imap jj <Esc>

" ================ Status Line ======================

set statusline=2

" ================ Turn Off Swap Files ==============

"set noswapfile
"set nobackup
"set nowb

" ================ Indentation ======================

set autoindent			"Copy indent from current line when starting a new line
set smartindent			"Do smart autoindenting when starting a new line. For some dumb reason this indent is removed when the first char is a '#'
set smarttab
"set softtabstop=4		"Number of spaces that a <Tab> counts for while performing editing operations. I'm using tabs though so this isn't really applicable
set shiftwidth=4		"Number of spaces to use for each step of (auto)indent. It's recommended to just set this equal to tabstop when using hard tabs
set tabstop=4			"Number of spaces that a <Tab> in the file counts for. So, when Vim opens a file and reads a <TAB> character, it uses that many spaces to visually show the <TAB>.
set noexpandtab			"Things like a makefile treat tabs differently than spaces and that's not an issue I want be banging my head against

"filetype plugin on
"filetype indent on

" Display tabs and trailing spaces visually
set list
set listchars=tab:>-,space:·,trail:·,extends:>,precedes:<

set nowrap          "Don't wrap lines
"set linebreak      "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

"set wildmode=list:longest
"set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
"set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
"set wildignore+=*vim/backups*
"set wildignore+=*sass-cache*
"set wildignore+=*DS_Store*
"set wildignore+=vendor/rails/**
"set wildignore+=vendor/cache/**
"set wildignore+=*.gem
"set wildignore+=log/**
"set wildignore+=tmp/**
"set wildignore+=*.png,*.jpg,*.gif

"
" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
