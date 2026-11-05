# HomeLAN: DHCP, with fixed addresses for Sonos, Hue and the work laptop
# (the work laptop's address is what its isolation rule is about).

/ip pool
add name=pool_homelan ranges=192.168.1.10-192.168.1.253 comment="HomeLAN DHCP"

/ip dhcp-server
add name=dhcp_homelan interface=HomeLAN address-pool=pool_homelan add-dns-entries=yes comment="HomeLAN DHCP"

/ip dhcp-server network
add address=192.168.1.0/24 gateway=192.168.1.254 dns-server=192.168.1.254 ntp-server=192.168.1.254 \
    domain=home.lan comment="HomeLAN - unchanged gateway/DNS/NTP"

/ip dhcp-server lease
add address=192.168.1.104 mac-address=00:17:88:A7:38:33 server=dhcp_homelan comment="Philips Hue Bridge v2"
add address=192.168.1.201 mac-address=38:42:0B:9E:58:F2 server=dhcp_homelan comment="Sonos Symfonisk Kitchen (Left)"
add address=192.168.1.202 mac-address=38:42:0B:9E:4B:26 server=dhcp_homelan comment="Sonos Symfonisk Kitchen (Right)"
add address=192.168.1.203 mac-address=78:28:CA:D3:E2:8C server=dhcp_homelan comment="Sonos Symfonisk Lamp Main bedroom (Left)"
add address=192.168.1.204 mac-address=78:28:CA:D4:37:88 server=dhcp_homelan comment="Sonos Symfonisk Lamp Main bedroom (Right)"
add address=192.168.1.211 mac-address=38:42:0B:1F:CE:22 server=dhcp_homelan comment="Sonos One SL Office (Left)"
add address=192.168.1.212 mac-address=38:42:0B:1F:CE:E0 server=dhcp_homelan comment="Sonos One SL Office (Right)"
add address=192.168.1.240 mac-address=C4:38:75:C3:F7:56 server=dhcp_homelan comment="Sonos Roam2"
add address=192.168.1.241 mac-address=54:2A:1B:53:1E:E0 server=dhcp_homelan comment="Sonos Symfonisk Lamp (gen2) Ursula Bedroom"
add address=192.168.1.17 mac-address=BC:D0:74:11:07:2D client-id=1:bc:d0:74:11:07:2d server=dhcp_homelan \
    comment="MALICIOUS WORK DEVICE - MacBook (isolated: see 50-firewall-isolation.rsc)"
