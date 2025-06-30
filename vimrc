source $VIMRUNTIME/defaults.vim

syntax on
colorscheme habamax
set termguicolors

autocmd BufRead,BufNewFile *.ts,*.tsx set syntax=javascript

function! s:ensure_plugin(repo, name)
  let l:dir = expand('~/.vim/pack/plugins/start/' . a:name)

  if !isdirectory(l:dir)
    call mkdir(fnamemodify(l:dir, ':h'), 'p')
    call system('git clone https://github.com/' . a:repo . '.git ' . shellescape(l:dir))
  endif
endfunction

call s:ensure_plugin('tpope/vim-fugitive', 'vim-fugitive')
call s:ensure_plugin('justinmk/vim-sneak', 'vim-sneak')
