function! FriendlyGrep()
	let query = input('Grep Keyword: ')
	if query == ''
	  return
	endif
	let target = input('Target Directory: ','','file')
	if target == ''
	  return
	endif

    if isdirectory(target)
	  	let target = target.'*'

		let input = input("Grep Recursively? [y/n] ")
		if input == "yes" || input == "y" || input == ''
	  		let target = target.'**'
		endif
    endif

    execute 'tabnew'
	try
	  execute 'vimgrep'.' '.query.' '.target
	catch
	  tabclose
	  redraw
	  echo "'" . query . "'にヒットしませんでした"
	endtry

:endfunction
