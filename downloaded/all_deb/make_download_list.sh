apt-rdepends keepalived | grep -v "^ " > download_list.txt
cat download_list.txt | xargs -r -n 1 apt download 2>/dev/null
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
# isntall
# 下記は失敗
#   sudo apt -o Dir::Etc::SourceList=/dev/null -o Dir::Etc::SourceParts=/dev/null -o APT::Get::List-Cleanup=0 install --no-install-recommends ./keepalived_*.deb
# Packages.gzが存在するディレクトリで実行する
echo "deb [trusted=yes] file://$(pwd) ./" > /etc/apt/sources.list.d/local_offline.list
apt update
apt install -y keepalived
rm -f /etc/apt/sources.list.d/local_offline.list
