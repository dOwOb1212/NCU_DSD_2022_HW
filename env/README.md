# Vim
## syntax plugin  
### syntastic 
```
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```
```
execute pathogen#infect()
```
```
cd ~/.vim/bundle && \
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
```
### verilator 
```
sudo apt-get install verilator
```
### Icarus Verilog
```
sudo apt-get install verilog
```
## Vim ~/.vimrc Setting
```
syntax on                                                                       
execute pathogen#infect()                                                       
                                                                                
                                                                                
set noerrorbells                                                                
set tabstop=4 softtabstop=4                                                     
set shiftwidth=4                                                                
set expandtab                                                                   
set smartindent                                                                 
set nu                                                                         
set nowrap                                                                      
set smartcase                                                                   
set noswapfile                                                                  
set nobackup                                                                    
set undodir=~/.vim/undodir                                                      
set undofile                                                                    
set incsearch                                                                   
                                                                                
set colorcolumn=80                                                              
highlight ColorColumn ctermbg=0 guibg=lightgrey                                 
call plug#begin('~/.vim/plugged')                                               
Plug 'morhetz/gruvbox'                                                          
Plug 'jremmen/vim-ripgrep'                                                      
Plug 'tpope/vim-fugitive'                                                       
Plug 'leafgarland/typescript-vim'                                               
Plug 'vim-utils/vim-man'                                                        
Plug 'lyuts/vim-rtags'                                                          
Plug 'mbbill/undotree'                                                          
Plug 'https://github.com/kien/ctrlp.vim.git'                                    
Plug 'https://github.com/ycm-core/YouCompleteMe.git'                            
call plug#end()                                                                 
                                                                                
colorscheme gruvbox                                                             
set background=dark                                                             
                                                                                
if executable('rg')                                                             
    let g:rg_derive_root='true'                                                 
endif                                                                           
                                                                                
let g:ctrlp_usercommand = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let mapleader = " "                                                             
let g:netrw_browse_split=2                                                      
let g:netrw_banner = 0                                                          
let g:ctrlp_use_caching = 0                                                     
let g:netrw_winsize = 25                                                        
                                                                                
nnoremap <leader>h :wincmd h<CR>                                                
nnoremap <leader>j :wincmd j<CR>                                                
nnoremap <leader>k :wincmd k<CR>                                                
nnoremap <leader>l :wincmd l<CR>                                                
nnoremap <leader>u :UndotreeShow<CR>                                            
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>            
nnoremap <Leader>ps :Rg<SPACE>                                                  
nnoremap <silent> <Leader>+ :vertical resize +5<CR>                             
nnoremap <silent> <Leader>- :vertical resize -5<CR>                             
                                                                                
"YCM                                                                            
                                                                                
nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>                             
nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR                             

"syntastic

set statusline+=%#warningmsg#                                                   
set statusline+=%{SyntasticStatuslineFlag()}                                    
set statusline+=%*                                                              
                                                                                
let g:syntastic_always_populate_loc_list = 1                                    
let g:syntastic_auto_loc_list = 1                                               
let g:syntastic_check_on_open = 1                                               
let g:syntastic_check_on_wq = 0                                                 
let g:syntastic_verilog_checkers = ['verilator', 'iverilog']      
let g:syntastic_python_checkers = ['pylint']                                    
let g:syntastic_cpp_checkers = 'gcc'                                            
let g:syntastic_cpp_compiler = 'gcc' 
                                                                                

```
![out-transparent-1 (1)](https://user-images.githubusercontent.com/100607574/161127810-2ccdb37f-5945-4746-a1a5-795415a5926a.gif)

