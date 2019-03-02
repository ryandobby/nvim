"===============================================================================
"                                 Plugins
"===============================================================================
" Automatically install our plugin manager - Vim-Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd!
    autocmd VimEnter * PlugInstall
endif

" List of plugins
call plug#begin('~/.config/nvim/plugged')
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'phpactor/phpactor', { 'do': ':call phpactor#Update()', 'for': 'php'}
    Plug 'phpactor/ncm2-phpactor', {'for': 'php'}
    Plug 'ncm2/ncm2-ultisnips'
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'StanAngeloff/php.vim', {'for': 'php'}
    Plug 'w0rp/ale'
    Plug 'stephpy/vim-php-cs-fixer'
    Plug 'adoy/vim-php-refactoring-toolbox', {'for': 'php'}
    Plug 'arnaud-lb/vim-php-namespace', {'for': 'php'}
    Plug 'tobyS/vmustache'
    Plug 'tobyS/pdv'
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'flazz/vim-colorschemes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'matze/vim-move'
    Plug 'svermeulen/vim-cutlass'
    Plug 'airblade/vim-gitgutter'
    Plug 'itchyny/lightline.vim'

call plug#end()

"===============================================================================
"                            Plugin Configuration
"===============================================================================

"------------------------------------ncm2---------------------------------------
augroup ncm2
    au!
    autocmd BufEnter * call ncm2#enable_for_buffer()
    au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
    au User Ncm2PopupClose set completeopt=menuone
augroup END

"----------------------------------phpactor-------------------------------------
" context-aware menu with all functions (ALT-m)
nnoremap <m-m> :call phpactor#ContextMenu()<cr>

nnoremap gd :call phpactor#GotoDefinition()<CR>
nnoremap gr :call phpactor#FindReferences()<CR>

" Extract method from selection
vmap <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>
" extract variable
vnoremap <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>
nnoremap <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>
" extract interface
nnoremap <silent><Leader>rei :call phpactor#ClassInflect()<CR>

function! PHPModify(transformer)
    :update
    let l:cmd = "silent !".g:phpactor_executable." class:transform ".expand('%').' --transform='.a:transformer
    execute l:cmd
endfunction

"---------------------------php-refectoring-toolbox-----------------------------
let g:vim_php_refactoring_default_property_visibility = 'private'
let g:vim_php_refactoring_default_method_visibility = 'private'
let g:vim_php_refactoring_auto_validate_visibility = 1
let g:vim_php_refactoring_phpdoc = "pdv#DocumentCurrentLine"

let g:vim_php_refactoring_use_default_mapping = 0
nnoremap <leader>rlv :call PhpRenameLocalVariable()<CR>
nnoremap <leader>rcv :call PhpRenameClassVariable()<CR>
nnoremap <leader>rrm :call PhpRenameMethod()<CR>
nnoremap <leader>reu :call PhpExtractUse()<CR>
vnoremap <leader>rec :call PhpExtractConst()<CR>
nnoremap <leader>rep :call PhpExtractClassProperty()<CR>
nnoremap <leader>rnp :call PhpCreateProperty()<CR>
nnoremap <leader>rdu :call PhpDetectUnusedUseStatements()<CR>
nnoremap <leader>rsg :call PhpCreateSettersAndGetters()<CR>

"-----------------------ncm2-UltiSnips && ncm2-phpactor-------------------------
" parameter expansion for selected entry via Enter
inoremap <silent> <expr> <CR> (pumvisible() ? ncm2_ultisnips#expand_or("\<CR>", 'n') : "\<CR>")

" cycle through completion entries with tab/shift+tab
inoremap <expr> <TAB> pumvisible() ? "\<c-n>" : "\<TAB>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<TAB>"

let g:phpactor_executable = '~/.config/nvim/plugged/phpactor/bin/phpactor'

"---------------------------------UltiSnips-------------------------------------
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" PHP7
let g:ultisnips_php_scalar_types = 1

"------------------------------------ale----------------------------------------
" disable linting while typing
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 1
let g:ale_keep_list_window_open=0
let g:ale_set_quickfix=0
let g:ale_list_window_size = 5
let g:ale_php_phpcbf_standard='PSR2'
let g:ale_php_phpcs_standard='phpcs.xml.dist'
let g:ale_php_phpmd_ruleset='phpmd.xml'
let g:ale_php_phpstan_executable = '~/.config/composer/vendor/nunomaduro/larastan/extension.neon'
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'php': ['phpcbf', 'php_cs_fixer', 'remove_trailing_lines', 'trim_whitespace'],
  \}
