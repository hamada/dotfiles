function! GrepFor()
	let query = input('検索ワード: ')
	if query == ''
	  return
	endif
	let dir = input('対象ディレクトリ: ','','dir')
	if dir == ''
	  return
	endif

    execute 'tabnew'
	try
	  execute 'vimgrep'.' '.query.' '.dir.'**'
	catch
	  tabclose
	endtry

:endfunction
