# IPv4 addressing. HomeLAN identity is intentionally unchanged.

/ip address
add address=192.168.1.254/24 interface=HomeLAN comment="HomeLAN gateway/DNS/NTP - preserve existing client configuration"
add address=192.168.88.1/24 interface=vlan88_mgmt comment="Management LAN gateway"
add address=192.168.10.1/24 interface=vlan10_tenant comment="OpenStack tenant #1 gateway"
add address=192.168.20.1/24 interface=vlan20_tenant comment="OpenStack tenant #2 gateway"
add address=192.168.30.1/24 interface=vlan30_tenant comment="OpenStack tenant #3 gateway"

# VLAN 40 deliberately has no IPv4 address, matching the source export.
