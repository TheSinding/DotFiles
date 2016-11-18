"colorscheme badwolf  
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
call vundle#end()          
filetype plugin indent on   

syntax enable
set number
set showcmd
set cursorline
set wildmenu " Visual autocomplete
set showmatch " Highlight matching [({})]
set incsearch " search as characters is entered
set hlsearch " Highlight search
set tabstop=2
set laststatus=2
