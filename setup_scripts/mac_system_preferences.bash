# ネット上に.DS_storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
# Dockを自動的に隠す
defaults write com.apple.dock autohide -bool true
# 拡張子を常に表示する
defaults write -g AppleShowAllExtensions -bool true
# ライブラリフォルダ表示
chflags nohidden ~/Library/
# インターネットからダウンロードしたアプリケーションに実行ダイアログを表示しない
defaults write com.apple.LaunchServices LSQuarantine -boolean false
# Finderウィンドウのタイトル部分にパスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
# タップでクリック
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# メニューバーSpotlightアイコンを非表示
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

killall Finder
