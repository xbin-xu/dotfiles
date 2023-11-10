set nocompatible    " disable Vi compatible
set shortmess+=I    " disable the default Vim startup message.

"-----------------------
" General configurations
"-----------------------

" Encoding
"---------------------------------------------------------
set encoding=utf-8

" Font
"---------------------------------------------------------
set guifont=JetBrainsMono\ Nerd\ Font\ 11

" Colorscheme
"---------------------------------------------------------
colorscheme onedark

" Syntax
"---------------------------------------------------------
syntax on           " turn on syntax highlighting

" Indent
"---------------------------------------------------------
filetype plugin on  " load filetype's plugin file
filetype indent on  " load filetype's indent file
" set autoindent      " set automatically indented
set smartindent     " set smart indent

" UI
"---------------------------------------------------------
set mouse+=a        " enable mouse support
set timeoutlen=300  " timeout of keystrokes
set updatetime=100  " set updatetime, default is 4000

set number          " show line numbers
set relativenumber  " show relative numbering
set laststatus=2    " show the status line at the bottom
set showcmd         " show command in bottom bar
set wildmenu        " enhance command-line completion
set wildmode=longest:full,full  " command-line completion mode
set showmatch       " show matching braces when text indicator is over them
set colorcolumn=80  " set the anchor line at 80 characters
set scrolloff=5     " set cursor with at least 5 lines at the top or bottom
set hidden          " allow having hidden buffers(not displayed in any window)
set splitbelow      " split window to below
set splitright      " split window to right
set signcolumn=yes  " always show thw signcolumn, otherwise it would shift the text each time
set completeopt=menu,menuone,noselect   " completion for insert mode

" Disable annoying audible bell(error noises)
set noerrorbells visualbell t_vb=
" Make backspace behave in a more intuitive way
set backspace=indent,eol,start

" Highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" Spaces & Tabs
"---------------------------------------------------------
set expandtab       " tabs are spaces, mainly because of python
set tabstop=4       " number of visual spaces per TAB
set shiftwidth=4    " insert 4 spaces on a tab
set softtabstop=4   " number of spaces in tab when editing

set list            " set list to see tabs and non-breakable spaces
set listchars=tab:>-,nbsp:.
" set listchars=tab:>-,trail:·,eol:¬,nbsp:_

