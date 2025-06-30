source $VIMRUNTIME/defaults.vim

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

if executable('fd')
  function! FdFind(arg, _)
    return systemlist('fd --type f --hidden --exclude .git --full-path ' . shellescape(a:arg))
  endfunction
  set findfunc=FdFind
endif

function! s:ensure_plugin(repo, name)
  let l:dir = expand('~/.vim/pack/plugins/start/' . a:name)

  if !isdirectory(l:dir)
    call mkdir(fnamemodify(l:dir, ':h'), 'p')
    call system('git clone https://github.com/' . a:repo . '.git ' . shellescape(l:dir))
  endif
endfunction

call s:ensure_plugin('tpope/vim-fugitive', 'vim-fugitive')
call s:ensure_plugin('justinmk/vim-sneak', 'vim-sneak')

