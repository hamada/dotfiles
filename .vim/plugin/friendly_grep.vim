function! FriendlyGrep()
	let query = input('Grep Keyword: ', '')
	if query == ''
	  return
	endif

	if !exists('g:friendlygrep_target_dir')
	  let g:friendlygrep_target_dir = ''
	endif
	let target = input('Target Directory: ', g:friendlygrep_target_dir, 'file')
	if target == ''
	  return
	endif

    if isdirectory(target)
	  	let target = target.'*'

		if exists('g:friendlygrep_recursively') " elseifを使えるように
			if g:friendlygrep_recursively == 1
				let target = target.'**'
			endif
		endif
		if !exists('g:friendlygrep_recursively')
			let input = input("Grep Recursively? [y/n] ")
			if input == ''
			  return
			endif

			if input == "yes" || input == "y"
				let target = target.'**'
			endif
		endif
    endif

	" .vimrcで設定することによってタブでなく現在のバッファー上あるいはsplitで開けるようにしたい
    execute 'tabnew'
	try
	  execute 'vimgrep'.' '.query.' '.target
	catch
	  tabclose
	  redraw
	  echo "'" . query . "'にヒットしませんでした"
	endtry

:endfunction
