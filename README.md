# vpn.sh

A simple Bash wrapper around ProtonVPN CLI with clean, script-friendly status output.

This tool lets you:

* Connect to ProtonVPN (by country)
* Disconnect cleanly
* Check VPN status using external IP (IPv4 + IPv6)

It’s designed to be minimal, readable, and useful for automation or daily use.

---

## Features

* **One command interface**: `connect`, `disconnect`, `status`
* **External verification** via https://ipinfo.io (ground truth, not CLI state)
* **IPv4 + IPv6 visibility**
* **JSON output** (easy to pipe into other tools)
* **Dependency checks** (fails fast if something is missing)

---

## Requirements

* Linux (tested on Fedora)
* ProtonVPN CLI installed and configured
* `curl`
* `jq`

Install dependencies on Fedora:

```bash
sudo dnf install curl jq
```

---

## Installation

Clone the repo:

```bash
git clone https://github.com/YOUR_USERNAME/vpn.sh.git
cd vpn.sh
```

Make the script executable:

```bash
chmod +x vpn.sh
```

(Optional) Move to your PATH:

```bash
sudo mv vpn.sh /usr/local/bin/vpn
```

Then you can run it globally:

```bash
vpn status
```

---

## Usage

### Connect (default: Netherlands)

```bash
./vpn.sh connect
```

### Connect to a specific country

```bash
./vpn.sh connect Iceland
```

### Disconnect

```bash
./vpn.sh disconnect
```

### Check status

```bash
./vpn.sh status
```

---

## Example Output

```json
{
  "status": "CONNECTED",
  "ip": "205.147.16.40",
  "country": "NL",
  "org": "AS208172 Proton AG"
}
```

---

## How It Works

* Uses `protonvpn` CLI to establish connections
* Uses `curl` to query https://ipinfo.io
* Uses `jq` to extract relevant fields
* Determines VPN status based on detected network provider

This avoids relying on Proton’s internal state and instead checks actual network egress.

---

## IPv6 Notes

This script checks both IPv4 and IPv6 connectivity.

Depending on your ProtonVPN configuration:

* IPv6 may be routed via Proton’s internal interfaces
* or disabled entirely

You can verify both paths using:

```bash
vpn status
```

---

## Why This Exists

ProtonVPN CLI status can be unreliable or unclear in some setups.

This script answers the only question that matters:

> "What IP am I actually using right now?"

---

## Future Improvements

* Exit codes for automation (e.g. `0 = connected`)
* Optional plain-text output mode
* Timeout/retry handling
* Configurable providers (ipinfo, ipify, etc.)

---

## License

MIT

---

## Author

Built as a lightweight utility for personal use and learning.

Feel free to fork, improve, or adapt.

