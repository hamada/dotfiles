function! FriendlyGrep()
	let query = input('Grep Keyword: ')
	if query == ''
	  return
	endif
	let target = input('Target Directory: ','','file') " .vimrcでデフォルト値を設定できるようにしたい
	if target == ''
	  return
	endif

    if isdirectory(target)
	  	let target = target.'*'

		let input = input("Grep Recursively? [y/n] ") " .vimrcでデフォルト値を設定できるようにしたい
		if input == ''
		  return
		endif

		if input == "yes" || input == "y"
	  		let target = target.'**'
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
