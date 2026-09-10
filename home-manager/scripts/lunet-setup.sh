#!/usr/bin/env bash
#
# lunet-setup: interactive helper that builds a working WPA2-Enterprise
# connection profile for Lamar University's "LUnet" SSID via NetworkManager.
#
# Why this exists:
#   The Cloudpath config ships its trusted CAs as several separate .cer files
#   (AAA Certificate Services, USERTrust RSA, InCommon RSA Server CA) and the
#   default profile only references ONE of them. wpa_supplicant then fails the
#   EAP-TLS server-certificate check with "self-signed certificate in
#   certificate chain / unknown CA", which looks exactly like a wrong password
#   but is actually a missing CA chain. The fix is to point 802-1x.ca-cert at a
#   bundle containing ALL CAs in Lamar's certificate chain.

set -euo pipefail

SSID="LUnet"
SERVER_DOMAIN="wifi.lamar.edu"
CON_NAME="LUnet"
CA_DIR_DEFAULT="/etc/ssl/certs/lunet"

IFACE=""
CA_DIR=""
LEA_USER=""

red() { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
info() { printf '==> %s\n' "$*"; }
die() { red "error: $*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: lunet-setup [-i IFACE] [-u USERNAME] [-c CA_DIR]

Sets up a WPA2-Enterprise NetworkManager profile for Lamar's LUnet wifi.
All options can also be entered interactively when omitted.

  -i, --iface IFACE     Wireless interface (e.g. wlan0)
  -u, --user USERNAME   LEA username (e.g. jdoe12 or jdoe12@lamar.edu)
  -c, --ca-dir DIR      Directory containing Lamar's .cer CA files
                        (default: ${CA_DIR_DEFAULT})
  -h, --help            Show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    -i|--iface) IFACE="${2:-}"; shift 2 ;;
    -u|--user) LEA_USER="${2:-}"; shift 2 ;;
    -c|--ca-dir) CA_DIR="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option '$1' (see --help)" ;;
  esac
done

command -v nmcli >/dev/null 2>&1 || die "nmcli not found; is NetworkManager installed?"

if command -v systemctl >/dev/null 2>&1 && \
   ! systemctl is-active --quiet NetworkManager 2>/dev/null; then
  die "NetworkManager service is not running (try: sudo systemctl start NetworkManager)."
fi

if command -v rfkill >/dev/null 2>&1 && rfkill list wifi 2>/dev/null | grep -qi 'Soft blocked: yes'; then
  yellow "wifi radio is soft-blocked; unblocking..."
  rfkill unblock wifi
fi

# ---------------------------------------------------------------------------
# 1. Pick the wireless interface
# ---------------------------------------------------------------------------
if [ -z "$IFACE" ]; then
  mapfile -t WIFI_IFACES < <(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi" {print $1}')
  if [ "${#WIFI_IFACES[@]}" -eq 0 ]; then
    die "no wireless interfaces found."
  elif [ "${#WIFI_IFACES[@]}" -eq 1 ]; then
    IFACE="${WIFI_IFACES[0]}"
    info "using wireless interface: $IFACE"
  else
    echo "Available wireless interfaces:"
    printf '  - %s\n' "${WIFI_IFACES[@]}"
    echo
    read -r -p "Wireless interface to bind the profile to: " IFACE
  fi
fi

[ -n "$IFACE" ] || die "an interface is required."
nmcli -t -f DEVICE,TYPE dev | grep -qix "${IFACE}:wifi" \
  || die "'$IFACE' is not a known wireless interface."

# ---------------------------------------------------------------------------
# 1b. Handle a pre-existing profile instead of silently nuking it
# ---------------------------------------------------------------------------
if nmcli -t -f NAME connection show | grep -qx "${CON_NAME}"; then
  echo
  yellow "A '${CON_NAME}' connection profile already exists."
  echo "  [u] Update password only (keeps the existing CA bundle/settings)"
  echo "  [r] Recreate from scratch (delete and rebuild everything)"
  echo "  [c] Cancel and exit"
  while true; do
    read -r -p "Choice [u/r/c]: " CHOICE
    case "$CHOICE" in
      [Uu]*)
        if [ -z "$LEA_USER" ]; then
          EXISTING_USER="$(nmcli -g 802-1x.identity connection show "$CON_NAME" 2>/dev/null)"
          read -r -p "LEA username [${EXISTING_USER}]: " LEA_USER
          LEA_USER="${LEA_USER:-$EXISTING_USER}"
        fi
        [ -n "$LEA_USER" ] || die "a username is required."

        while true; do
          read -r -s -p "LEA password: " LEA_PASS
          echo
          [ -n "$LEA_PASS" ] || { yellow "password cannot be empty."; continue; }
          read -r -s -p "Confirm password: " LEA_PASS_CONFIRM
          echo
          [ "$LEA_PASS" = "$LEA_PASS_CONFIRM" ] && break
          yellow "passwords did not match, try again."
        done

        info "Updating credentials on existing '${CON_NAME}' profile..."
        nmcli connection modify "$CON_NAME" \
          802-1x.identity "$LEA_USER" \
          802-1x.password "$LEA_PASS" >/dev/null
        unset LEA_PASS LEA_PASS_CONFIRM
        SKIP_TO_ACTIVATE=1
        break
        ;;
      [Rr]*)
        yellow "deleting existing '${CON_NAME}' connection profile."
        nmcli connection delete "$CON_NAME" >/dev/null
        break
        ;;
      [Cc]*)
        info "cancelled, no changes made."
        exit 0
        ;;
      *) yellow "please answer u, r, or c." ;;
    esac
  done
