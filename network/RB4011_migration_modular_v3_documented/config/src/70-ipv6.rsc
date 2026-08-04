# Native EE IPv6 via DHCPv6 Prefix Delegation plus stable ULA.
#
# The delegated prefix remains dynamic.
# A /56 prefix hint is requested; the actual EE delegation is authoritative.

/ipv6 settings
set disable-ipv6=no forward=yes accept-redirects=no accept-router-advertisements=no

/ipv6 dhcp-client
add interface=pppoe-ee request=prefix prefix-hint=::/56 pool-name=ee-pd pool-prefix-length=64 add-default-route=yes use-peer-dns=no comment="EE IPv6 DHCPv6-PD"

/ipv6 address
add address=fd00:50::1/64 interface=HomeLAN advertise=yes comment="HomeLAN ULA"
add address=fd00:10::1/64 interface=vlan10_tenant advertise=yes comment="Tenant 10 ULA"
add address=fd00:20::1/64 interface=vlan20_tenant advertise=yes comment="Tenant 20 ULA"
add address=fd00:30::1/64 interface=vlan30_tenant advertise=no comment="Tenant 30 ULA"
add address=fd00:40::1/64 interface=vlan40_tenant advertise=yes comment="Tenant 40 ULA"
add address=fd00:88::1/64 interface=vlan88_mgmt advertise=yes comment="Management ULA"

/ipv6 address
add from-pool=ee-pd interface=HomeLAN advertise=yes comment="HomeLAN EE delegated /64"
add from-pool=ee-pd interface=vlan10_tenant advertise=yes comment="Tenant 10 EE delegated /64"
add from-pool=ee-pd interface=vlan20_tenant advertise=yes comment="Tenant 20 EE delegated /64"
add from-pool=ee-pd interface=vlan30_tenant advertise=yes comment="Tenant 30 EE delegated /64"
add from-pool=ee-pd interface=vlan40_tenant advertise=yes comment="Tenant 40 EE delegated /64"
add from-pool=ee-pd interface=vlan88_mgmt advertise=yes comment="Management EE delegated /64"

/ipv6 nd
add interface=HomeLAN advertise-dns=yes dns-servers=fd00:50::1 comment="HomeLAN RA"
add interface=vlan10_tenant advertise-dns=yes dns-servers=fd00:10::1 comment="Tenant 10 RA"
add interface=vlan20_tenant advertise-dns=yes dns-servers=fd00:20::1 comment="Tenant 20 RA"
add interface=vlan30_tenant advertise-dns=yes dns-servers=fd00:30::1 comment="Tenant 30 RA"
add interface=vlan40_tenant advertise-dns=yes dns-servers=fd00:40::1 comment="Tenant 40 RA"
add interface=vlan88_mgmt advertise-dns=yes dns-servers=fd00:88::1 comment="Management RA"
