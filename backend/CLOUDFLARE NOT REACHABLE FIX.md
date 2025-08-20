If you want to be absolutely sure Cloudflare never fronts this host again, leave the record DNS‑only. If you prefer the benefits of Cloudflare (caching, WAF, SSL), keep the orange cloud but:

# Example: allow Cloudflare IPv4 ranges on your server (ufw)
for ip in $(curl -s https://www.cloudflare.com/ips-v4); do sudo ufw allow from $ip proto tcp to any port 80,443; done

## UPDATE
THE EXAMPLE ABOVE IS NOT ENOUGH ANYMORE; Instead:

run this command:
    sudo ./update-cloudflare-ufw.sh 

(this is the exact syntax ! don't try "sh update-cloudflare-ufw.sh" it will not work.)

This will remove all cloudflare past IP rules, and add the new ones.
This is essential. because if we duplicate any Allow rules, the firewall amazingly will also block requests !!

## Check origin reachability (if you keep proxy on)	

Open firewall/ security‑group to ALL Cloudflare IP ranges (IPv4 + IPv6).	

## CF list:

https://www.cloudflare.com/ips/


