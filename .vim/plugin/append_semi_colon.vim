function! AppendSemiColon()
	"カーソル現在位置取得
	let l = line(".")
	let c = col(".")
	";を変数textに代入
	let text = ";"
	" 行末に変数textを代入
	execute ":normal A".text
	"元の位置へカーソル移動
	call cursor(l, c)
	"インサートモードへ移行したい
:endfunction
