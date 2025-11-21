#!/usr/bin/env bash
# AndroidHacker Pro v1.0
# All-in-One Termux Hacker Shell (educational & legal use only)
# by xbustcodex

VERSION="1.0"
BASE_DIR="$HOME/androidhacker_reports"

# ---------- helpers ----------

banner() {
  clear
  echo "============================================================="
  echo "              AndroidHacker Pro v$VERSION                    "
  echo "           All-in-One Termux Hacker Shell                    "
  echo "============================================================="
  echo
  echo " Legal / Education only. Only scan systems you own or have"
  echo " explicit, written permission to test."
  echo
}

pause() {
  echo
  read -p "Press Enter to continue..." _
}

timestamp() {
  date +%Y%m%d_%H%M%S
}

ensure_dirs() {
  mkdir -p "$BASE_DIR"
}

log_to_file() {
  local file="$1"
  echo "[+] Output logged to: $file"
}

# ---------- module: quick setup ----------

quick_setup() {
  banner
  echo "[*] Quick setup will update Termux and install recommended tools."
  echo "    Packages: git, curl, wget, python, nmap, dnsutils, openssh,"
  echo "              net-tools, iproute2, tsu (optional root), openssl"
  echo
  read -p "Proceed? [y/N]: " ans
  case "$ans" in
    y|Y)
      pkg update && pkg upgrade -y
      pkg install -y git curl wget python nmap dnsutils openssh net-tools iproute2 openssl tsu
      echo
      echo "[+] Setup complete."
      ;;
    *)
      echo "[-] Setup cancelled."
      ;;
  esac
  pause
}

# ---------- module: system info ----------

system_info() {
  ensure_dirs
  local ts report
  ts="$(timestamp)"
  report="$BASE_DIR/system_info_$ts.txt"

  {
    echo "AndroidHacker Pro v$VERSION - System & Device Info"
    echo "Generated: $(date)"
    echo
    echo "=== Device Info (getprop) ==="
    echo "Model:          $(getprop ro.product.model)"
    echo "Manufacturer:   $(getprop ro.product.manufacturer)"
    echo "Device:         $(getprop ro.product.device)"
    echo "Android Ver:    $(getprop ro.build.version.release)"
    echo "SDK Level:      $(getprop ro.build.version.sdk)"
    echo "Build ID:       $(getprop ro.build.id)"
    echo
    echo "=== IP / Interfaces (ip addr) ==="
    if command -v ip >/dev/null 2>&1; then
      ip addr show
    else
      ifconfig 2>/dev/null || echo "ip/ifconfig not available."
    fi
    echo
    echo "=== Routing Table ==="
    if command -v ip >/dev/null 2>&1; then
      ip route show
    else
      netstat -rn 2>/dev/null || echo "ip/netstat not available."
    fi
  } | tee "$report"

  log_to_file "$report"
  pause
}

# ---------- module: network recon ----------

net_ping_host() {
  read -p "Target host/IP to ping: " target
  [ -z "$target" ] && echo "No target." && return
  ping -c 4 "$target"
}

net_traceroute() {
  read -p "Target host/IP for traceroute: " target
  [ -z "$target" ] && echo "No target." && return
  if command -v traceroute >/dev/null 2>&1; then
    traceroute "$target"
  else
    echo "traceroute not installed. Installing..."
    pkg install -y traceroute
    traceroute "$target"
  fi
}

net_port_scan() {
  ensure_dirs
  local ts report
  ts="$(timestamp)"
  report="$BASE_DIR/portscan_$ts.txt"

  read -p "Target host/IP for port scan: " target
  [ -z "$target" ] && echo "No target." && return

  echo
  echo "!! Only scan systems you own or have permission to test !!"
  echo
  read -p "Type 'YES' to confirm you have permission: " conf
  [ "$conf" != "YES" ] && echo "Cancelled." && return

  if command -v nmap >/dev/null 2>&1; then
    echo "[*] Running nmap -sV -T4 $target (common ports)..."
    echo "nmap -sV -T4 $target" | tee "$report"
    nmap -sV -T4 "$target" | tee -a "$report"
  else
    echo "[-] nmap not installed, using basic nc (20-1024)."
    echo "Basic nc scan against $target (ports 20-1024)" | tee "$report"
    for p in $(seq 20 1024); do
      echo -en "\rScanning port $p..."
      timeout 0.3 bash -c "</dev/tcp/$target/$p" >/dev/null 2>&1 && echo -e "\nPort $p open" | tee -a "$report"
    done
    echo
  fi

  log_to_file "$report"
  pause
}

