function! GrepFor()
    execute 'tabnew'
	let query = input('検索ワード: ')
	let dir = input('対象ディレクトリ: ','','dir')
    execute 'vimgrep'.' '.query.' '.dir.'**'
:endfunction
