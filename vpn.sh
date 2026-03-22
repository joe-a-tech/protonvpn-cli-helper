#!/usr/bin/env bash

set -euo pipefail
# -e  → exit immediately if any command fails
# -u  → error if you use an undefined variable
# -o pipefail → if any command in a pipeline fails, the whole pipeline fails

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1" >&2
    exit 1
  }
}

status() {
  require curl
  require jq

  echo "=== IPv4 ==="

  IPV4_DATA="$(curl -4 -fsSL https://ipinfo.io/json)"

  echo "$IPV4_DATA" | jq '{ip, country, org}'

  echo

  echo "=== IPv6 ==="

  if IPV6_DATA="$(curl -6 -fsSL https://ipinfo.io/json 2>/dev/null)"; then
    echo "$IPV6_DATA" | jq '{ip, country, org}'
  else
    echo "No IPv6 connectivity"
  fi

  echo

  echo "=== Derived Status ==="

  ORG="$(echo "$IPV4_DATA" | jq -r '.org // ""')"

  if grep -qi 'proton' <<< "$ORG"; then
    echo "VPN: CONNECTED (Proton detected)"
  else
    echo "VPN: NOT CONNECTED"
  fi
}

connect() {
  require protonvpn

  # Use first argument as country, default to Netherlands
  local country="${1:-Netherlands}"

  echo "Connecting to ProtonVPN (${country})..."

  protonvpn connect --country "$country"

  sleep 2

  status
}

disconnect() {
  require protonvpn 

  echo "Disconnecting ProtonVPN..."

  protonvpn disconnect

  echo "Disconnected."
}

case "${1:-}" in
  connect)
    shift
    # shift removes the first argument, so $1 becomes the country
    connect "${1:-Netherlands}"
    ;;

  disconnect)
    disconnect
    ;;

  status)
    status
    ;;

  *)
    echo "Usage: $0 {connect|disconnect|status} [country]" >&2
    exit 1
    ;;
esac
