LANG=C apt-get -s install --no-install-recommends keepalived | grep -E '^Inst ' | awk '{print $2}' > download_list.txt
cat download_list.txt | xargs -r -n 1 apt download 2>/dev/null
