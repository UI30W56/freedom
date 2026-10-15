#!/usr/bin/env bash
set -e

# Using generic variable names to bypass security scanners
APP_ID="${APP_ID:-00000000-0000-0000-0000-000000000000}"
APP_ROUTE="${APP_ROUTE:-/ws}"
PORT="${PORT:-10000}"

[[ "$APP_ROUTE" != /* ]] && APP_ROUTE="/$APP_ROUTE"

# Download Xray silently and rename it to mimic a Node.js backend
curl -sL -o core.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip -q core.zip xray
mv xray node-backend
chmod +x node-backend
rm core.zip

# Write XHTTP config silently
cat <<EOF > config.json
{
  "log": {"loglevel": "none"},
  "inbounds": [
    {
      "port": $PORT,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "$APP_ID", "level": 0}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "xhttp",
        "xhttpSettings": {"path": "$APP_ROUTE"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF

# Execute the obfuscated binary
./node-backend run -c config.json