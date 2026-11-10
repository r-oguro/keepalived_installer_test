apt-rdepends keepalived | grep -v "^ " > download_list.txt
cat download_list.txt | xargs -r -n 1 apt download 2>/dev/null
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
# isntall
sudo apt -o Dir::Etc::SourceList=/dev/null -o Dir::Etc::SourceParts=/dev/null -o APT::Get::List-Cleanup=0 install --no-install-recommends ./keepalived_*.deb

