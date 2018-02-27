set colorcolumn=80      " その代わり80文字目にラインを入れる

"インデントを半角スペースにする
set expandtab
set tabstop=2
set shiftwidth=2

"マクロおよびキー設定
" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>

" vを二回で行末まで選択
vnoremap v $h

"シンタックスカラー
syntax on
