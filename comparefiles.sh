if [ "$#" -ne 2 ]; then
    echo "[!] At least 2 files are required to compare."
else
    sum1=$(md5sum $1)
    echo -n "[*] 1. "
    md5sum $1
    sum2=$(md5sum $2)
    echo -n "[*] 2. "
    md5sum $2
    hash1="${sum1/$1/}"
    hash2="${sum2/$2/}"
    if [ "$hash1" == "$hash2" ]; then
        echo "[+] Files are identical"
    else
        echo "[+] Files are different"
    fi
fi
