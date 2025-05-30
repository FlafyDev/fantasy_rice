export PORT="${PORT:-$((RANDOM % 801 + 8100))}" # Random port between 8100 and 8900 if PORT isn't set
# export EXTENSIONS_GALLERY='{
#   "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
#   "itemUrl": "https://marketplace.visualstudio.com/items",
#   "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
#   "controlUrl": "",
#   "recommendationsUrl": ""
# }'

printf "Run locally:\nf ocode $PORT $PWD\n\n"
export EDITOR="/nix/store/xgkwngpn2cfd2cx2b9xm01c0dhmkbwb2-code-server-4.91.1/libexec/code-server/lib/vscode/bin/remote-cli/code-linux.sh --wait"

/nix/store/xgkwngpn2cfd2cx2b9xm01c0dhmkbwb2-code-server-4.91.1/bin/code-server --bind-addr 0.0.0.0:$PORT --auth none ${PWD}


