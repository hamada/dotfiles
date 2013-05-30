function! DeployOctPost()
  exe "set noswapfile"
  exe "!cd " s:escarg(g:octopress_path) . " &&bundle exec rake gen_deploy "
:endfunction

function! s:escarg(s)
  return escape(a:s, ' ')
endfunction
