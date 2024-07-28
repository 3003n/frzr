#! /bin/bash

source ../__frzr-deploy

set -e

REPO="3003n/chimeraos"
RELEASES_URL="https://api.github.com/repos/${REPO}/releases"
RELEASES=$(curl --http1.1 -L -s --connect-timeout 5 -m 15 "${RELEASES_URL}")

CHANNEL="${1:-stable}"

# set -x
IMG_LIST_URL=$(echo $RELEASES | get_img_url "${CHANNEL}")
echo "IMG_LIST_URL: $IMG_LIST_URL"

BASE_URL=$(dirname "$(echo \"${IMG_LIST_URL}\" | cut -d' ' -f1)")
echo "BASE_URL: $BASE_URL"

IMG_LIST_STR="$(curl --http1.1 -L -s --connect-timeout 5 -m 15 ${BASE_URL}/sha256sum.txt)"
echo -e "IMG_LIST_STR:\n$IMG_LIST_STR"

CHECKSUM_LIST=$(echo "$IMG_LIST_STR" | awk '{print $1}')
echo -e "CHECKSUM_LIST:\n$CHECKSUM_LIST"

# sed 去掉 末尾的 -xxx
FILE_NAME=$(basename ${IMG_LIST_URL} | sed 's/-[0-9]*$//')
echo "FILE_NAME: $FILE_NAME"

MOUNT_PATH="/frzr_root"

NAME=$(echo "${FILE_NAME}" | cut -f 1 -d '.')
SUBVOL="${DEPLOY_PATH}/${NAME}"
IMG_FILE="${MOUNT_PATH}/${FILE_NAME}"
echo "
SUBVOL: $SUBVOL
NAME: $NAME
IMG_FILE: $IMG_FILE
"

SER=0
TOTAL=$(echo "$CHECKSUM_LIST" | wc -l)
echo "TOTAL: $TOTAL"
for CHECKSUM in $CHECKSUM_LIST; do
    FILENAME=$(echo "$IMG_LIST_STR" | grep $CHECKSUM | awk '{print $2}')
    echo "Downloading $FILENAME , SER=$SER"

    SER=$((SER+1))
done
