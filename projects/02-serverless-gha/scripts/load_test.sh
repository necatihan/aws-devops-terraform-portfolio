#!/usr/bin/env bash
set -euo pipefail

URL="${1:?Usage: ./load_test.sh <API_BASE_URL>}"
PK="${2:-demo#load}"

echo "POST 20 items..."
for i in $(seq 1 20); do
  curl -s -X POST "$URL/items" \
    -H "content-type: application/json" \
    -d "{\"pk\":\"$PK\",\"data\":{\"n\":$i,\"source\":\"load_test\"}}" > /dev/null
done

echo "GET items..."
curl -s "$URL/items/$(python -c "import urllib.parse; print(urllib.parse.quote('$PK', safe=''))")" | head -c 400
echo
echo "Done."