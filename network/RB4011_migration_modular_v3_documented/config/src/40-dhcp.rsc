# DHCP services.

/ip pool
add name=pool_homelan ranges=192.168.1.10-192.168.1.253 comment="HomeLAN DHCP"
add name=pool_tenant10 ranges=192.168.10.10-192.168.10.254 comment="Tenant 10 DHCP"
add name=pool_tenant20 ranges=192.168.20.10-192.168.20.254 comment="Tenant 20 DHCP"
add name=pool_tenant30 ranges=192.168.30.10-192.168.30.254 comment="Tenant 30 DHCP"
add name=pool_mgmt ranges=192.168.88.10-192.168.88.254 comment="Management DHCP"

/ip dhcp-server
add name=dhcp_homelan interface=HomeLAN address-pool=pool_homelan add-dns-entries=yes comment="HomeLAN DHCP"
add name=dhcp_t10 interface=vlan10_tenant address-pool=pool_tenant10 add-dns-entries=yes add-dns-entries-suffix=openstack1.lan comment="Tenant 10 DHCP"
add name=dhcp_t20 interface=vlan20_tenant address-pool=pool_tenant20 add-dns-entries=yes comment="Tenant 20 DHCP"
add name=dhcp_t30 interface=vlan30_tenant address-pool=pool_tenant30 add-dns-entries=yes comment="Tenant 30 DHCP"
add name=dhcp_mgmt interface=vlan88_mgmt address-pool=pool_mgmt add-dns-entries=yes comment="Management DHCP"

/ip dhcp-server network
add address=192.168.1.0/24 gateway=192.168.1.254 dns-server=192.168.1.254 ntp-server=192.168.1.254 domain=home.lan comment="HomeLAN - unchanged gateway/DNS/NTP"
add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=192.168.10.1 domain=openstack1.lan comment="Tenant 10"
add address=192.168.20.0/24 gateway=192.168.20.1 dns-server=192.168.20.1 domain=lan comment="Tenant 20"
add address=192.168.30.0/24 gateway=192.168.30.1 dns-server=192.168.30.1 domain=lan comment="Tenant 30"
add address=192.168.88.0/24 gateway=192.168.88.1 dns-server=192.168.88.1 domain=mgmt.lan comment="Management"