" Search
"---------------------------------------------------------
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set ignorecase      " ignore case in searches by default
set smartcase       " but make it case sensitive if an uppercase is entered
" Ignore files for completion
set wildignore+=*/.git/*,*/tmp/*

" History
"---------------------------------------------------------
set history=2000    " set the number of history

" Folding
"---------------------------------------------------------
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

" Clipboard
"---------------------------------------------------------
" Use the sys clipboard by default (on versions compiled with `+clipboard`)
" [Vim 使用系统剪切板](https://harttle.land/2020/09/04/vim-clipboard.html)
" todo: not work
set clipboard=unnamed

" Undo
"---------------------------------------------------------
" Check Vim support undo
if has("persistent_undo")
    " maintain undo history between sessions
    set undofile

    " set the path to store undo files
    let target_path = expand('$HOME/.vim/undo')
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif
    let &undodir = target_path
endif

"-------------
" Key bindings
"-------------

" Leader key
"---------------------------------------------------------
nnoremap <space> <Nop>
let mapleader="\<space>"

" Reload .vimrc
"---------------------------------------------------------
noremap <leader>r :source $MYVIMRC<CR>

" Escap
"---------------------------------------------------------
" Map jk to <Esc> in insert mode
" inoremap jk <Esc>

" Quit & Save
"---------------------------------------------------------
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w<CR><Esc>
noremap <leader>W :w !sudo tee % >/dev/null<CR>
inoremap <C-s> :w<CR><Esc>
xnoremap <C-s> :w<CR><Esc>
nnoremap <C-s> :w<CR><Esc>
snoremap <C-s> :w<CR><Esc>

" Terminal
"---------------------------------------------------------
" Toggle terminal, default is horizontal, use `:vert term` tp open in vertical
noremap <C-t> :term ++close<CR>
tnoremap <C-t> <C-w>:close<CR>

" Navigate window
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

" Tab
"---------------------------------------------------------
nnoremap <leader><tab>n :tabnew<CR>
nnoremap <leader><tab>d :tabclose<CR>

" Navigate tab
nnoremap [<tab> :tabprevious<CR>
nnoremap ]<tab> :tabnext<CR>

" Window
"---------------------------------------------------------
" Split window
nnoremap <leader>- :sp<CR>
nnoremap <leader>\| :vsp<CR>

" Navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize window, todo: not work
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertial resize -2<CR>
nnoremap <C-Right> :vertial resize +2<CR>

" Buffer
"---------------------------------------------------------
noremap <leader>bn :enew<CR>
noremap <leader>bd :bdelete<CR>

" Navigate buffer
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
" nnoremap <S-h> :bprevious<CR>
" nnoremap <S-l> :bnext<CR>

" Clipboard
"---------------------------------------------------------
" Quick copy paste into system clipboard
nnoremap <leader>y "+y
nnoremap <leader>d "+d
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>y "+y
vnoremap <leader>d "+d
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Movement
"---------------------------------------------------------
" Line head & tail
noremap H ^
noremap L $

" Move vertically by visual line
nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'

" Move line: `<A-j>`, `<M-j>` and `^]j` are not work
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv

" Search
"---------------------------------------------------------
" Turn off highlight search
" noremap <leader>nh :noh<CR>

" Focus center
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap <C-i> <C-i>zz
nnoremap <C-o> <C-o>zz

" Replace vim's built-in visual * and # behavior
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" Quickfix
"---------------------------------------------------------
" Location list
nnoremap <leader>xl :lopen<CR>

" Quickfix list
nnoremap <leader>xq :copen<CR>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

" Other
"---------------------------------------------------------
" Scroll cmd-line history
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" Highlight last inserted text
nnoremap gV `[v`]

" Enable continuous indent
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Increment / Decrement
nnoremap <C-a> ggVG
nnoremap + <C-a>
nnoremap - <C-x>

" Add undo break-points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

" Unbind some useless/annoying default key bindings
"---------------------------------------------------------
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" Prevent bad habits(using the arrow keys for movement)
"---------------------------------------------------------
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Right> :echoe "Use l"<CR>

inoremap <Left>  <Esc>:echoe "Use h"<CR>
inoremap <Down>  <Esc>:echoe "Use j"<CR>
inoremap <Up>    <Esc>:echoe "Use k"<CR>
inoremap <Right> <Esc>:echoe "Use l"<CR>

vnoremap <Left>  <Esc>:echoe "Use h"<CR>
vnoremap <Down>  <Esc>:echoe "Use j"<CR>
vnoremap <Up>    <Esc>:echoe "Use k"<CR>
vnoremap <Right> <Esc>:echoe "Use l"<CR>

"---------------
" Plugin install
"---------------

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    :exe '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Colorschemes
"---------------------------------------------------------
Plug 'joshdick/onedark.vim'

" GUI enhancements
"---------------------------------------------------------
Plug 'mhinz/vim-startify'           " start screen
Plug 'scrooloose/nerdtree'          " file explorer
Plug 'Xuyuanp/nerdtree-git-plugin'  " git status for nerdree
Plug 'ryanoasis/vim-devicons'       " icon for vim plugins
Plug 'sjl/gundo.vim'                " visualize undo tree
Plug 'kshenoy/vim-signature'        " show marks in the gutter
Plug 'vim-airline/vim-airline'      " beautify statusline
Plug 'vim-airline/vim-airline-themes'

" Fuzzy finder
"---------------------------------------------------------
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Tmux GUI
"---------------------------------------------------------
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'christoomey/vim-tmux-navigator'

" Git GUI
"---------------------------------------------------------
Plug 'tpope/vim-fugitive'           " git interface
Plug 'airblade/vim-gitgutter'       " git gutter

" Movement
"---------------------------------------------------------
" Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'

" Text manipulation
"---------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'roxma/vim-paste-easy'         " automatically `set paste`
Plug 'tpope/vim-commentary'         " quick (un)comment line(s)
Plug 'junegunn/vim-easy-align'      " easy align

" LSP
"---------------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight'

" DAP
"---------------------------------------------------------
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-rust --enable-python'}

" Other
"---------------------------------------------------------
Plug 'liuchengxu/vim-which-key'     " which key
" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'romainl/vim-cool'             " auto enable/disable search highlight

call plug#end()

"---------------------
" Plugin configuration
"---------------------

" nerdtree
"---------------------------------------------------------
nnoremap <C-e> :NERDTreeToggleVCS<CR>
nnoremap <leader>e :NERDTreeFind<CR>

" Show hidden files, but ignore .git, .idea, .history
let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.git$', '\.idea$', '\.history$']

" Enable liine numbers
let NERDTreeShowLineNumbers = 1
" Make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endi

" nerdtree-git-plugin
"---------------------------------------------------------
" Enable nerdfonts
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" gundo
"---------------------------------------------------------
nnoremap <leader>u :GundoToggle<CR>
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

" signature
"---------------------------------------------------------
" Enable confirm while delete all tags
let g:SignaturePurgeConfirmation = 1

" airline
"---------------------------------------------------------
" Set theme for airline
let g:airline_theme = 'onedark'
" Enable airline
let g:airline#extensions#tabline#enabled = 1
" How file paths are displayed
let g:airline#extensions#tabline#formatter = 'unique_tail'

" fzf
"---------------------------------------------------------
let g:fzf_layout = {'down': '~40%'}

nnoremap <leader>fg :Rg<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :History<CR>

" gitgutter
" notes: can not unstage staged changes
"---------------------------------------------------------
nmap [g :call GitGutterPrevHunkCycle()<CR>
nmap ]g :call GitGutterNextHunkCycle()<CR>
nmap <leader>gj :call GitGutterNextHunkCycle()<CR>
nmap <leader>gk :call GitGutterPrevHunkCycle()<CR>
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" Cycle through hunks in current buffer
function! GitGutterNextHunkCycle()
    let line = line('.')
    silent! GitGutterNextHunk
    if line('.') == line
        1
        GitGutterNextHunk
    endif
endfunction

function! GitGutterPrevHunkCycle()
    let line = line('.')
    silent! GitGutterPrevHunk
    if line('.') == line
        normal! G
        GitGutterPrevHunk
    endif
endfunction

" sneak
"---------------------------------------------------------
" Enable label-mode to motion(just like easymotion)
" let g:sneak#label = 1

" easymotion
"---------------------------------------------------------
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" <leader>f{char} to move to {char}
map <leader>f <Plug>(easymotion-bd-f)
nmap <leader>f <Plug>(easymotion-overwin-f)

" vim-sneak behaviour through easymotio
map <leader>s <Plug>(easymotion-f2)
nmap <leader>s <Plug>(easymotion-overwin-f2)

" JK motions: Line motions
map <leader>h <Plug>(easymotion-linebackward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>l <Plug>(easymotion-lineforward)

" surround
"---------------------------------------------------------
" None

" paste-easy
"---------------------------------------------------------
let g:paste_easy_enable = 1

" commentary
"---------------------------------------------------------
" C and C++ use "//" to comment, rather than "/**/"
autocmd FileType c,cpp set commentstring=//\ %s

