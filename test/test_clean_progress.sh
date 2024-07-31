#! /bin/bash

source ../__frzr-deploy

set -e

# 测试函数
echo "Testing clean_progress function..."

CHECKSUM_LIST="123
456
2
789"

SER=0
TOTAL=$(echo "$CHECKSUM_LIST" | wc -l)

max_progress=200
for CHECKSUM in $CHECKSUM_LIST; do
    echo "Downloading SER=$SER"
    input="0\n10\n25\n50\n75\n100"
    echo -e $input | clean_progress_loop $max_progress $SER $TOTAL "%"

    SER=$((SER+1))
done