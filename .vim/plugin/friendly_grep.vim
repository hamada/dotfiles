function! FriendlyGrep()
	let query = input('検索ワード: ')
	if query == ''
	  return
	endif
	let target = input('対象ディレクトリ: ','','file')
	if target == ''
	  return
	endif

    if isdirectory(target)
	  let target = target.'**'
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