" easyalign
"---------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" coc
"---------------------------------------------------------
" coc extensions
let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-vimlsp',
            \ 'coc-highlight',
            \ 'coc-markdownlint',
            \ 'coc-sh',
            \ 'coc-snippets',
            \ 'coc-clangd',
            \ 'coc-cmake',
            \ 'coc-pyright',
            \ ]

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <C-j>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>ca  <Plug>(coc-codeaction-selected)
" nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ca  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>cas  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>cqf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" which key
"---------------------------------------------------------
" Use leader key to trigger which key
nnoremap <silent> <leader> :<C-u>WhichKey '<space>'<CR>
vnoremap <silent> <leader> :<C-u>WhichKeyVisual '<space>'<CR>

" Register the description dictionary for the prefix to pop up the guide menu
" call which_key#register('<space>', "g:which_key_map")

" Define prefix dictionary
let g:which_key_map =  {}

" =======================================================
" Create menus not based on existing mappings:
" =======================================================
" let g:which_key_map.TAB = { 'name' : '+tab' }
" let g:which_key_map.b = { 'name' : '+buffer' }
" let g:which_key_map.c = { 'name' : '+code' }
" let g:which_key_map.g = { 'name' : '+git' }
" let g:which_key_map.x = { 'name' : '+diagnostics/quickfix' }
" let g:which_key_map.x = {
"       \ 'name' : '+diagnostics/quickfix'
"       \ 'q' : 'open-quickfix'    ,
"       \ 'l' : 'open-locationlist',
"       \ }

"---------------------
" Local customizations
"---------------------

let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
