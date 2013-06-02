function! FriendlyGrep()
	let query = input('grep query: ', '')
	if query == ''
	  return
	endif

	if !exists('g:friendlygrep_target_dir')
	  let g:friendlygrep_target_dir = ''
	endif
	let target = input('target file/dir: ', g:friendlygrep_target_dir, 'file')
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
			let input = input("grep recursively? [y/n] ")
			if input == ''
			  return
			endif

			if input == "yes" || input == "y"
				let target = target.'**'
			endif
		endif
    endif

	" .vimrcで設定することによってタブでなく現在のバッファー上あるいはsplitで開けるようにしたい
	" 以下の形式を選択出来るように
	" :vs|:vimgrep query target/** 結果を左splitで
	" :sp|:vimgrep query target/** 結果を上spilitで
	" :vimgrep query target/** |cw Quickfixウィンドウで
	" :vimgrep query target/** 現在のバッファで開く
    execute 'tabnew'
	try
	  execute 'vimgrep'.' '.query.' '.target
	catch
	  tabclose
	  redraw
	  echohl WarningMsg
	  echo query . " did not match any files"
	  echohl None
	endtry

:endfunction
