# コンピュータ名を設定
sudo /usr/sbin/networksetup -setcomputername 'MacbookPro'
# ネット上に.DS_storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
# Dockを自動的に隠す
defaults write com.apple.dock autohide -bool true
# 拡張子を常に表示する
defaults write -g AppleShowAllExtensions -bool true
# ゴミ箱を空にする時の警告OFF
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# ライブラリフォルダ表示
chflags nohidden ~/Library/
# インターネットからダウンロードしたアプリケーションに実行ダイアログを表示しない
defaults write com.apple.LaunchServices LSQuarantine -boolean false
# Finderウィンドウのタイトル部分にパスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
# Finderウィンドウ下のPath barを表示
defaults write com.apple.finder ShowPathbar -bool true
# スクロールバーを常に表示
defaults write -g AppleShowScrollBars Always
# タップでクリック
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# スクロールの方向 ナチュラルにしない
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# メニューバーSpotlightアイコンを非表示
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

killall Finder
