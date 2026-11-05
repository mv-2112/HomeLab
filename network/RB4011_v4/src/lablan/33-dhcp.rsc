# LabLAN: DHCP on management only. The cloud VLANs have none: OpenStack
# allocates every address on them.

/ip pool
add name=pool_mgmt ranges=192.168.88.10-192.168.88.159 comment="Management DHCP (.160+ static, APIs, hardware)"

/ip dhcp-server
add name=dhcp_mgmt interface=vlan88_mgmt address-pool=pool_mgmt add-dns-entries=yes \
    add-dns-entries-suffix=lab.home.arpa comment="Management DHCP"

/ip dhcp-server network
add address=192.168.88.0/24 gateway=192.168.88.1 dns-server=192.168.88.1 ntp-server=192.168.88.1 \
    domain=lab.home.arpa comment="Management"

# Fallback only: the hosts set eno1 statically in netplan (a DHCP lease that
# can't renew while the router is down would take the cloud with it).
# Matched by MAC, not client-id: a rebuilt host gets a new DUID-based client-id.
/ip dhcp-server lease
add address=192.168.88.253 mac-address=48:0F:CF:54:A6:3D server=dhcp_mgmt comment="mz640 eno1"
add address=192.168.88.252 mac-address=50:65:F3:2F:0A:A8 server=dhcp_mgmt comment="mz640test eno1"