net_http_banner() {
  read -p "Target URL (e.g. https://example.com): " url
  [ -z "$url" ] && echo "No URL." && return
  echo
  echo "[*] Fetching HTTP headers..."
  curl -I "$url" 2>/dev/null || echo "curl error."
  pause
}

network_recon_menu() {
  while true; do
    banner
    echo "Network Recon"
    echo "-------------"
    echo "1) Ping host"
    echo "2) Traceroute"
    echo "3) Fast port scan (nmap / basic)"
    echo "4) HTTP banner (headers)"
    echo "0) Back"
    echo
    read -p "Select: " c
    case "$c" in
      1) net_ping_host ;;
      2) net_traceroute ;;
      3) net_port_scan ;;
      4) net_http_banner ;;
      0) break ;;
      *) echo "Invalid." ; pause ;;
    esac
  done
}

# ---------- module: WiFi / LAN ----------

wifi_lan_menu() {
  while true; do
    banner
    echo "WiFi / LAN Helper"
    echo "-----------------"
    echo "1) Show interfaces & IPs"
    echo "2) Show ARP / neighbours"
    echo "3) Quick local subnet scan (nmap, if available)"
    echo "0) Back"
    echo
    read -p "Select: " c
    case "$c" in
      1)
        if command -v ip >/dev/null 2>&1; then
          ip addr show
        else
          ifconfig 2>/dev/null || echo "ip/ifconfig not available."
        fi
        pause
        ;;
      2)
        if command -v ip >/dev/null 2>&1; then
          ip neigh show || echo "No neighbour info."
        else
          arp -a 2>/dev/null || echo "arp not available."
        fi
        pause
        ;;
      3)
        if ! command -v nmap >/dev/null 2>&1; then
          echo "nmap not installed. Install via quick setup."
          pause
          continue
        fi
        read -p "Local subnet (e.g. 192.168.1.0/24): " subnet
        [ -z "$subnet" ] && echo "No subnet." && pause && continue
        echo
        echo "!! Only scan networks you own or have permission to test !!"
        read -p "Type 'YES' to confirm: " conf
        [ "$conf" != "YES" ] && echo "Cancelled." && pause && continue
        nmap -sn "$subnet"
        pause
        ;;
      0) break ;;
      *) echo "Invalid." ; pause ;;
    esac
  done
}

# ---------- module: Web & DNS recon ----------

dns_lookup() {
  read -p "Domain: " domain
  [ -z "$domain" ] && echo "No domain." && return
  if command -v dig >/dev/null 2>&1; then
    dig "$domain" +short
  elif command -v nslookup >/dev/null 2>&1; then
    nslookup "$domain"
  else
    echo "dnsutils not installed. Try: pkg install dnsutils"
  fi
}

whois_lookup() {
  read -p "Domain or IP for WHOIS: " who
  [ -z "$who" ] && echo "No target." && return
  if ! command -v whois >/dev/null 2>&1; then
    echo "whois not installed. Installing..."
    pkg install -y whois
  fi
  whois "$who"
}

http_headers() {
  net_http_banner
}

web_dns_menu() {
  while true; do
    banner
    echo "Web & DNS Recon"
    echo "----------------"
    echo "1) DNS lookup"
    echo "2) WHOIS lookup"
    echo "3) HTTP headers"
    echo "0) Back"
    echo
    read -p "Select: " c
    case "$c" in
      1) dns_lookup ; pause ;;
      2) whois_lookup ; pause ;;
      3) http_headers ;;
      0) break ;;
      *) echo "Invalid." ; pause ;;
    esac
  done
}

# ---------- module: OSINT helper ----------

