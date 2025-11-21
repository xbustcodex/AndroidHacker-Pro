![AndroidHacker Pro v1.0](androidhacker_banner.png)

# AndroidHacker Pro v1.0 🐉  
_All-in-One Termux Hacker Shell (Legal / Educational Use Only)_

**AndroidHacker Pro** is a high-level, menu-driven shell for **Termux** that combines  
system info, network recon, web/DNS tools, OSINT helpers and crypto utilities  
into one clean interface.

It does **not** ship with exploits or malware.  
Everything is built around standard Linux/Termux tools.

---

<p align="center">
  <img src="https://img.shields.io/badge/version-v1.0-blue.svg" />
  <img src="https://img.shields.io/badge/shell-bash-success.svg" />
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20Termux-orange.svg" />
  <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" />
</p>

---

## ✨ Features

### 🧰 Quick Setup
- Update & upgrade Termux
- Install recommended tools:
  - `git`, `curl`, `wget`, `python`
  - `nmap`, `dnsutils`, `net-tools`, `iproute2`
  - `openssh`, `openssl`, `traceroute` (on demand)
- One-click environment prep for Android security & networking work

### 📱 System & Device Info
- Android model, manufacturer, build ID
- Android version & SDK level
- Interfaces & IP addresses (`ip addr` / `ifconfig`)
- Routing table (`ip route` / `netstat`)

### 🌐 Network Recon
- Ping host
- Traceroute
- Fast port scan:
  - Uses `nmap -sV -T4` if available
  - Falls back to a simple TCP port sweep if `nmap` is missing
- HTTP banner / header grab using `curl -I`

### 📡 WiFi / LAN Helper
- Show interfaces & IPs
- Show ARP/neighbour table
- Optional local subnet scan with `nmap -sn`  
  (with a clear **“only scan what you own / have permission for”** warning)

### 🌍 Web & DNS Recon
- DNS lookup via `dig` or `nslookup`
- WHOIS lookup (installs `whois` if missing)
- HTTP header fetch

### 🕵 OSINT Helper
- Generate an OSINT profile note file for a username/handle:
  - Pre-filled with common places to check (GitHub, X/Twitter, Reddit, etc.)
  - Stored in the reports directory
- Print ready-to-copy OSINT links for any handle

### 🔐 Crypto / Encoding Tools
- Base64 encode
- Base64 decode
- Quick hashing:
  - MD5
  - SHA1
  - SHA256

---

## 📂 Reports & Output

AndroidHacker Pro stores reports under:

```text
~/androidhacker_reports

Examples:

system_info_YYYYMMDD_HHMMSS.txt

portscan_YYYYMMDD_HHMMSS.txt

osint_profile_YYYYMMDD_HHMMSS.txt



---

📥 Requirements

Android device

Termux (F-Droid build recommended)


Inside Termux:

pkg update && pkg upgrade -y
pkg install -y bash coreutils

You’ll also want many of the tools installed by the built-in Quick Setup menu.


---

🚀 Installation

Clone or download the script into your Termux home:

cd ~
curl -O https://raw.githubusercontent.com/xbustcodex/AndroidHacker-Pro/main/androidhacker_pro.sh
chmod +x androidhacker_pro.sh

Run:

bash androidhacker_pro.sh
# or
./androidhacker_pro.sh

Optional alias:

echo 'alias androidhacker="bash ~/androidhacker_pro.sh"' >> ~/.bashrc
source ~/.bashrc

Now you can start it with:

androidhacker


---

🧭 Main Menu Overview

1) Quick setup (install tools)
2) System & device info
3) Network recon
4) WiFi / LAN helper
5) Web & DNS recon
6) OSINT helper
7) Crypto / encoding tools
0) Exit

Each submenu is interactive and most modules can generate reports under
~/androidhacker_reports for later analysis.


---

⚖ Legal & Ethical Use

AndroidHacker Pro is designed for:

Learning networking and security

Testing your own devices and networks

Lab environments, training and education


You must only scan systems you own or have clear, written permission to test.

The author is not responsible for any misuse, damage, or violations resulting from the use of this toolkit.
By using this project you agree to follow all local laws and regulations.


---
🛣 Roadmap

Planned ideas for future versions:

Plugin-style module system

HTML / Markdown report export

Integration with:

DroidRecon Pro

DroidGuardian Toolkit

AndroidBoost Pro


Colorized UI and key-bindings for faster navigation


Contributions, ideas and issues are welcome 🎯