fi

if [ "${SKIP_TO_ACTIVATE:-0}" != "1" ]; then

# ---------------------------------------------------------------------------
# 2. Locate / build the CA bundle
# ---------------------------------------------------------------------------
if [ -z "$CA_DIR" ]; then
  CA_DIR="$CA_DIR_DEFAULT"
  if [ ! -d "$CA_DIR" ]; then
    for candidate in "$HOME/Downloads/lunet" "$HOME/.config/lunet" "$(pwd)"; do
      if [ -d "$candidate" ] && find "$candidate" -maxdepth 1 -iname '*.cer' -type f -print -quit | grep -q .; then
        CA_DIR="$candidate"
        break
      fi
    done
  fi
  read -r -p "Directory containing Lamar CA .cer files [${CA_DIR}]: " CA_DIR_INPUT
  CA_DIR="${CA_DIR_INPUT:-$CA_DIR}"
fi

[ -d "$CA_DIR" ] || die "directory '$CA_DIR' does not exist."

BUNDLE="${CA_DIR}/ca-bundle.cer"
if [ ! -f "$BUNDLE" ]; then
  TMP_BUNDLE="$(mktemp)"
  trap 'rm -f "$TMP_BUNDLE"' EXIT
  CERTS_FOUND=0
  while IFS= read -r -d '' f; do
    [[ "$(basename "$f")" == "ca-bundle.cer" ]] && continue
    cat "$f" >> "$TMP_BUNDLE"
    CERTS_FOUND=$((CERTS_FOUND + 1))
  done < <(find "$CA_DIR" -maxdepth 1 -iname '*.cer' -type f -print0 | sort -z)

  [ "$CERTS_FOUND" -gt 0 ] || die "no .cer files found in '$CA_DIR'."

  if sudo -n true 2>/dev/null || [ -w "$CA_DIR" ]; then
    sudo cp "$TMP_BUNDLE" "$BUNDLE" 2>/dev/null || cp "$TMP_BUNDLE" "$BUNDLE"
    sudo chmod 644 "$BUNDLE" 2>/dev/null || chmod 644 "$BUNDLE"
  else
    mkdir -p "${HOME}/.config/lunet"
    BUNDLE="${HOME}/.config/lunet/ca-bundle.cer"
    cp "$TMP_BUNDLE" "$BUNDLE"
  fi
  rm -f "$TMP_BUNDLE"
  trap - EXIT
  green "Built CA bundle from $CERTS_FOUND certificate(s): $BUNDLE"
else
  info "Using existing CA bundle: $BUNDLE"
fi

# ---------------------------------------------------------------------------
# 3. Ask for the LEA credentials (password hidden while typing)
# ---------------------------------------------------------------------------
if [ -z "$LEA_USER" ]; then
  read -r -p "LEA username (e.g. jdoe12 or jdoe12@lamar.edu): " LEA_USER
fi
[ -n "$LEA_USER" ] || die "a username is required."

while true; do
  read -r -s -p "LEA password: " LEA_PASS
  echo
  [ -n "$LEA_PASS" ] || { yellow "password cannot be empty."; continue; }
  read -r -s -p "Confirm password: " LEA_PASS_CONFIRM
  echo
  [ "$LEA_PASS" = "$LEA_PASS_CONFIRM" ] && break
  yellow "passwords did not match, try again."
done

# ---------------------------------------------------------------------------
# 4. Create the NetworkManager profile
# ---------------------------------------------------------------------------
info "Creating WPA2-Enterprise profile '${CON_NAME}' for SSID '${SSID}'..."
nmcli connection add \
  type wifi \
  con-name "$CON_NAME" \
  ifname "$IFACE" \
  802-11-wireless.ssid "$SSID" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.phase2-auth mschapv2 \
  802-1x.identity "$LEA_USER" \
  802-1x.password "$LEA_PASS" \
  802-1x.password-flags 0 \
  802-1x.ca-cert "$BUNDLE" \
  802-1x.domain-suffix-match "$SERVER_DOMAIN" >/dev/null

unset LEA_PASS LEA_PASS_CONFIRM

fi # SKIP_TO_ACTIVATE

BUNDLE="${BUNDLE:-$(nmcli -g 802-1x.ca-cert connection show "$CON_NAME" 2>/dev/null)}"

# ---------------------------------------------------------------------------
# 5. Bring it up
# ---------------------------------------------------------------------------
info "Activating '${CON_NAME}' on ${IFACE}..."
if nmcli connection up "$CON_NAME" ifname "$IFACE" >/dev/null; then
  echo
  green "Connected to LUnet."
  IP="$(nmcli -g IP4.ADDRESS dev show "$IFACE" 2>/dev/null | head -n1)"
  [ -n "$IP" ] && echo "  IP address: $IP"
  if ping -c1 -W2 8.8.8.8 >/dev/null 2>&1; then
    green "  Internet reachable."
  else
    yellow "  Warning: connected but internet is not reachable yet; it may take a few seconds."
  fi
else
  echo
  red "Failed to activate '${CON_NAME}'."
  cat <<EOF
Common causes:
  - Wrong username/password (re-run and double-check both).
  - Missing CA in the bundle: verify $BUNDLE contains every .cer from Lamar's
    Cloudpath package (AAA Certificate Services, USERTrust RSA, InCommon RSA
    Server CA).
  - Out of range / SSID not visible: run 'nmcli dev wifi list' to confirm
    LUnet is visible from here.

For details: journalctl -u NetworkManager -n 50 --no-pager
EOF
  exit 1
fi
