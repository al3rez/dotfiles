GuiFont Inconsolata Nerd Font Mono:h11

call plug#begin('~/.vim/plugged')
Plug 'wincent/command-t'
Plug 'tpope/vim-endwise'
call plug#end()

" Auto-detect file types
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Auto-reload when file changes
set autoread

" Escape using jk in all modes (insert, visual, terminal)
inoremap jk <esc>
xnoremap jk <esc>
tnoremap jk <c-\><c-n>
cnoremap jk <esc>


" Do smart auto-indenting when starting a new line
set smartindent

function! GitHead()
  let l:branchname = system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  return strlen(l:branchname) > 0 ? l:branchname : ''
endfunction


" Display a parenthesized file type after file name in status line
set laststatus=2
set statusline=%<%f\ \[%{GitHead()}\]\ %-4(%m%)%=%-19(%3l,%02c%03V%)


" Display line numbers
set number


" Use comma as <leader>
" NOTE: Which will be used in mapping combinations. For example; `<leader>p`
" translates to `,p` which could be mapped to a function call, command or etc.
let mapleader=","


" Expand %% to current file directory
" NOTE: This makes creating non-existent directories easier. For example; when
" you :e /project/dir1/file and `dir1` doesn't exist you can simply create the
" directory with `:!mkdir %%` instead of typing the full path.
cnoremap %% <C-R>=expand('%:h').'/'<cr>


" Edit files under current file directory
map <leader>e :edit %%


" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
nnoremap <leader>n :call RenameFile()<cr>


" Use ripgrep as grep program
" NOTE: Makes greppig 💉 (bloody) fast
" FAQ: You have to install ripgrep (`brew install ripgrep`)
set grepprg=rg\ --vimgrep\ --color=never\ --no-heading


" NOTE: Opens a buffer containing the search results in linked form,
" suppresses grep full screen output and prevents jumping to the first match
" automatically
" SEE: https://neovim.io/doc/user/quickfix.html#grep
command! -nargs=+ Rg execute 'silent grep! <args>' | copen | redraw!


" Search the word under the cursor
nnoremap K :Rg "\b<c-r><c-w>\b"<cr>


" Bind \ (backward slash) to grep shortcut to make searching faster
nnoremap \ :Rg<SPACE>


" Delete the buffer without losing/closing the window split
" SEE: https://github.com/neovim/neovim/issues/2434
nnoremap <leader>d :setl bufhidden=delete\|bnext<cr>

" Set color-scheme
colorscheme github


" Define file type specific settings
augroup rubyGroup
	autocmd FileType ruby set ts=2 sts=2 sw=2 et
	function! OpenTestAlternate()
	  let new_file = AlternateForCurrentFile()
	  exec ':e ' . new_file
	endfunction
	function! AlternateForCurrentFile()
	  let current_file = expand("%")
	  let new_file = current_file
	  let in_spec = match(current_file, '^spec/') != -1
	  let going_to_spec = !in_spec
	  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<workers\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1  || match(current_file, '\<services\>') != -1 || match(current_file, '\<jobs\>') != -1

	  if going_to_spec
	    if in_app
	      let new_file = substitute(new_file, '^app/', '', '')
	    end
	    let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
	    let new_file = 'spec/' . new_file
	  else
	    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
	    let new_file = substitute(new_file, '^spec/', '', '')
	    if in_app
	      let new_file = 'app/' . new_file
	    end
	  endif
	  return new_file
	endfunction
	nnoremap <leader>. :call OpenTestAlternate()<cr>
augroup end

augroup jsGroup
	autocmd FileType javascript.jsx set ts=2 sts=2 sw=2 et
	autocmd FileType javascript set ts=2 sts=2 sw=2 et
augroup end

augroup goGroup
	autocmd FileType go set ts=4 sts=4 sw=4 et
	autocmd FileType go nnoremap <leader>. :GoAlternate<cr>
	autocmd FileType go nnoremap <leader>i :GoIfErr<cr>
augroup end

augroup elixirGroup
	autocmd BufRead,BufNewFile *.ex,*.exs set filetype=elixir
	autocmd BufRead,BufNewFile *.eex set filetype=eelixir
	autocmd FileType elixir set ts=2 sts=2 sw=2 et
	autocmd FileType eelixir set ts=2 sts=2 sw=2 et
augroup end


" Make vertical split separator less than a full column wide
" SEE: https://vi.stackexchange.com/a/2942
" hi VertSplit cterm=none ctermbg=bg


" Remove unfocused tab line underline
hi TabLineFill ctermfg=bg ctermbg=fg cterm=none
hi TabLineSel ctermfg=fg ctermbg=bg cterm=none
hi TabLine ctermfg=bg ctermbg=fg cterm=none


" Use mouse
set mouse=a


" No backup file
set noswapfile
set nobackup


" Overwrite vim-unimpaired [t and ]t to switch bwteen tabs
nnoremap [t :tabp<CR>
nnoremap ]t :tabn<CR>


" Write to file within 100 ms
set updatetime=100


" Close quickfix window with <leader>q
nnoremap <leader>q :ccl<cr>


" Highlight trailling whitespace
hi ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/


" Switch between windows with CTRL+hjkl
map <C-J> <C-W>j
map <C-L> <C-W>l
map <C-H> <C-W>h
map <C-K> <C-W>k


" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>l :PromoteToLet<cr>


" Poor man's fuzzy finder
function! FzyCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system("tty 2>&1 >/dev/null | ". a:choice_command . " | fzy" . a:selecta_args)
    " Escape spaces in the file name. That ensures that it's a single argument
    " when concatenated with vim_command and run with exec.
    let selection = substitute(selection, ' ', '\\ ', "g")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! FzyFile(path, glob, command)
  call FzyCommand("rg --files", "", a:command)
endfunction

"nnoremap <leader>p :call FzyFile(".", "*", ":edit")<cr>
nnoremap <leader>p :CommandT<cr>

" Use system's clipboard
set clipboard=unnamed

" Backspace should work fine
set backspace=indent,eol,start

nnoremap <leader>t :!./bin/rspec %<CR>
nnoremap <leader>b :CommandTBuffer<CR>


let g:ale_linters = {'ruby': ['standardrb']}
let g:ale_fixers = {'ruby': ['standardrb']}