osint_profile_note() {
  ensure_dirs
  local ts file
  ts="$(timestamp)"
  file="$BASE_DIR/osint_profile_$ts.txt"

  read -p "Username / handle to profile: " handle
  [ -z "$handle" ] && echo "No handle." && return

  {
    echo "OSINT Profile Note"
    echo "Handle: $handle"
    echo "Generated: $(date)"
    echo
    echo "=== Suggested places to check ==="
    echo "- GitHub: https://github.com/$handle"
    echo "- Twitter/X: https://x.com/$handle"
    echo "- Instagram: https://instagram.com/$handle"
    echo "- Reddit: https://reddit.com/user/$handle"
    echo "- TikTok: https://www.tiktok.com/@$handle"
    echo "- Misc: search \"$handle\" on your favourite engine"
    echo
    echo "Notes:"
    echo "- "
  } > "$file"

  echo "[+] Profile note created at: $file"
  pause
}

osint_links() {
  read -p "Username / handle: " handle
  [ -z "$handle" ] && echo "No handle." && return
  echo
  echo "Copy / open these links in your browser:"
  echo "GitHub:     https://github.com/$handle"
  echo "X (Twitter): https://x.com/$handle"
  echo "Instagram:  https://instagram.com/$handle"
  echo "Reddit:     https://reddit.com/user/$handle"
  echo "TikTok:     https://www.tiktok.com/@$handle"
  echo
  pause
}

osint_menu() {
  while true; do
    banner
    echo "OSINT Helper"
    echo "------------"
    echo "1) Create OSINT profile notes file"
    echo "2) Print common OSINT links for a handle"
    echo "0) Back"
    echo
    read -p "Select: " c
    case "$c" in
      1) osint_profile_note ;;
      2) osint_links ;;
      0) break ;;
      *) echo "Invalid." ; pause ;;
    esac
  done
}

# ---------- module: crypto / encoding ----------

crypto_base64_encode() {
  read -p "Text to base64-encode: " txt
  echo "$txt" | base64
}

crypto_base64_decode() {
  read -p "Base64 text to decode: " txt
  echo "$txt" | base64 -d 2>/dev/null || echo "Invalid base64."
}

crypto_hash() {
  read -p "Text to hash: " txt
  echo
  echo "1) MD5"
  echo "2) SHA1"
  echo "3) SHA256"
  read -p "Select hash type: " t
  case "$t" in
    1) echo -n "$txt" | md5sum 2>/dev/null || echo -n "$txt" | openssl md5 ;;
    2) echo -n "$txt" | sha1sum 2>/dev/null || echo -n "$txt" | openssl sha1 ;;
    3) echo -n "$txt" | sha256sum 2>/dev/null || echo -n "$txt" | openssl sha256 ;;
    *) echo "Unknown type." ;;
  esac
}

crypto_menu() {
  while true; do
    banner
    echo "Crypto / Encoding Tools"
    echo "-----------------------"
    echo "1) Base64 encode"
    echo "2) Base64 decode"
    echo "3) Quick hash (MD5/SHA1/SHA256)"
    echo "0) Back"
    echo
    read -p "Select: " c
    case "$c" in
      1) crypto_base64_encode ; pause ;;
      2) crypto_base64_decode ; pause ;;
      3) crypto_hash ; pause ;;
      0) break ;;
      *) echo "Invalid." ; pause ;;
    esac
  done
}

# ---------- main menu ----------

main_menu() {
  ensure_dirs
  while true; do
    banner
    echo "Reports directory: $BASE_DIR"
    echo
    echo "1) Quick setup (install tools)"
    echo "2) System & device info"
    echo "3) Network recon"
    echo "4) WiFi / LAN helper"
    echo "5) Web & DNS recon"
    echo "6) OSINT helper"
    echo "7) Crypto / encoding tools"
    echo "0) Exit"
    echo
    read -p "Select an option: " choice
    case "$choice" in
      1) quick_setup ;;
      2) system_info ;;
      3) network_recon_menu ;;
      4) wifi_lan_menu ;;
      5) web_dns_menu ;;
      6) osint_menu ;;
      7) crypto_menu ;;
      0) echo "Bye."; exit 0 ;;
      *) echo "Invalid choice."; pause ;;
    esac
  done
}

main_menu
