source ./Scripts/global.sh
source ./Scripts/utils.sh

git reset --hard origin/main
git clean -fd
git pull

extract_embedded_bitcoin_node