# パッケージリストの作成
# メインの keepalived 自体もリストの末尾に追加
echo "***注意*** 必要に応じてsudo apt updateを実行してから作業してください"
LANG=C apt-cache depends --recurse --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances keepalived | \
grep -E '^[[:space:]]*(Depends|PreDepends|Recommends):' | \
awk '{print $2}' | sed 's/<//;s/>//' | sort -u > download_list.txt
echo "keepalived" >> download_list.txt
# パッケージファイルのダウンロード
cat download_list.txt | xargs -r -n 1 apt download 2>/dev/null
# 新しい Packages.gz 目次ファイルを作成
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

# パッケージのインストール
# 下記は失敗
#   sudo apt -o Dir::Etc::SourceList=/dev/null -o Dir::Etc::SourceParts=/dev/null -o APT::Get::List-Cleanup=0 install --no-install-recommends ./keepalived_*.deb
# Packages.gzが存在するディレクトリで実行する
echo "deb [trusted=yes] file://$(pwd) ./" > /etc/apt/sources.list.d/local_offline.list
apt update
apt install -y keepalived
rm -f /etc/apt/sources.list.d/local_offline.list