let g:ale_fix_on_save = 1

"-------------------------------php-namespace-----------------------------------
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>

let g:php_namespace_sort_after_insert = 1

"----------------------------------NERDTree-------------------------------------
" autocmd vimenter * NERDTree
let NERDTreeHijackNetrw = 0

"------------------------------vim-php-cs-fixer---------------------------------
nnoremap <silent><leader>pf :call PhpCsFixerFixFile()<CR>
autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()
let g:php_cs_fixer_level = "psr2"

"---------------------------------lightline-------------------------------------
set laststatus=2
set noshowmode
"----------------------------------Vim-move-------------------------------------
" for terms that send Alt as Escape sequence
" see http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
" for why the <F20> hack. Keeps Esc from waiting for other keys to exit visual
set <F20>=j
set <F21>=k
vmap <F20> <Plug>MoveBlockDown
vmap <F21> <Plug>MoveBlockUp
nmap <F20> <Plug>MoveLineDown
nmap <F21> <Plug>MoveLineUp

"------------------------------------pdv----------------------------------------
let g:pdv_template_dir = $HOME ."/.config/nvim/plugged/pdv/templates_snip"
nnoremap <leader>d :call pdv#DocumentWithSnip()<CR>

"===============================================================================
"                               Auto-Commands
"===============================================================================
" update tags in background whenever you write a php file
"au BufWritePost *.php silent! !eval '[ -f ".git/hooks/ctags" ] && .git/hooks/ctags' &

"Automatically source the vimrc flie on save"
augroup autosourcing
         autocmd!
         autocmd BufWritePost ~/.config/nvim/init.vim source %
augroup END

"===============================================================================
"                              General Settings
"===============================================================================

set backspace=indent,eol,start
let mapleader = ','
set number
set mouse+=a
set noerrorbells visualbell t_vb=
set nofoldenable
set whichwrap+=<,>,h,l,[,]
set complete=.,w,b,u

"----------------------------------Visuals--------------------------------------
set termguicolors
set t_CO=256
"set background=dark
colorscheme srcery-drk
"molokai, darkdevel, darkblack
"wombat, srcery, srcery-drk

call matchadd('ColorColumn', '\%81v', 100)     "highlight the 81 character

"-----------------Highlight matches when jumping to next------------------------
" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

function! HLNext (blinktime)
    highlight WhiteOnRed ctermfg=white ctermbg=red
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

"-----------------------------Split management----------------------------------
set splitbelow
set splitright

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

hi LineNr ctermbg=black
hi vertsplit ctermfg=black ctermbg=black

"------------------------------Tabs and Spaces----------------------------------
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
autocmd BufWritePre * :%s/\s\+$//e

"---------------------------------Searching-------------------------------------
set hlsearch
set incsearch

"----------------------------------Aliases--------------------------------------

"Add simple highlight removal"
nmap <Leader><space> :nohlsearch<cr>
"swap colon to semicolon"
nnoremap ; :
"remap redo to U"
nnoremap U <C-R>
map <leader>nt :NERDTreeToggle<CR>
nmap <leader>ev :e ~/.config/nvim/init.vim<cr>

"----------------------------------Python---------------------------------------
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

"===============================================================================
"                                  Notes
"===============================================================================
"   ctrl+] find origin, ie where a variable, method, etc. was originated
"   ctrl+^ return to from the origin to the instance above
"
"   ctrl+d to page-down
"   h = left, j = down, k = up, l = right
"
"   zz to center the line where the cursor is located
"   y to 'yank' a copy of the selected text
"   yy to 'yank' a copy of the current line
"
"   u to undo
"   U to redo
"   i for insert
"
"   di+( delete text inside of parenthesis
"   da+( to delete the parenthesis and the text inside
"
"   vi+[ to select the text inside of the brackets
"   va+[ to select the brackets and the text inside
"
"   ci+" to change the text inside the quotes
"   ca+" replace the quotes and text
"
"   :sp to split the window horizontally
"   :vsp to split the window vertically
"   ctrl+h to switch to the left window
"   :term to open a terminal in a new horizontal window
"   :checkhealth to check plugins and python health
"
"   ----------------------------Custom Macros--------------------------------
"   ,ev to edit the init.vim
"   ,nt to open up nerd tree file browser
