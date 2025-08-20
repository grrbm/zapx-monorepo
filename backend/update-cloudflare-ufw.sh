#!/usr/bin/env bash
set -e

echo "[INFO] Cleaning up old Cloudflare rules..."

# Get current Cloudflare IPv4 and IPv6 ranges
CF4=$(curl -fsSL https://www.cloudflare.com/ips-v4)
CF6=$(curl -fsSL https://www.cloudflare.com/ips-v6)

remove_cf_rules_for_ip() {
    local ip="$1"
    # Extract all matching rule numbers for this IP
    nums=$(sudo ufw status numbered | grep "$ip" | sed -E 's/^\[ *([0-9]+) *\].*/\1/' | sort -rn)
    for num in $nums; do
        echo "Removing: $ip (rule #$num)"
        sudo ufw --force delete "$num" > /dev/null
    done
}

# Remove IPv4
for ip in $CF4; do
    remove_cf_rules_for_ip "$ip"
done

# Remove IPv6
for ip in $CF6; do
    remove_cf_rules_for_ip "$ip"
done

echo "[INFO] Adding fresh Cloudflare rules..."
sudo ufw allow 22/tcp > /dev/null

# Add IPv4
for ip in $CF4; do
    sudo ufw allow proto tcp from "$ip" to any port 80 comment 'cloudflare'
    sudo ufw allow proto tcp from "$ip" to any port 443 comment 'cloudflare'
done

# Add IPv6
for ip in $CF6; do
    sudo ufw allow proto tcp from "$ip" to any port 80 comment 'cloudflare'
    sudo ufw allow proto tcp from "$ip" to any port 443 comment 'cloudflare'
done

sudo ufw reload > /dev/null
echo "[SUCCESS] Cloudflare rules cleaned and re-added without duplicates."
