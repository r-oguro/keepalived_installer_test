# パッケージリストの作成
# 下記では依存関係のパッケージの抽出漏れがあった
#   apt-rdepends keepalived | grep -v "^ " > download_list.txt
apt-rdepends keepalived | awk '
  /^[a-zA-Z0-9]/ { print $1 }                                   # 親パッケージ名を登録
  /^[[:space:]]+(Depends|PreDepends|Recommends):/ {             # 必須・事前必須・推奨の行を見つけたら
    gsub(/[()<>:=.0-9]/, "", $2)                                # バージョンなどの余計な記号を消去
    print $2                                                    # 依存先・推奨先のパッケージ名を出力
  }
' | sort -u > download_list.txt
# パッケージファイルのダウンロード
cat download_list.txt | xargs -r -n 1 apt download 2>/dev/null
# リポジトリ情報の作成
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
# パッケージのインストール
# 下記は失敗
#   sudo apt -o Dir::Etc::SourceList=/dev/null -o Dir::Etc::SourceParts=/dev/null -o APT::Get::List-Cleanup=0 install --no-install-recommends ./keepalived_*.deb
# Packages.gzが存在するディレクトリで実行する
echo "deb [trusted=yes] file://$(pwd) ./" > /etc/apt/sources.list.d/local_offline.list
apt update
apt install -y keepalived
rm -f /etc/apt/sources.list.d/local_offline.list
